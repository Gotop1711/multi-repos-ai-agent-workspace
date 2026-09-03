#!/usr/bin/env bash
# workspace.sh — the whole harness in one script.
#   ./workspace.sh setup                 one-time: wire the safety hook, print what to do next
#   ./workspace.sh clone                 rebuild the fleet from catalog/repos.yaml
#   ./workspace.sh cite                  print the fleet as one citation line — paste into findings
#   ./workspace.sh restore <repo>@<sha>… check cited commits out (bare <repo> returns to its branch)
#   ./workspace.sh extract <scope> originals/<scope>/<file>…  text of a stored document → sources/<scope>/<file>.md
#   ./workspace.sh check                 verify the manifest and the document layer (session-init / pre-commit)
# Plain bash (macOS 3.2 ok), zero dependencies — extract alone uses macOS textutil, swift (PDFKit, Vision) and python3.
set -u
cd "$(dirname "$0")" || exit 1
MANIFEST="catalog/repos.yaml"
tmp=""; ocr=""; ooxml=""; trap 'rm -f "$tmp" "$ocr" "$ooxml"' EXIT

entries() { # one line per repo: id|path|remote|branch|access
  awk '
    function flush() { if (id != "") print id "|" path "|" remote "|" branch "|" access }
    /^- id:/                       { flush(); id=$3; path=""; remote=""; branch=""; access="" }
    /^[[:space:]]+path:/           { path=$2 }
    /^[[:space:]]+remote:/         { remote=$2 }
    /^[[:space:]]+default_branch:/ { branch=$2 }
    /^[[:space:]]+access:/         { access=$2 }
    END                            { flush() }
  ' "$MANIFEST"
}

cmd="${1:-help}"
case "$cmd" in clone|cite|restore|check|extract)
  [ -f "$MANIFEST" ] || { echo "FAIL: $MANIFEST missing" >&2; exit 1; }
esac

case "$cmd" in

setup)
  git config core.hooksPath .githooks
  echo "safety hook wired: every commit now runs './workspace.sh check' first."
  bash "$0" check || true
  echo
  echo "next steps:"
  if grep -qE '^- id:' "$MANIFEST" 2>/dev/null; then
    echo "  1. ./workspace.sh clone            # fleet appears under projects/"
  else
    echo "  1. edit catalog/repos.yaml         # declare your child repos + access levels"
    echo "  2. ./workspace.sh clone            # fleet appears under projects/"
  fi
  git remote | grep -q . \
    || echo "  •  add a PRIVATE remote for this repo and push — its memory must survive a dead disk"
  ;;

clone)
  tmp="$(mktemp)"; entries > "$tmp"
  if [ ! -s "$tmp" ]; then
    echo "nothing to clone yet — add your repos to catalog/repos.yaml first."
    exit 0
  fi
  fail=0
  while IFS='|' read -r id path remote branch access; do
    [ -n "$id" ] || continue
    if [ -d "$path/.git" ]; then echo "[$id] already cloned"; else
      echo "[$id] cloning $remote → $path"
      git clone --quiet --branch "$branch" "$remote" "$path" \
        || { echo "[$id] CLONE FAILED — continuing with the rest" >&2; fail=$((fail+1)); continue; }
    fi
    if [ "$access" = "read-only" ]; then
      git -C "$path" remote set-url --push origin DISALLOWED_READ_ONLY
      echo "[$id] read-only → push disabled"
    elif [ "$(git -C "$path" remote get-url --push origin 2>/dev/null)" = "DISALLOWED_READ_ONLY" ]; then
      git -C "$path" remote set-url --push origin "$remote"
      echo "[$id] access upgraded → push re-enabled"
    fi
  done < "$tmp"
  [ "$fail" -eq 0 ] && echo "fleet complete." || { echo "$fail repo(s) failed to clone." >&2; exit 1; }
  ;;

cite)
  tmp="$(mktemp)"; entries > "$tmp"
  [ -s "$tmp" ] || { echo "manifest has no repos — edit catalog/repos.yaml first" >&2; exit 1; }
  line=""
  while IFS='|' read -r id path remote branch access; do
    [ -n "$id" ] || continue
    [ -d "$path/.git" ] || { echo "[$id] not cloned — run ./workspace.sh clone" >&2; exit 1; }
    [ -z "$(git -C "$path" status --porcelain)" ] \
      || echo "warn: [$id] has local changes — its HEAD does not describe what you are reading" >&2
    line="$line $id@$(git -C "$path" rev-parse --short HEAD)"
  done < "$tmp"
  echo "${line# }"
  ;;

