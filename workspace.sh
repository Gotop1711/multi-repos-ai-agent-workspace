#!/usr/bin/env bash
# workspace.sh — the whole harness in one script.
#   ./workspace.sh setup                            one-time: wire the safety hook
#   ./workspace.sh clone                            rebuild the fleet from catalog/repos.yaml
#   ./workspace.sh cite                             the fleet as one citation line — paste it into a claim
#   ./workspace.sh restore <repo>@<sha>…            check cited commits out (bare <repo> returns to its branch)
#   ./workspace.sh doc init <product>               docs/<product>/index.md
#   ./workspace.sh doc add <product> <name>         a module docs/<product>/<name>.md — or, when <name> is a manifest repo id lowercased, docs/<product>/<name>/index.md
#   ./workspace.sh doc rm <product> <name>          remove it and its link in index.md
#   ./workspace.sh plan new <product> <feature>     docs/<product>/plans/<feature>.md (draft), linked in index.md
#   ./workspace.sh plan done <product> <feature>    remove a verified or abandoned plan, its session logs and the sources only it used
#   ./workspace.sh ingest <product> <file>…         REPO=<id>: copy a document to docs/assets/<product>/[<repo>/] (gitignored), extract its text to docs/<product>/[<repo>/]sources/
#   ./workspace.sh extract <product> docs/assets/<product>/[<repo>/]<file>…   re-extract a stored original (OCR_LANGS=<bcp47,…>, default zh-Hant,en-US)
#   ./workspace.sh prune [--apply]                  derivatives nothing cites and orphan originals; --apply removes them
#   ./workspace.sh check                            structure, caps, plans, derivatives, parties (session-init / pre-commit)
# Plain bash (macOS 3.2 ok), zero dependencies — extract alone uses macOS textutil, swift (PDFKit, Vision) and python3.
set -u
cd "$(dirname "$0")" || exit 1
MANIFEST="catalog/repos.yaml"
ASSETS="docs/assets"        # originals: docs/assets/<product>/[<repo>/]<YYYY-MM-DD-slug.ext>, gitignored, never committed
CAP_INDEX=80; CAP_MODULE=150; CAP_REPO=100; CAP_PLAN=80; CAP_LOG=40   # line caps check enforces (AGENTS.md › Documents)
tmp=""; ocr=""; ooxml=""; pats=""; trap 'rm -f "$tmp" "$ocr" "$ooxml" "$pats"' EXIT

entries() { # one line per repo: id|path|remote|branch|access|product
  awk '
    function flush() { if (id != "") print id "|" path "|" remote "|" branch "|" access "|" product }
    /^- id:/                       { flush(); id=$3; path=""; remote=""; branch=""; access=""; product="" }
    /^[[:space:]]+path:/           { path=$2 }
    /^[[:space:]]+remote:/         { remote=$2 }
    /^[[:space:]]+default_branch:/ { branch=$2 }
    /^[[:space:]]+access:/         { access=$2 }
    /^[[:space:]]+product:/        { product=$2 }
    END                            { flush() }
  ' "$MANIFEST"
}
repo_sub()  { printf '%s' "$1" | tr 'A-Z_' 'a-z-'; }          # manifest id → its folder name: lowercase, '_' → '-' (MY_API → my-api)
repo_subs() { entries | cut -d'|' -f1 | tr 'A-Z_' 'a-z-'; }   # every permitted repository folder below docs/<product>/, one per line
ID_RE='^[a-z0-9]+(-[a-z0-9]+)*$'

# parties (AGENTS.md › Boilerplate and organizations): an organization's content is this closed list; every other path is boilerplate
ORG_RE='^(catalog/[^/]*[.]yaml|docs/.*|[.]agents/memory/sessions/[^/]*)$'
BOILERPLATE_RE='^[.]agents/memory/sessions/(TEMPLATE[.]md|[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-[a-z0-9]*-workspace--.*)$'
party() { awk -v want="$1" -v o="$ORG_RE" -v b="$BOILERPLATE_RE" '{ p = ($0 ~ o && $0 !~ b) ? "org" : "boilerplate" } p == want'; }   # paths on stdin → those of one party

