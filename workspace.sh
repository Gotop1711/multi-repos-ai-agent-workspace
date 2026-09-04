#!/usr/bin/env bash
# workspace.sh — the whole harness in one script.
#   ./workspace.sh setup                 one-time: wire the safety hook, print what to do next
#   ./workspace.sh clone                 rebuild the fleet from catalog/repos.yaml
#   ./workspace.sh cite                  print the fleet as one citation line — paste into findings
#   ./workspace.sh restore <repo>@<sha>… check cited commits out (bare <repo> returns to its branch)
#   ./workspace.sh ingest <scope> <file>…      copy a document to docs/assets/<scope>/[<repo>/] (gitignored) under a dated name, then extract it
#                                              REPO=<manifest id> files it one folder down, under that repository (REA_PROTO → rea-proto/)
#   ./workspace.sh extract <scope> docs/assets/<scope>/[<repo>/]<file>…  text of a copied document → docs/<scope>/sources/[<repo>/]<file>.md
#                                              OCR_LANGS=<bcp47,…> sets Vision's recognition languages (default zh-Hant,en-US)
#   ./workspace.sh check                 verify the manifest and the document layer (session-init / pre-commit)
# Plain bash (macOS 3.2 ok), zero dependencies — extract alone uses macOS textutil, swift (PDFKit, Vision) and python3.
set -u
cd "$(dirname "$0")" || exit 1
MANIFEST="catalog/repos.yaml"
ASSETS="docs/assets"        # originals: copied in by ingest as docs/assets/<scope>/<YYYY-MM-DD-slug.ext>, gitignored, never committed
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
repo_sub()  { printf '%s' "$1" | tr 'A-Z_' 'a-z-'; }          # manifest id → its document-layer folder: lowercase, '_' → '-' (REA_PROTO → rea-proto)
repo_subs() { entries | cut -d'|' -f1 | tr 'A-Z_' 'a-z-'; }   # every permitted folder below docs/assets/<scope>/ and docs/<scope>/sources/, one per line