restore)
  shift
  if [ "$#" -eq 0 ]; then
    echo "usage: workspace.sh restore <repo>@<sha> [...]   # paste a finding's citations" >&2
    echo "       workspace.sh restore <repo> [...]         # back to the manifest branch" >&2
    exit 1
  fi
  tmp="$(mktemp)"; entries > "$tmp"
  fail=0
  # $* unquoted on purpose: a whole citation line pasted as ONE argument
  # (quotes, or a zsh variable) still splits into tokens
  for token in $*; do
    case "$token" in
      sources/*@*) echo "[$token] is a document citation — read it with: git show ${token#*@}" >&2; continue ;;
      */*|p.[0-9]*|L[0-9]*) continue ;;   # file / symbol locators on a pasted finding line
    esac
    id="${token%%@*}"; sha=""; [ "$token" != "$id" ] && sha="${token#*@}"
    path="$(awk -F'|' -v id="$id" '$1==id{print $2; exit}' "$tmp")"
    branch="$(awk -F'|' -v id="$id" '$1==id{print $4; exit}' "$tmp")"
    [ -n "$path" ] || { echo "[$id] not in the manifest" >&2; fail=$((fail+1)); continue; }
    [ -d "$path/.git" ] || { echo "[$id] not cloned — run ./workspace.sh clone" >&2; fail=$((fail+1)); continue; }
    if [ -n "$(git -C "$path" status --porcelain)" ]; then
      echo "[$id] has local changes — NOT touching it" >&2; fail=$((fail+1)); continue
    fi
    if [ -n "$sha" ]; then
      git -C "$path" checkout --quiet --detach "$sha" 2>/dev/null \
        && echo "[$id] → $sha (detached; './workspace.sh restore $id' returns to $branch)" \
        || { echo "[$id] RESTORE FAILED (sha $sha unreachable — history rewritten upstream?)" >&2; fail=$((fail+1)); }
    else
      git -C "$path" checkout --quiet "$branch" && echo "[$id] → $branch" \
        || { echo "[$id] RESTORE FAILED (branch $branch)" >&2; fail=$((fail+1)); }
    fi
  done
  [ "$fail" -eq 0 ] || { echo "restore: $fail repo(s) not restored." >&2; exit 1; }
  ;;

extract)
  # humans place originals in ./originals/<scope>/ (dated names); this only reads them and writes sources/<scope>/<name>.md
  shift; scope="${1:-}"; shift || true
  usage="usage: workspace.sh extract <scope> originals/<scope>/<file>…   (scope = a docs/<scope>.md id; RESTRICTED=<file> header only; OCR=<file> force OCR; SECRET_OK=<file> waive a false positive)"
  printf '%s' "$scope" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { echo "$usage" >&2; exit 1; }
  [ "$#" -gt 0 ] || { echo "$usage" >&2; exit 1; }
  [ -e originals ] || { echo "FAIL: ./originals missing — ln -s <your document store> originals" >&2; exit 1; }
  tmp="$(mktemp)"; cat > "$tmp" <<'SWIFT'
import Foundation
import PDFKit
guard CommandLine.arguments.count > 1, let d = PDFDocument(url: URL(fileURLWithPath: CommandLine.arguments[1])) else { exit(2) }
if d.isLocked { exit(3) }
for i in 0..<d.pageCount { print("<!-- page \(i+1) -->"); print(d.page(at: i)?.string ?? "") }
SWIFT
  ocr="$(mktemp)"; cat > "$ocr" <<'SWIFT'