# document layer: a derivative docs/<product>/[<repo>/]sources/<name>.md is needed only while a LIVE document under docs/ outside
# sources/ names it — logs are journey; a plan carrying Shipped:/Abandoned: is history. Shared by check, prune and plan done.
# No `case` inside these: under bash 3.2 a case pattern's ')' closes an enclosing $( ).
derivatives() { find docs -type f -path '*/sources/*' -name '*.md' 2>/dev/null | grep -v '^docs/assets/' | sort; }
orig_of() { r="${1#docs/}"; r="${r%.md}"; printf '%s/%s\n' "$ASSETS" "$(printf '%s' "$r" | sed 's|/sources/|/|')"; }   # derivative → its original
keepers() { # $1 = derivative → one "<document> › <nearest heading above the citation>" per live citing document
  name="$(basename "$1")"
  grep -rlF --include='*.md' "$name" docs 2>/dev/null | grep -v '/sources/' | sort | while read -r d; do
    if [ "${d%/plans/*}" != "$d" ] && grep -qE '^(Shipped|Abandoned):' "$d"; then continue; fi
    awk -v pat="$name" -v d="$d" '/^#+ /{h=$0} index($0,pat){print d " › " (h==""?"(before the first heading)":substr(h,1,72))}' "$d" | awk '!seen[$0]++'
  done
}
unref_derivatives() { derivatives | while read -r f; do keepers "$f" | grep -q . || echo "$f"; done; }
orphan_originals() { # an original no derivative names; a product with no docs/<product>/ on this branch is another branch's — left alone
  [ -d "$ASSETS" ] || return 0
  find "$ASSETS" -type f ! -name .DS_Store | sort | while read -r o; do
    r="${o#$ASSETS/}"; p="${r%%/*}"; [ -d "docs/$p" ] || continue; rest="${r#*/}"
    if [ "${rest#*/}" != "$rest" ]; then d="docs/$p/${rest%%/*}/sources/${rest#*/}.md"; else d="docs/$p/sources/$rest.md"; fi
    [ -f "$d" ] || echo "$o"
  done
}
prune_run() { # $1 = 1 to remove (git rm the derivative — rm if never committed — and rm its original; rm orphans), 0 to report
  derivatives | while read -r f; do
    k="$(keepers "$f")"
    if [ -n "$k" ]; then
      [ "$1" -eq 1 ] || printf '%s\n' "$k" | sed "s|^|kept:    $f — by |"
    else
      o="$(orig_of "$f")"
      if [ "$1" -eq 1 ]; then
        if git ls-files --error-unmatch -- "$f" >/dev/null 2>&1; then git rm -q -- "$f" && echo "removed: $f"; else rm -- "$f" && echo "removed: $f (never committed)"; fi
        [ -e "$o" ] && rm -- "$o" && echo "removed: $o"
      else
        echo "remove:  $f — no live document cites it (with its original $o)"
      fi
    fi
  done
  orphan_originals | while read -r o; do
    if [ "$1" -eq 1 ]; then rm -- "$o" && echo "removed: $o (orphan)"; else echo "remove:  $o — an orphan (no derivative)"; fi
  done
}

# index.md links: one line per module / repository / plan under its '## ' section, kept by doc add/rm and plan new/done
index_link() { # $1 index, $2 section title, $3 line — appended after the section's last non-blank line (section created at the end if absent)
  grep -qxF -- "$3" "$1" && return 0
  n="$(awk -v sec="## $2" '$0==sec{insec=1; last=NR; next} insec && /^## /{exit} insec && NF{last=NR} END{print last+0}' "$1")"
  if [ "$n" -eq 0 ]; then printf '\n## %s\n%s\n' "$2" "$3" >> "$1"; else awk -v n="$n" -v line="$3" '{print} NR==n{print line}' "$1" > "$1.tmp" && mv "$1.tmp" "$1"; fi
}
index_unlink() { awk -v t="($2)" 'index($0,t)==0' "$1" > "$1.tmp" && mv "$1.tmp" "$1"; }   # $1 index, $2 link target
rm_tracked() { if git ls-files --error-unmatch -- "$1" >/dev/null 2>&1; then git rm -q -r -- "$1"; else rm -r -- "$1"; fi; echo "removed: $1"; }