cmd="${1:-help}"
case "$cmd" in clone|cite|restore|check|extract|ingest)
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
  echo "  •  ./workspace.sh ingest <scope> <files>   # documents become agent-readable text under docs/<scope>/sources/ (originals copied to $ASSETS/<scope>/, gitignored)"
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
      *sources/*@*) echo "[$token] is a document citation — read it with: git show ${token#*@}" >&2; continue ;;
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
  # reads an original already under docs/assets/<scope>/ (dated name) and writes docs/<scope>/sources/<name>.md
  shift; scope="${1:-}"; shift || true
  usage="usage: workspace.sh extract <scope> docs/assets/<scope>/[<repo>/]<file>…   (scope = a docs/<scope>.md id; <repo> = a manifest id lowercased; RESTRICTED=<file> header only; OCR=<file> force OCR; OCR_LANGS=<bcp47,…> recognition languages, default zh-Hant,en-US; SECRET_OK=<file> waive a false positive)"
  printf '%s' "$scope" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { echo "$usage" >&2; exit 1; }
  [ "$#" -gt 0 ] || { echo "$usage" >&2; exit 1; }
  [ -d "$ASSETS/$scope" ] || { echo "FAIL: $ASSETS/$scope/ missing — './workspace.sh ingest $scope <file>' copies a document there first" >&2; exit 1; }
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
let langs = (args.count > 2 ? args[2] : "zh-Hant,en-US").split(separator: ",").map { String($0) }   // OCR_LANGS; Vision's default is en-US only
func ocr(_ cg: CGImage) -> [String] {
    let req = VNRecognizeTextRequest(); req.recognitionLevel = .accurate; req.recognitionLanguages = langs
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
    name="$(basename "$src")"
    [ -d "$src" ] && { echo "[$name] SKIP: a bundle (rtfd/key/pages/numbers) — export it from its app (PDF, txt or CSV) and ingest the export" >&2; fail=$((fail+1)); continue; }
    # the original sits directly under docs/assets/<scope>/, or one folder down in a folder named for a manifest repo (REA_PROTO → rea-proto)
    d="$(cd "$(dirname "$src")" 2>/dev/null && pwd -P)"; root="$(cd "$ASSETS/$scope" 2>/dev/null && pwd -P)"; sub=""
    if [ -n "$d" ] && [ "$d" = "$root" ]; then :
    elif [ -n "$d" ] && [ "$(dirname "$d")" = "$root" ] && repo_subs | grep -qxF "$(basename "$d")"; then sub="$(basename "$d")"
    else echo "[$name] SKIP: not under $ASSETS/$scope/ or $ASSETS/$scope/<repo>/ (<repo> = a manifest id lowercased) — './workspace.sh ingest $scope <file>' copies it there first" >&2; fail=$((fail+1)); continue; fi
    rel="${sub:+$sub/}$name"; orig="$ASSETS/$scope/$rel"; out="docs/$scope/sources/$rel.md"
    [ -f "$orig" ] || { echo "[$name] SKIP: $orig is not a file" >&2; fail=$((fail+1)); continue; }
    received="${RECEIVED:-}"; [ -n "$received" ] || { [ -f "$out" ] && received="$(sed -n 's/^received: //p' "$out" | head -1)"; }   # a re-extract keeps the as-received name ingest recorded
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
               extractor=vision-ocr; swift "$ocr" "$orig" "${OCR_LANGS:-zh-Hant,en-US}" > "$body" 2>/dev/null || { extractor="none (ocr failed)"; : > "$body"; }; fi ;;
        png|jpg|jpeg|tif|tiff|heic|gif) extractor=vision-ocr; swift "$ocr" "$orig" "${OCR_LANGS:-zh-Hant,en-US}" > "$body" 2>/dev/null || { extractor="none (ocr failed)"; : > "$body"; } ;;
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
        echo "[$name] REFUSED: credential-shaped text at line(s) ${hits}${hits:+,}${hits2} — vault the value, ingest a redacted copy under a new name (SECRET_OK=$name waives a false positive)" >&2
        rm -f "$body"; fail=$((fail+1)); continue
      fi
      [ "$(wc -c < "$body")" -le 1000000 ] || { echo "[$name] REFUSED: extracted text over 1 MB — split the original and ingest the parts" >&2; rm -f "$body"; fail=$((fail+1)); continue; }
      grep -v -E '^<!-- (page|slide|sheet) [^>]*-->$' "$body" | grep -q '[^[:space:]]' \
        || { status="no-text"; [ "$extractor" = none ] && echo "[$name] no extractor for .$ext — export from the app and ingest the export" >&2; }   # page/slide/sheet markers alone are not text
    fi
    mkdir -p "$(dirname "$out")"
    { printf -- '---\nsource: %s\nsha256: %s\nbytes: %s\nextractor: %s\nstatus: %s\n' "$orig" "$sha" "$(wc -c < "$orig" | tr -d ' ')" "$extractor" "$status"
      [ -n "$received" ] && printf 'received: %s\n' "$received"   # the as-received file name, set by ingest and kept across re-extracts
      [ "${SECRET_OK:-}" = "$name" ] && printf 'secret_review: waived %s\n' "$(date +%F)"
      printf -- '---\n'; cat "$body"; } > "$out"; rm -f "$body"
    echo "[$name] → $out ($extractor, $status); cite as $out@$(git hash-object "$out" | cut -c1-12) after the closeout commit"
  done
  [ "$fail" -eq 0 ] || { echo "extract: $fail file(s) not ingested." >&2; exit 1; }
  ;;

ingest)
  # agent or human: copy a document from anywhere to docs/assets/<scope>/YYYY-MM-DD-<slug>.<ext> (gitignored), then extract it.
  # Originals are only ever ADDED here: identical bytes are reused, different bytes under an existing name are refused,
  # and a file that extract refuses (credential, oversize) is removed again.
  shift; scope="${1:-}"; shift || true
  usage="usage: workspace.sh ingest <scope> <file>…   (REPO=<manifest id> files them under docs/assets/<scope>/<repo>/; NAME=<YYYY-MM-DD-slug.ext> names one file — required for non-ASCII titles; DATE=<YYYY-MM-DD> dates the default name; RESTRICTED/OCR/SECRET_OK=<stored name> and OCR_LANGS=<bcp47,…> pass through to extract)"
  printf '%s' "$scope" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { echo "$usage" >&2; exit 1; }
  [ "$#" -gt 0 ] || { echo "$usage" >&2; exit 1; }
  [ -n "${NAME:-}" ] && [ "$#" -gt 1 ] && { echo "FAIL: NAME= names exactly one file — ingest the others in their own calls" >&2; exit 1; }
  git check-ignore -q "$ASSETS/$scope/probe" 2>/dev/null || { echo "FAIL: $ASSETS/ is not gitignored — originals must never be committed; add '/docs/assets/' to .gitignore" >&2; exit 1; }
  sub=""   # REPO= → one folder below the scope, named for the repository the documents are evidence about
  if [ -n "${REPO:-}" ]; then
    entries | cut -d'|' -f1 | grep -qxF "$REPO" || { echo "FAIL: REPO=$REPO is not a manifest id (ids: $(entries | cut -d'|' -f1 | tr '\n' ' '))" >&2; exit 1; }
    sub="$(repo_sub "$REPO")"
    printf '%s' "$sub" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { echo "FAIL: repo id '$REPO' does not lowercase to a folder name in the id grammar (got '$sub')" >&2; exit 1; }
  fi
  mkdir -p "$ASSETS/$scope${sub:+/$sub}" || { echo "FAIL: cannot create $ASSETS/$scope${sub:+/$sub}" >&2; exit 1; }
  store_real="$(cd "$ASSETS" && pwd -P)"; proj_real="$( [ -d projects ] && cd projects && pwd -P )"
  fail=0
  for src in "$@"; do
    base="$(basename "$src")"
    [ -f "$src" ] || { echo "[$base] SKIP: not a file (a bundle such as .key/.pages/.numbers/.rtfd — export it from its app first)" >&2; fail=$((fail+1)); continue; }
    real="$(cd "$(dirname "$src")" && pwd -P)/$base"
    case "$real" in "$store_real"/*) echo "[$base] SKIP: already under $ASSETS/ — use: ./workspace.sh extract $scope $ASSETS/$scope/<name>" >&2; fail=$((fail+1)); continue ;; esac
    if [ -n "$proj_real" ]; then case "$real" in "$proj_real"/*) echo "[$base] SKIP: inside projects/ — a document in a child repo is cited <repo>@<sha> + path, never copied" >&2; fail=$((fail+1)); continue ;; esac; fi
    if [ -n "${NAME:-}" ]; then name="$NAME"; else
      if printf '%s' "$base" | LC_ALL=C grep -q '[^ -~]'; then
        echo "[$base] SKIP: the title is not ASCII and the slug rule would silently drop its non-Latin words — name it yourself: NAME=YYYY-MM-DD-<english-slug>.<ext> ./workspace.sh ingest $scope '$src'" >&2; fail=$((fail+1)); continue; fi
      ext="$(printf '%s' "${base##*.}" | tr 'A-Z' 'a-z')"; stem="${base%.*}"
      slug="$(printf '%s' "$stem" | iconv -c -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null | tr -d "'\`^~\"" | tr 'A-Z' 'a-z' | sed -E 's/[^a-z0-9]+/-/g; s/^-//; s/-$//')"
      date="${DATE:-}"
      if printf '%s' "$slug" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}(-|$)'; then            # a leading date in the title is the document's own date
        [ -n "$date" ] || date="$(printf '%s' "$slug" | cut -c1-10)"; slug="$(printf '%s' "$slug" | cut -c12-)"
      elif printf '%s' "$slug" | grep -qE '(^|-)[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then          # …or a trailing one
        [ -n "$date" ] || date="$(printf '%s' "$slug" | sed -E 's/.*([0-9]{4}-[0-9]{2}-[0-9]{2})$/\1/')"; slug="$(printf '%s' "$slug" | sed -E 's/-?[0-9]{4}-[0-9]{2}-[0-9]{2}$//')"
      fi
      [ -n "$date" ] || date="$(stat -f %Sm -t %Y-%m-%d "$src")"                             # last resort: the file's modification date
      [ -n "$slug" ] || slug=untitled
      name="$date-$slug.$ext"
    fi
    printf '%s' "$name" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9-]+\.[a-z0-9]+$' || { echo "[$base] SKIP: '$name' is not YYYY-MM-DD-<slug>.<ext> in lowercase ASCII" >&2; fail=$((fail+1)); continue; }
    dest="$ASSETS/$scope${sub:+/$sub}/$name"; placed=0
    if [ -e "$dest" ]; then
      if [ "$(shasum -a 256 "$src" | cut -c1-64)" = "$(shasum -a 256 "$dest" | cut -c1-64)" ]; then
        echo "[$base] already stored as $name (identical bytes) — re-extracting" >&2
      else
        echo "[$base] REFUSED: $dest exists with different bytes — an original is never overwritten; a new version is a new dated name (NAME=…)" >&2; fail=$((fail+1)); continue
      fi
    else
      cp "$src" "$dest" || { echo "[$base] REFUSED: cannot copy to $ASSETS/$scope/" >&2; fail=$((fail+1)); continue; }
      placed=1; echo "[$base] → $dest" >&2
    fi
    if ! RECEIVED="$base" bash "$0" extract "$scope" "$dest"; then
      fail=$((fail+1))
      [ "$placed" -eq 1 ] && { rm -f "$dest"; echo "[$base] removed from $ASSETS/$scope/ again — extract refused it" >&2; }
    fi
  done
  [ "$fail" -eq 0 ] || { echo "ingest: $fail file(s) not ingested." >&2; exit 1; }
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
  if ls -d docs/*/sources >/dev/null 2>&1; then   # document layer: docs/<scope>/sources/*.md derivatives with a header; originals in gitignored docs/assets/<scope>/
    subs="$(repo_subs)"
    find docs/*/sources -type f ! -name .DS_Store | while read -r f; do
      scope="${f#docs/}"; scope="${scope%%/*}"; rel="${f#docs/$scope/sources/}"
      case "$rel" in
        */*/*) echo "FAIL: $f — at most one folder below docs/<scope>/sources/, and it must be a manifest repo id lowercased" >&2; exit 1 ;;
        */*) printf '%s\n' "$subs" | grep -qxF "${rel%%/*}" || { echo "FAIL: $f — folder '${rel%%/*}' is not a manifest repo id lowercased (one of: $(printf '%s' "$subs" | tr '\n' ' '))" >&2; exit 1; } ;;
      esac
      case "$f" in *.md) : ;; *) echo "FAIL: $f — only .md derivatives live under docs/<scope>/sources/ (originals go to $ASSETS/<scope>/)" >&2; exit 1 ;; esac
      [ "$(head -1 "$f")" = "---" ] && grep -qE '^sha256: [0-9a-f]{64}$' "$f" && grep -qE "^source: $ASSETS/" "$f" \
        || { echo "FAIL: $f lacks the extract header (source/sha256) — regenerate with ./workspace.sh extract" >&2; exit 1; }
      [ "$(wc -c < "$f")" -le 1048576 ] || { echo "FAIL: $f is over 1 MiB — split the original and re-extract" >&2; exit 1; }
      git check-ignore -q "$f" 2>/dev/null && { echo "FAIL: $f is matched by .gitignore and would never be committed — rename it" >&2; exit 1; }
      o="$(sed -n 's/^source: //p' "$f" | head -1)"
      [ "$o" = "$ASSETS/$scope/${rel%.md}" ] || { echo "FAIL: $f: header source '$o' is not $ASSETS/$scope/${rel%.md} — re-extract in place" >&2; exit 1; }
      if [ -e "$o" ] && { [ "$(wc -c < "$o" | tr -d ' ')" != "$(sed -n 's/^bytes: //p' "$f" | head -1)" ] || [ "$(shasum -a 256 "$o" | cut -c1-64)" != "$(sed -n 's/^sha256: //p' "$f" | head -1)" ]; }; then
        echo "warn: $f: $o differs from its header — a new version is a new dated name; re-ingest it or restore the copy" >&2
      fi
    done || status=1
    # unreferenced derivatives: nothing under docs/ outside sources/ names the file (session logs are journey and do not count) —
    # removed at closeout with their originals by whoever sees this; cite a derivative by its full file name to keep it
    # a plan carrying Shipped:/Abandoned: is history — its knowledge dissolved into the Body, so its citations no longer keep a document alive.
    # No `case` here: in bash 3.2 a case pattern's ')' closes the enclosing $( ).
    unref="$(find docs/*/sources -type f -name '*.md' | while read -r f; do
      grep -rlF --include='*.md' "$(basename "$f")" docs 2>/dev/null | grep -v '/sources/' | while read -r d; do
        if [ "${d#docs/plans/}" != "$d" ] && grep -qE '^(Shipped|Abandoned):' "$d"; then continue; fi
        echo "$d"
      done | grep -q . || echo "$f"; done)"
    if [ -n "$unref" ]; then
      printf '%s\n' "$unref" | while read -r f; do o="$(sed -n 's/^source: //p' "$f" | head -1)"
        echo "warn: $f is not referenced by any document under docs/ — remove it and its original at closeout (git rm $f; rm $o), or cite it by its full file name" >&2; done
      echo "warn: $(printf '%s\n' "$unref" | grep -c .) unreferenced derivative(s) under docs/*/sources/ — no longer needed by the documentation; remove them with their originals before closing out (AGENTS.md › write surface)" >&2
    fi
    tracked="$(git ls-files "$ASSETS" 2>/dev/null | wc -l | tr -d ' ')"
    [ "$tracked" -eq 0 ] || { echo "FAIL: $tracked file(s) under $ASSETS/ are tracked by git — originals are never committed (git rm --cached them; keep '/docs/assets/' in .gitignore)" >&2; status=1; }
    echo "info: $(find docs/*/sources -type f -name '*.md' | wc -l | tr -d ' ') document derivative(s) under docs/*/sources/$([ -d "$ASSETS" ] || echo " ($ASSETS/ absent: hashes not verified)")"
  fi
  # orphans: an original no derivative names any more (its derivative was removed or re-filed) — removed at closeout by whoever sees this
  orphans="$( [ -d "$ASSETS" ] && find "$ASSETS" -type f ! -name .DS_Store | while read -r o; do r="${o#$ASSETS/}"; s="${r%%/*}"; [ -f "docs/$s/sources/${r#*/}.md" ] || echo "$o"; done )"
  if [ -n "$orphans" ]; then
    printf '%s\n' "$orphans" | while read -r o; do echo "warn: $o has no derivative — an orphan: remove it (rm), or './workspace.sh extract ${o#$ASSETS/}' if it was meant to be ingested" | sed "s|extract \([a-z0-9-]*\)/|extract \1 $ASSETS/\1/|" >&2; done
    echo "warn: $(printf '%s\n' "$orphans" | grep -c .) orphan original(s) under $ASSETS/ — not in use by any derivative; remove them before closing out (AGENTS.md › write surface)" >&2
  fi

  [ "$n" -gt 0 ] || echo "warn: manifest has no repos yet — edit catalog/repos.yaml"
  newest="$(ls .agents/memory/sessions 2>/dev/null | grep -E '^[0-9]{4}-' | sort | tail -1)"
  echo "info: newest session log: ${newest:-none yet}"
  [ "$status" -eq 0 ] && echo "check: PASS ($n repo(s) in manifest)" || echo "check: FAIL" >&2
  exit "$status"
  ;;

help)
  sed -n '2,10p' "$0"
  ;;

*)
  sed -n '2,10p' "$0" >&2
  exit 1
  ;;
esac