import Foundation
import PDFKit
import Vision
import AppKit
let args = CommandLine.arguments
guard args.count > 1 else { exit(2) }
func ocr(_ cg: CGImage) -> [String] {
    let req = VNRecognizeTextRequest(); req.recognitionLevel = .accurate
    try? VNImageRequestHandler(cgImage: cg, options: [:]).perform([req])
    return (req.results ?? []).sorted { $0.boundingBox.minY > $1.boundingBox.minY }.compactMap { $0.topCandidates(1).first?.string }
}
if let doc = PDFDocument(url: URL(fileURLWithPath: args[1])) {
    for i in 0..<doc.pageCount {
        guard let page = doc.page(at: i) else { continue }
        let box = page.bounds(for: .mediaBox); let s: CGFloat = 200.0 / 72.0
        let img = page.thumbnail(of: CGSize(width: box.width * s, height: box.height * s), for: .mediaBox)
        print("<!-- page \(i+1) (ocr) -->")
        if let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) { ocr(cg).forEach { print($0) } }
    }
} else if let img = NSImage(contentsOfFile: args[1]), let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) {
    print("<!-- page 1 (ocr) -->"); ocr(cg).forEach { print($0) }
} else { exit(2) }
SWIFT
  ooxml="$(mktemp)"; cat > "$ooxml" <<'PY'
# ooxml-text: print the text of a .pptx (per slide) or .xlsx (per sheet, tab-separated) - python3 stdlib only
import sys, re, zipfile, xml.etree.ElementTree as ET
p = sys.argv[1]; z = zipfile.ZipFile(p)
A = '{http://schemas.openxmlformats.org/drawingml/2006/main}'
S = '{http://schemas.openxmlformats.org/spreadsheetml/2006/main}'
R = '{http://schemas.openxmlformats.org/officeDocument/2006/relationships}'
if p.lower().endswith('.pptx'):
    slides = sorted((n for n in z.namelist() if re.match(r'ppt/slides/slide\d+\.xml$', n)), key=lambda n: int(re.search(r'\d+', n).group()))
    for i, n in enumerate(slides, 1):
        print(f'<!-- slide {i} -->')
        for para in ET.fromstring(z.read(n)).iter(A + 'p'):
            t = ''.join(x.text or '' for x in para.iter(A + 't'))
            if t.strip(): print(t)
else:
    ss = []
    if 'xl/sharedStrings.xml' in z.namelist():
        for si in ET.fromstring(z.read('xl/sharedStrings.xml')).iter(S + 'si'):
            ss.append(''.join(x.text or '' for x in si.iter(S + 't')))
    rels = {r.get('Id'): r.get('Target') for r in ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))}
    for sh in ET.fromstring(z.read('xl/workbook.xml')).iter(S + 'sheet'):
        target = rels[sh.get(R + 'id')].lstrip('/'); path = target if target.startswith('xl/') else 'xl/' + target
        print(f"<!-- sheet {sh.get('name')} -->")
        for row in ET.fromstring(z.read(path)).iter(S + 'row'):
            cells = []
            for c in row.iter(S + 'c'):
                v = c.find(S + 'v'); t = c.get('t')
                if t == 's' and v is not None: cells.append(ss[int(v.text)])
                elif t == 'inlineStr': cells.append(''.join(x.text or '' for x in c.iter(S + 't')))
                else: cells.append(v.text if v is not None else '')
            if any(x.strip() for x in cells): print('\t'.join(cells))