cmd="${1:-help}"
case "$cmd" in clone|cite|restore|check|extract|ingest|doc|plan)
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
    echo "  1. ./workspace.sh clone                 # fleet appears under projects/"
  else
    echo "  1. edit catalog/repos.yaml              # declare your child repos, access levels and products"
    echo "  2. ./workspace.sh clone                 # fleet appears under projects/"
  fi
  echo "  3. ./workspace.sh doc init <product>    # docs/<product>/index.md — then doc add <product> <module|repo>"
  echo "  •  ./workspace.sh ingest <product> <files>   # documents become agent-readable text under docs/<product>/[<repo>/]sources/"
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

doc)
  sub="${2:-}"; p="${3:-}"; name="${4:-}"
  usage="usage: workspace.sh doc init <product> | doc add <product> <module|repo> | doc rm <product> <module|repo>"
  printf '%s' "$p" | grep -qE "$ID_RE" || { echo "$usage" >&2; exit 1; }
  idx="docs/$p/index.md"
  case "$sub" in
  init)
    [ "$#" -eq 3 ] || { echo "$usage" >&2; exit 1; }
    [ ! -f "$idx" ] || { echo "$idx exists"; exit 0; }
    mkdir -p "docs/$p"
    { printf '# %s\n\n<!-- one paragraph: what the product is and does; every fact cites <repo>@<sha> path:line — ./workspace.sh cite -->\n\n## Modules\n\n## Repositories\n\n## Plans\n' "$p"; } > "$idx"
    echo "created: $idx — next: './workspace.sh doc add $p <module>' and './workspace.sh doc add $p <repo>' (a manifest id lowercased: $(repo_subs | tr '\n' ' '))"
    ;;
  add)
    [ "$#" -eq 4 ] && printf '%s' "$name" | grep -qE "$ID_RE" || { echo "$usage" >&2; exit 1; }
    [ -f "$idx" ] || { echo "FAIL: $idx missing — './workspace.sh doc init $p' first" >&2; exit 1; }
    case "$name" in index|plans|sources|assets) echo "FAIL: '$name' is reserved" >&2; exit 1 ;; esac
    if repo_subs | grep -qxF "$name"; then
      f="docs/$p/$name/index.md"; [ ! -f "$f" ] || { echo "$f exists"; exit 0; }
      id="$(entries | cut -d'|' -f1 | while read -r i; do [ "$(repo_sub "$i")" = "$name" ] && echo "$i"; done | head -1)"
      mkdir -p "docs/$p/$name"
      printf '# %s / %s\n\nRepository `%s` (catalog/repos.yaml). <!-- run · test · entry points · storage · integration with the other repositories; cite %s@<sha> path:line -->\n' "$p" "$name" "$id" "$id" > "$f"
      index_link "$idx" Repositories "- [$name]($name/index.md) — "
    else
      f="docs/$p/$name.md"; [ ! -f "$f" ] || { echo "$f exists"; exit 0; }
      printf '# %s / %s\n\n<!-- one subsystem: what it is and how it works; facts only, each cited <repo>@<sha> path:line; ≤ %s lines -->\n' "$p" "$name" "$CAP_MODULE" > "$f"
      index_link "$idx" Modules "- [$name]($name.md) — "
    fi
    echo "created: $f — linked in $idx (write the one-line summary after the dash)"
    ;;
  rm)
    [ "$#" -eq 4 ] && printf '%s' "$name" | grep -qE "$ID_RE" || { echo "$usage" >&2; exit 1; }
    if [ -d "docs/$p/$name" ]; then
      [ -z "$(find "docs/$p/$name/sources" -type f 2>/dev/null)" ] || { echo "FAIL: docs/$p/$name/sources/ still holds documents — cite them elsewhere or './workspace.sh prune --apply' first" >&2; exit 1; }
      rm_tracked "docs/$p/$name"; index_unlink "$idx" "$name/index.md"
    elif [ -f "docs/$p/$name.md" ]; then
      rm_tracked "docs/$p/$name.md"; index_unlink "$idx" "$name.md"
    else echo "FAIL: neither docs/$p/$name.md nor docs/$p/$name/" >&2; exit 1; fi
    echo "unlinked in $idx — commit with the closeout (git keeps the text)"
    ;;
  *) echo "$usage" >&2; exit 1 ;;
  esac
  ;;