PY
  fail=0
  for src in "$@"; do
    name="$(basename "$src")"; orig="originals/$scope/$name"; out="sources/$scope/$name.md"
    [ -d "$src" ] && { echo "[$name] SKIP: a bundle (rtfd/key/pages/numbers) — export it from its app (PDF, txt or CSV) and ingest the export" >&2; fail=$((fail+1)); continue; }
    if ! { [ -f "$orig" ] && [ "$(cd "$(dirname "$src")" 2>/dev/null && pwd -P)" = "$(cd "originals/$scope" 2>/dev/null && pwd -P)" ]; }; then
      echo "[$name] SKIP: place the file in originals/$scope/ first — humans write the store, extract only reads it" >&2; fail=$((fail+1)); continue; fi
    printf '%s' "$name" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9-]+\.[a-z0-9]+$' || { echo "[$name] SKIP: name must be YYYY-MM-DD-<slug>.<ext>" >&2; fail=$((fail+1)); continue; }
    sha="$(shasum -a 256 "$orig" | cut -c1-64)"; [ -n "$sha" ] || { echo "[$name] REFUSED: cannot hash $orig" >&2; fail=$((fail+1)); continue; }
    ext="$(printf '%s' "${name##*.}" | tr 'A-Z' 'a-z')"; body="$(mktemp)"; extractor=none; status=ok
    if [ "${RESTRICTED:-}" = "$name" ]; then status=restricted; : > "$body"; else
      case "$ext" in
        md|txt|csv|tsv|json|yaml|yml|xml|log|eml|emlx|ics) extractor=verbatim; cat "$orig" > "$body" ;;
        docx|doc|rtf|odt|html|htm|webarchive) extractor=textutil; textutil -convert txt -stdout "$orig" > "$body" ;;
        pdf) extractor=pdfkit; swift "$tmp" "$orig" > "$body" 2>/dev/null || { extractor="none (pdf unreadable or encrypted)"; : > "$body"; }
             pages="$(grep -c '^<!-- page' "$body")"; chars="$(grep -v '^<!-- page' "$body" | tr -d '[:space:]' | wc -c | tr -d ' ')"
             if [ "${OCR:-}" = "$name" ] || { [ "$pages" -gt 0 ] && [ "$chars" -lt $((20 * pages)) ]; }; then
               extractor=vision-ocr; swift "$ocr" "$orig" > "$body" 2>/dev/null || { extractor="none (ocr failed)"; : > "$body"; }; fi ;;
        png|jpg|jpeg|tif|tiff|heic|gif) extractor=vision-ocr; swift "$ocr" "$orig" > "$body" 2>/dev/null || { extractor="none (ocr failed)"; : > "$body"; } ;;
        pptx|xlsx) extractor=ooxml; python3 "$ooxml" "$orig" > "$body" 2>/dev/null || { extractor="none (ooxml unreadable)"; : > "$body"; } ;;
        *) [ "$(file -b --mime-encoding "$orig")" = binary ] || { extractor=verbatim; cat "$orig" > "$body"; } ;;
      esac
      enc="$(file -b --mime-encoding "$body")"
      case "$enc" in
        utf-16*|utf-32*) iconv -f "$(printf %s "$enc" | tr a-z A-Z | sed 's/BE$//;s/LE$//')" -t UTF-8 "$body" > "$body.u8" && mv "$body.u8" "$body" ;;
        binary) if [ -s "$body" ]; then echo "[$name] REFUSED: extracted text is not text (encoding $enc)" >&2; rm -f "$body"; fail=$((fail+1)); continue; fi ;;
      esac
      perl -pi -e 's/^\xEF\xBB\xBF// if $. == 1' "$body"
      hits="$(grep -nE -e '-----BEGIN [A-Z ]*PRIVATE KEY' -e 'AKIA[0-9A-Z]{16}' -e 'gh[pousr]_[A-Za-z0-9]{30,}' -e 'xox[abp]-[A-Za-z0-9-]{10,}' -e 'sk-[A-Za-z0-9_-]{20,}' -e 'AIza[0-9A-Za-z_-]{30,}' -e 'eyJ[A-Za-z0-9_-]{20,}\.' -e '://[^/[:space:]:]+:[^@/[:space:]]+@' "$body" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')"
      hits2="$(grep -inE '(password|passwd|secret|api[_-]?key|access[_-]?token|bearer)[[:space:]]*[:=][[:space:]]*[^[:space:]<[]{8,}' "$body" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')"
      if [ -n "$hits$hits2" ] && [ "${SECRET_OK:-}" != "$name" ]; then
        echo "[$name] REFUSED: credential-shaped text at line(s) ${hits}${hits:+,}${hits2} — vault the value, put a redacted copy in the store under a new name, re-run (SECRET_OK=$name waives a false positive)" >&2
        rm -f "$body"; fail=$((fail+1)); continue
      fi
      [ "$(wc -c < "$body")" -le 1000000 ] || { echo "[$name] REFUSED: extracted text over 1 MB — split the original and ingest the parts" >&2; rm -f "$body"; fail=$((fail+1)); continue; }
      [ -s "$body" ] || { status="no-text"; [ "$extractor" = none ] && echo "[$name] no extractor for .$ext — export from the app and ingest the export" >&2; }
    fi
    mkdir -p "sources/$scope"
    { printf -- '---\nsource: %s\nsha256: %s\nbytes: %s\nextractor: %s\nstatus: %s\n' "$orig" "$sha" "$(wc -c < "$orig" | tr -d ' ')" "$extractor" "$status"
      [ "${SECRET_OK:-}" = "$name" ] && printf 'secret_review: waived %s\n' "$(date +%F)"
      printf -- '---\n'; cat "$body"; } > "$out"; rm -f "$body"
    echo "[$name] → $out ($extractor, $status); cite as $out@$(git hash-object "$out" | cut -c1-12) after the closeout commit"
  done
  [ "$fail" -eq 0 ] || { echo "extract: $fail file(s) not ingested." >&2; exit 1; }
  ;;

check)
  status=0; n=0; tmp="$(mktemp)"; entries > "$tmp"
  while IFS='|' read -r id path remote branch access; do
    n=$((n+1))
    [ -n "$id" ] && [ -n "$path" ] && [ -n "$remote" ] && [ -n "$branch" ] \
      || { echo "FAIL: manifest entry $n incomplete (needs id/path/remote/default_branch)" >&2; status=1; }
    case "$access" in write|pr-only|read-only) : ;;
      *) echo "FAIL: [$id] access must be write|pr-only|read-only (got '${access:-<empty>}')" >&2; status=1 ;; esac
  done < "$tmp"
  raw="$(grep -cE '^[[:space:]]*-[[:space:]]*id:' "$MANIFEST" || true)"
  if [ "$raw" -gt "$n" ]; then
    echo "FAIL: manifest has $raw 'id:' line(s) but only $n parse — check indentation ('- id:' must start at column 0)" >&2
    status=1
  fi
  bad="$(awk '
    /^[[:space:]]*#/ { next }
    /^- id:/ { if (NF > 3) print NR; next }
    /^[[:space:]]+(path|remote|default_branch|access|scope):/ { if (NF > 2) print NR }
  ' "$MANIFEST")"
  [ -z "$bad" ] || { echo "FAIL: manifest line(s) $(echo $bad | tr ' ' ','): values must be single tokens (no spaces or inline comments)" >&2; status=1; }
  if [ -d sources ]; then   # document layer: every file is a .md derivative with a header; text only, ≤ 1 MiB
    find sources -type f ! -name .DS_Store | while read -r f; do
      case "$f" in *.md) : ;; *) echo "FAIL: $f — only .md derivatives live under sources/ (originals go to the store)" >&2; exit 1 ;; esac
      [ "$(head -1 "$f")" = "---" ] && grep -qE '^sha256: [0-9a-f]{64}$' "$f" && grep -qE '^source: originals/' "$f" \
        || { echo "FAIL: $f lacks the extract header (source/sha256) — regenerate with ./workspace.sh extract" >&2; exit 1; }
      [ "$(wc -c < "$f")" -le 1048576 ] || { echo "FAIL: $f is over 1 MiB — split the original and re-extract" >&2; exit 1; }
      git check-ignore -q "$f" 2>/dev/null && { echo "FAIL: $f is matched by .gitignore and would never be committed — rename it" >&2; exit 1; }
      o="$(sed -n 's/^source: //p' "$f" | head -1)"
      case "$o" in "originals/$(basename "$(dirname "$f")")/"*) : ;; *) echo "FAIL: $f: header source $o is not under this scope — re-extract in place" >&2; exit 1 ;; esac
      if [ -e "$o" ] && { [ "$(wc -c < "$o" | tr -d ' ')" != "$(sed -n 's/^bytes: //p' "$f" | head -1)" ] || [ "$(shasum -a 256 "$o" | cut -c1-64)" != "$(sed -n 's/^sha256: //p' "$f" | head -1)" ]; }; then
        echo "warn: $f: $o differs from its header — a new version is a new dated name; re-run extract or restore the store copy" >&2
      fi
    done || status=1
    echo "info: $(find sources -type f -name '*.md' | wc -l | tr -d ' ') document derivative(s) under sources/$([ -e originals ] || echo ' (originals not mounted: hashes not verified)')"
  fi
  [ "$n" -gt 0 ] || echo "warn: manifest has no repos yet — edit catalog/repos.yaml"
  newest="$(ls .agents/memory/sessions 2>/dev/null | grep -E '^[0-9]{4}-' | sort | tail -1)"
  echo "info: newest session log: ${newest:-none yet}"
  [ "$status" -eq 0 ] && echo "check: PASS ($n repo(s) in manifest)" || echo "check: FAIL" >&2
  exit "$status"
  ;;

help)
  sed -n '2,9p' "$0"
  ;;

*)
  sed -n '2,9p' "$0" >&2
  exit 1
  ;;
esac