plan)
  sub="${2:-}"; p="${3:-}"; feat="${4:-}"
  usage="usage: workspace.sh plan new <product> <feature> | plan done <product> <feature>"
  [ "$#" -eq 4 ] && printf '%s' "$p" | grep -qE "$ID_RE" && printf '%s' "$feat" | grep -qE "$ID_RE" || { echo "$usage" >&2; exit 1; }
  idx="docs/$p/index.md"; f="docs/$p/plans/$feat.md"
  [ -f "$idx" ] || { echo "FAIL: $idx missing — './workspace.sh doc init $p' first" >&2; exit 1; }
  case "$sub" in
  new)
    [ ! -f "$f" ] || { echo "$f exists"; exit 0; }
    mkdir -p "docs/$p/plans"
    { printf '# %s — %s\n\nStatus: draft\n\n' "$p" "$feat"
      printf '## Goal\n<!-- what will be true when this ships, in one paragraph; cite what it rests on -->\n\n'
      printf '## Writes\n<!-- the repositories and branches it changes; at signing the owner adds, in the header above: "Writes: <REPO> (<branch>)" and "Signed: <name> — <YYYY-MM-DD>" -->\n\n'
      printf '## Steps\n<!-- the commits, in order; tests -->\n\n## Done when\n<!-- what the owner checks before writing "Verified: <name>" -->\n'; } > "$f"
    index_link "$idx" Plans "- [$feat](plans/$feat.md) — "
    echo "created: $f (draft) — linked in $idx; ≤ $CAP_PLAN lines"
    ;;
  done)
    [ -f "$f" ] || { echo "FAIL: no plan $f" >&2; exit 1; }
    st="$(awk 'NR>1 && /^## /{exit} {print}' "$f" | sed -n 's/^Status: //p' | head -1)"
    [ "$st" = verified ] || [ "$st" = abandoned ] || { echo "FAIL: $f is '$st' — 'plan done' follows the owner's Verified: (or an Abandoned:) line" >&2; exit 1; }
    echo "plan done: $p--$feat ($st) — its result must already be in docs/$p/ (modules, repo docs); git keeps everything removed"
    rm_tracked "$f"; index_unlink "$idx" "plans/$feat.md"
    for l in .agents/memory/sessions/*-"$p--$feat".md; do [ -f "$l" ] && rm_tracked "$l"; done
    prune_run 1
    ;;
  *) echo "$usage" >&2; exit 1 ;;
  esac
  ;;

extract)
  # reads an original already under docs/assets/<product>/[<repo>/] (dated name) and writes docs/<product>/[<repo>/]sources/<name>.md
  shift; scope="${1:-}"; shift || true
  usage="usage: workspace.sh extract <product> docs/assets/<product>/[<repo>/]<file>…   (<repo> = a manifest id lowercased; RESTRICTED=<file> header only; OCR=<file> force OCR; OCR_LANGS=<bcp47,…> recognition languages, default zh-Hant,en-US; SECRET_OK=<file> waive a false positive)"
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
    # the original sits directly under docs/assets/<product>/, or one folder down in a folder named for a manifest repo (MY_API → my-api)
    d="$(cd "$(dirname "$src")" 2>/dev/null && pwd -P)"; root="$(cd "$ASSETS/$scope" 2>/dev/null && pwd -P)"; sub=""
    if [ -n "$d" ] && [ "$d" = "$root" ]; then :
    elif [ -n "$d" ] && [ "$(dirname "$d")" = "$root" ] && repo_subs | grep -qxF "$(basename "$d")"; then sub="$(basename "$d")"
    else echo "[$name] SKIP: not under $ASSETS/$scope/ or $ASSETS/$scope/<repo>/ (<repo> = a manifest id lowercased) — './workspace.sh ingest $scope <file>' copies it there first" >&2; fail=$((fail+1)); continue; fi
    rel="${sub:+$sub/}$name"; orig="$ASSETS/$scope/$rel"; out="docs/$scope/${sub:+$sub/}sources/$name.md"
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
  # agent or human: copy a document from anywhere to docs/assets/<product>/[<repo>/]YYYY-MM-DD-<slug>.<ext> (gitignored), then extract it.
  # Originals are only ever ADDED here: identical bytes are reused, different bytes under an existing name are refused,
  # and a file that extract refuses (credential, oversize) is removed again.
  shift; scope="${1:-}"; shift || true
  usage="usage: workspace.sh ingest <product> <file>…   (REPO=<manifest id> files them under the repository they are evidence about — docs/<product>/<repo>/sources/; NAME=<YYYY-MM-DD-slug.ext> names one file — required for non-ASCII titles; DATE=<YYYY-MM-DD> dates the default name; RESTRICTED/OCR/SECRET_OK=<stored name> and OCR_LANGS=<bcp47,…> pass through to extract)"
  printf '%s' "$scope" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || { echo "$usage" >&2; exit 1; }
  [ "$#" -gt 0 ] || { echo "$usage" >&2; exit 1; }
  [ -f "docs/$scope/index.md" ] || { echo "FAIL: docs/$scope/index.md missing — './workspace.sh doc init $scope' first" >&2; exit 1; }
  [ -n "${NAME:-}" ] && [ "$#" -gt 1 ] && { echo "FAIL: NAME= names exactly one file — ingest the others in their own calls" >&2; exit 1; }
  git check-ignore -q "$ASSETS/$scope/probe" 2>/dev/null || { echo "FAIL: $ASSETS/ is not gitignored — originals must never be committed; add '/docs/assets/' to .gitignore" >&2; exit 1; }
  sub=""   # REPO= → one folder below the product, named for the repository the documents are evidence about
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

prune)
  # the document layer's removal as one command: a derivative nothing live cites goes with its original, an orphan original goes alone.
  apply=0; [ "${2:-}" = "--apply" ] && apply=1
  [ "$#" -le 1 ] || [ "$apply" -eq 1 ] || { echo "usage: workspace.sh prune [--apply]   # what keeps each derivative and what is removable; --apply removes (staged for the closeout commit)" >&2; exit 1; }
  prune_run "$apply"
  if [ "$apply" -eq 1 ]; then echo "prune: done — removals are staged and go with the closeout commit; git keeps every removed derivative's text (git show <blob>)"
  else echo "prune: report only — './workspace.sh prune --apply' removes what is listed as 'remove:'"; fi
  ;;

check)
  status=0; n=0; tmp="$(mktemp)"; entries > "$tmp"
  fail() { echo "FAIL: $*" >&2; status=1; }
  cap() { l="$(wc -l < "$1" | tr -d ' ')"; [ "$l" -le "$2" ] || fail "$1 — $l lines, the $3 cap is $2 (cut it, or split it into another document: git keeps the rest)"; }
  # manifest
  while IFS='|' read -r id path remote branch access product; do
    n=$((n+1))
    [ -n "$id" ] && [ -n "$path" ] && [ -n "$remote" ] && [ -n "$branch" ] || fail "manifest entry $n incomplete (needs id/path/remote/default_branch)"
    case "$access" in write|pr-only|read-only) : ;; *) fail "[$id] access must be write|pr-only|read-only (got '${access:-<empty>}')" ;; esac
    [ -z "$product" ] || printf '%s' "$product" | grep -qE "$ID_RE" || fail "[$id] product '$product' is not an id (lowercase kebab)"
  done < "$tmp"
  raw="$(grep -cE '^[[:space:]]*-[[:space:]]*id:' "$MANIFEST" || true)"
  [ "$raw" -le "$n" ] || fail "manifest has $raw 'id:' line(s) but only $n parse — check indentation ('- id:' must start at column 0)"
  bad="$(awk '/^[[:space:]]*#/{next} /^- id:/{if(NF>3)print NR; next} /^[[:space:]]+(path|remote|default_branch|access|product):/{if(NF>2)print NR}' "$MANIFEST")"
  [ -z "$bad" ] || fail "manifest line(s) $(echo $bad | tr ' ' ','): values must be single tokens (no spaces or inline comments)"
  # products: docs/<product>/index.md + modules + repo folders + plans; caps
  for f in docs/*.md; do [ -f "$f" ] && fail "$f — nothing lives directly under docs/: a product is docs/<product>/index.md (README.md › Upgrading from v1)"; done
  for pd in docs/*/; do
    [ -d "$pd" ] || continue; p="$(basename "$pd")"; [ "$p" = assets ] && continue
    printf '%s' "$p" | grep -qE "$ID_RE" || { fail "docs/$p/ — a product id is lowercase kebab"; continue; }
    [ -f "$pd/index.md" ] || { fail "docs/$p/index.md missing — './workspace.sh doc init $p'"; continue; }
    cap "${pd}index.md" "$CAP_INDEX" index
    for m in "$pd"*.md; do
      [ "$(basename "$m")" = index.md ] && continue
      cap "$m" "$CAP_MODULE" module
      grep -qF "($(basename "$m"))" "${pd}index.md" || echo "warn: $m is not linked from docs/$p/index.md — './workspace.sh doc add' does that; add the link line by hand" >&2
    done
    for sd in "$pd"*/; do
      [ -d "$sd" ] || continue; s="$(basename "$sd")"
      if [ "$s" = plans ]; then for pl in "$sd"*.md; do [ -f "$pl" ] && cap "$pl" "$CAP_PLAN" plan; done
      elif [ "$s" = sources ]; then :
      elif repo_subs | grep -qxF "$s"; then
        [ -f "${sd}index.md" ] && cap "${sd}index.md" "$CAP_REPO" "repository doc" || echo "warn: docs/$p/$s/ has no index.md — './workspace.sh doc add $p $s'" >&2
        for x in "$sd"*/; do [ -d "$x" ] && [ "$(basename "$x")" != sources ] && fail "docs/$p/$s/$(basename "$x")/ — only sources/ lives below a repository folder"; done
        for x in "$sd"*.md; do [ -f "$x" ] && [ "$(basename "$x")" != index.md ] && fail "$x — a repository folder holds index.md and sources/ only; a topic is a module docs/$p/<module>.md"; done
      else fail "docs/$p/$s/ — a folder below a product is plans/, sources/ or a manifest repository id lowercased ($(repo_subs | tr '\n' ' '))"; fi
    done
  done
  # derivatives: header, hash, placement; unreferenced ones and orphan originals (removed at closeout — prune --apply)
  subs="$(repo_subs)"
  derivatives | while read -r f; do
    r="${f#docs/}"; p="${r%%/*}"; rest="${r#*/}"
    if [ "${rest#sources/}" != "$rest" ]; then sub=""; name="${rest#sources/}"; else sub="${rest%%/*}"; name="${rest#*/sources/}"; fi
    { [ -z "$sub" ] || printf '%s\n' "$subs" | grep -qxF "$sub"; } && [ "${name#*/}" = "$name" ] \
      || { echo "FAIL: $f — a derivative is docs/<product>/sources/<name>.md or docs/<product>/<repo>/sources/<name>.md (<repo> = a manifest id lowercased)" >&2; exit 1; }
    [ "$(head -1 "$f")" = "---" ] && grep -qE '^sha256: [0-9a-f]{64}$' "$f" && grep -qE "^source: $ASSETS/" "$f" \
      || { echo "FAIL: $f lacks the extract header (source/sha256) — regenerate with ./workspace.sh extract" >&2; exit 1; }
    [ "$(wc -c < "$f")" -le 1048576 ] || { echo "FAIL: $f is over 1 MiB — split the original and re-extract" >&2; exit 1; }
    git check-ignore -q "$f" 2>/dev/null && { echo "FAIL: $f is matched by .gitignore and would never be committed — rename it" >&2; exit 1; }
    o="$(sed -n 's/^source: //p' "$f" | head -1)"
    [ "$o" = "$(orig_of "$f")" ] || { echo "FAIL: $f: header source '$o' is not $(orig_of "$f") — re-extract in place" >&2; exit 1; }
    if [ -e "$o" ] && { [ "$(wc -c < "$o" | tr -d ' ')" != "$(sed -n 's/^bytes: //p' "$f" | head -1)" ] || [ "$(shasum -a 256 "$o" | cut -c1-64)" != "$(sed -n 's/^sha256: //p' "$f" | head -1)" ]; }; then
      echo "warn: $f: $o differs from its header — a new version is a new dated name; re-ingest it or restore the copy" >&2
    fi
  done || status=1
  unref="$(unref_derivatives)"
  [ -z "$unref" ] || { printf '%s\n' "$unref" | sed 's|^|warn: no live document cites |; s|$| — remove it with its original at closeout: ./workspace.sh prune --apply|' >&2; }
  orphans="$(orphan_originals)"
  [ -z "$orphans" ] || { printf '%s\n' "$orphans" | sed 's|^|warn: orphan original (no derivative): |; s|$| — remove it at closeout: ./workspace.sh prune --apply|' >&2; }
  tracked="$(git ls-files "$ASSETS" 2>/dev/null | wc -l | tr -d ' ')"
  [ "$tracked" -eq 0 ] || fail "$tracked file(s) under $ASSETS/ are tracked by git — originals are never committed (git rm --cached them; keep '/docs/assets/' in .gitignore)"
  # plans: the whole lifecycle in the header (H1 .. first '## '), Status: derived from the lines, one Signed:/Verified: (the human's hand)
  awaiting=""
  for pl in docs/*/plans/*.md; do
    [ -f "$pl" ] || continue
    hdr="$(awk 'NR>1 && /^## /{exit} {print}' "$pl")"; body="$(awk 'f{print} /^## /{f=1}' "$pl")"
    st="$(printf '%s\n' "$hdr" | sed -n 's/^Status: //p' | head -1)"
    [ -n "$st" ] || fail "$pl — no 'Status:' line in the header (draft|signed|shipped|verified|abandoned)"
    stray="$(printf '%s\n' "$body" | grep -nE '^(Writes|Status|Signed|Amended|Shipped|Verified|Abandoned):' | head -3 | tr '\n' ' ')"
    [ -z "$stray" ] || fail "$pl — lifecycle line(s) below the first '## ' heading (the header holds the whole lifecycle): $stray"
    sc="$(printf '%s\n' "$hdr" | grep -c '^Signed: ' || true)"; vc="$(printf '%s\n' "$hdr" | grep -c '^Verified: ' || true)"
    [ "$sc" -le 1 ] || fail "$pl — $sc 'Signed:' lines; a plan is signed once (a change beyond its Writes: set is a new plan)"
    [ "$vc" -le 1 ] || fail "$pl — $vc 'Verified:' lines; the owner's check is recorded once"
    if [ "$vc" -ge 1 ]; then
      printf '%s\n' "$hdr" | grep -q '^Shipped: ' || fail "$pl — 'Verified:' without 'Shipped:'"
      printf '%s\n' "$hdr" | grep -q '^Verified: [^[:space:]]' || fail "$pl — 'Verified:' needs a name: 'Verified: <name>' (optionally '— <YYYY-MM-DD>')"
      printf '%s\n' "$hdr" | awk -F' — ' '/^Verified: / && NF >= 2 && $2 !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/ { bad = 1 } END { exit bad }' || fail "$pl — 'Verified: <name> — …': what follows ' — ' must be a date"
    fi
    want=draft; [ "$sc" -ge 1 ] && want=signed
    printf '%s\n' "$hdr" | grep -q '^Shipped: ' && want=shipped
    [ "$vc" -ge 1 ] && want=verified
    printf '%s\n' "$hdr" | grep -q '^Abandoned: ' && want=abandoned
    [ "$st" = "$want" ] || fail "$pl — 'Status: $st' contradicts the lifecycle lines (expected $want)"
    [ "$want" = shipped ] && awaiting="$awaiting ${pl#docs/}"
    if [ "$sc" -ge 1 ]; then
      w="$(printf '%s\n' "$hdr" | sed -n 's/^Writes: //p' | head -1)"
      [ -n "$w" ] || fail "$pl — a signed plan needs a 'Writes:' line (the repositories and branches the signature covers)"
      for tok in $(printf '%s' "$w" | tr ',' '\n' | awk '{print $1}'); do
        grep -qE "^- id:[[:space:]]*$tok[[:space:]]*$" "$MANIFEST" || fail "$pl — Writes: '$tok' is not a manifest repo id"
      done
    fi
    p="${pl#docs/}"; p="${p%%/*}"; grep -qF "(plans/$(basename "$pl"))" "docs/$p/index.md" || echo "warn: $pl is not linked from docs/$p/index.md" >&2
  done
  [ -z "$awaiting" ] || echo "info: shipped plan(s) awaiting the owner's 'Verified:' line:$awaiting"
  # session logs: name grammar and cap
  for l in .agents/memory/sessions/*.md; do
    [ -f "$l" ] || continue; b="$(basename "$l")"; [ "$b" = TEMPLATE.md ] && continue
    printf '%s' "$b" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9]+-[a-z0-9-]+--[a-z0-9-]+\.md$' || fail "$l — a log is YYYY-MM-DD-<agent>-<product>--<task>.md"
    cap "$l" "$CAP_LOG" "session log"
  done
  # parties (AGENTS.md › Boilerplate and organizations): the boilerplate branch carries no organization's content, and an
  # organization's branch changes no boilerplate path since its merge base with it. Working tree, so the hook sees it before a commit.
  bp="$(git config --get workspace.boilerplate 2>/dev/null || echo main)"   # the boilerplate ref: main; in an organization's fork, upstream/main
  here="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  if [ -z "$here" ]; then
    echo "info: detached HEAD (a rebase in progress?) — party check skipped"
  elif [ "$here" = "$bp" ]; then
    [ "$n" -eq 0 ] || { echo "FAIL: $MANIFEST declares $n repo(s) on $bp — the boilerplate ships the template; fleet entries belong on an organization's branch (in a fork: git config workspace.boilerplate upstream/main)" >&2; status=1; }
    stray="$( { git ls-files; git ls-files --others --exclude-standard; } | sort -u | party org | grep -vxF "$MANIFEST" )"
    if [ -n "$stray" ]; then
      printf '%s\n' "$stray" | sed "s|^|FAIL: organization content on $bp: |" >&2
      echo "      $bp carries the boilerplate only — this belongs on the organization's branch" >&2; status=1
    fi
  elif base="$(git merge-base "$bp" HEAD 2>/dev/null)"; then
    touched="$( { git diff --name-only --no-renames "$base"; git ls-files --others --exclude-standard; } | sort -u | party boilerplate )"
    if [ -n "$touched" ]; then
      printf '%s\n' "$touched" | sed "s|^|FAIL: boilerplate changed on $here since its base with $bp: |" >&2
      echo "      rules and infrastructure change on $bp only: restore a file with 'git checkout $(git rev-parse --short "$base") -- <path>' (a workspace defect goes to the log's TODO as a [workspace] line first); 'git mv' a -workspace-- log to one of this branch's product ids" >&2
      status=1
    fi
    behind="$(git rev-list --count "HEAD..$bp")"
    [ "$behind" -eq 0 ] || echo "warn: $bp has $behind commit(s) this branch lacks — its rules may have changed; the owner syncs the branch (git rebase $bp), then runs check" >&2
    # the boilerplate names no organization: look for this branch's own repo and product ids in it
    pats="$(mktemp)"
    { entries | cut -d'|' -f1; repo_subs; sed -n 's/^[[:space:]]*product:[[:space:]]*//p' "$MANIFEST"; for d in docs/*/; do [ -d "$d" ] && basename "$d"; done; } \
      | grep -vxiE 'readme|blueprint|workspace|plans|sources|assets' | awk 'length >= 3' | sort -u > "$pats"
    hits="$( [ -s "$pats" ] && git grep -n -I -i -w -F -f "$pats" "$bp" -- . 2>/dev/null )"
    if [ -n "$hits" ]; then
      printf '%s\n' "$hits" | head -5 | cut -c1-180 | sed 's|^|warn: the boilerplate names this organization — |' >&2
      echo "warn: $(printf '%s\n' "$hits" | grep -c .) line(s) of $bp name this branch's repositories or products — the boilerplate names no organization; propose the rewording as a [workspace] TODO" >&2
    fi
  else
    echo "info: no '$bp' ref here — party check skipped (in a fork: git config workspace.boilerplate upstream/main)"
  fi

  if [ "$n" -eq 0 ]; then
    [ "$here" = "$bp" ] && echo "info: $bp is the boilerplate — its manifest is the template" || echo "warn: manifest has no repos yet — edit catalog/repos.yaml"
  fi
  newest="$(ls .agents/memory/sessions 2>/dev/null | grep -E '^[0-9]{4}-' | sort | tail -1)"
  echo "info: $(derivatives | wc -l | tr -d ' ') document derivative(s); newest session log: ${newest:-none yet}"
  [ "$status" -eq 0 ] && echo "check: PASS ($n repo(s) in manifest)" || echo "check: FAIL" >&2
  exit "$status"
  ;;

help)
  sed -n '2,16p' "$0"
  ;;

*)
  sed -n '2,16p' "$0" >&2
  exit 1
  ;;
esac
