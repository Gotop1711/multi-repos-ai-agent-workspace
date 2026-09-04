# workspace/document-layer — how human-supplied documents enter the workspace

> **Status: adopted 2026-09-03.** Specification of this repository's document
> layer. Born as the signed plan `workspace--document-layer` and shipped the
> same day; moved here verbatim from `docs/plans/` on 2026-09-03 by owner
> instruction, because `docs/plans/` gates child-repo work only. The lifecycle
> lines below are its provenance. Amendments are appended in §15 and take
> precedence over the sections they amend.

Scope: workspace
Signed: gotop1711 — 2026-09-03
Shipped: 2026-09-03 — this workspace's closeout commit "Apply the two signed plans" (CHANGELOG entries of this date); the plan files and the session log were renamed to the `--` grammar in the same commit.
Status: signed 2026-09-03; edits in §9 to be applied by the agent.

## 1. The question and the decision

**Question.** "I have lots of documents with different file types. How should
I organise them into this project?"

**Decision.** Git is the right store for exactly one thing here: text that
agents read and cite. It is the wrong store for the bytes of PDFs, decks,
spreadsheets and scans — history is append-only and never rewritten
(CHANGELOG.md:3; docs/README.md:58), git-lfs is absent, and every closeout
pushes to GitHub (README.md:28-29). So:

- **Originals of every type live in one external document store you already
  own** (a cloud-drive folder with version history, or a NAS with snapshots),
  mirrored per machine at a gitignored symlink `originals/` — the same pattern
  the repo uses for child code (gitignored `projects/`, BLUEPRINT.md:22-25).
  **Humans write the store; agents only read it.**
- **Only text enters git**, under `sources/<scope>/`, as exactly one
  machine-generated Markdown derivative per original (`<name>.<ext>.md`) whose
  header carries the original's sha256. The header is the manifest,
  distributed per document; no central file to conflict.
- **A new `./workspace.sh extract`** writes derivatives from files already in
  `originals/<scope>/` with macOS-native tools (textutil, PDFKit via swift),
  refuses credential-shaped text, and prints the citation.
- **A finding cites the derivative it read by git blob**:
  `sources/<scope>/<name>.<ext>.md@<blob12>` — the exact analogue of
  `<repo>@<sha>`; `git show <blob12>` reproduces it forever.
- **The pre-commit hook refuses any binary and any file over 1 MiB**, so
  "text only" needs no agent vigilance (BLUEPRINT.md:57-60). `check` FAILs on
  repo-internal invariants (non-`.md` file, missing header, > 1 MiB, ignored
  path, header pointing outside its scope) and only **warns** when a stored
  original drifted from its header — store-side state an agent may not touch
  must never block the mandatory closeout.
- Everything else — OCR, deck/sheet extractors, a generated index, a batch
  `verify`, originals versioned as a read-only child repo — is a §4 growth
  trigger.

Organising axis: `sources/<scope>/` uses the **same scope ids as
`docs/<scope>.md`** (plan `workspace--docs-scope-grammar`): a product, a
cross-cutting system, or `workspace`. Never by file type — type is incidental
and is carried by the extension.

Adoption note: nothing has "bitten twice" because there are no sessions yet.
This is an owner decision to give a new input class a home, recorded as such
in the CHANGELOG, with day-one mechanics cut to the irreversible-mistake
guards (binary / size / secret) and the minimum that makes a document citable —
plus Vision OCR and pptx/xlsx extraction, because the owner's pile (many scans,
many decks and spreadsheets) means those two triggers have already bitten.

## 2. Layout

```
multi-repos-ai-agent-workspace/
├── README.md, AGENTS.md, CLAUDE.md, CHANGELOG.md   ← rule edits in §9
├── workspace.sh                     ← setup | clone | cite | restore | extract | check
├── .githooks/pre-commit             ← check + REFUSES any staged binary or blob > 1 MiB (+ gitleaks if installed)
├── .gitignore                       ← + /originals (anchored, no trailing slash so a symlink matches), /projects/, /.agents/scratch/, .DS_Store
├── catalog/repos.yaml               ← unchanged (code fleet only)
├── docs/<scope>.md, docs/plans/     ← unchanged roles: findings ABOUT documents go to Open findings, citing sources/…@<blob>
├── .agents/scratch/                 ← gitignored: triage staging, OCR trials, exported cited versions (git show <blob> > here)
├── sources/                         ← NEW, created on demand, TRACKED, TEXT ONLY (UTF-8, no BOM): one .md derivative per original
│   ├── payments/                    ← scope = a docs/<scope>.md name
│   │   ├── 2026-03-12-acme-payments-api-spec.pdf.md       ← header + "<!-- page N -->" text
│   │   ├── 2026-04-02-meeting-cutover-notes.docx.md      ← textutil text
│   │   ├── 2026-04-03-standup.md.md                      ← verbatim copy of a text-native original, same header
│   │   ├── 2026-06-15-vendor-onboarding-recording.mp4.md  ← header only, status: no-text
│   │   └── 2026-07-01-comp-bands.xlsx.md                 ← header only, status: restricted (PII/NDA: citable as existing, no text in git)
│   ├── security/…                   ← cross-cutting system scopes
│   └── workspace/…                  ← org-wide material and documents about this workspace itself
├── originals -> ~/Library/CloudStorage/<Drive>/workspace-originals   ← NEW, gitignored symlink per machine
│   └── payments/2026-03-12-acme-payments-api-spec.pdf    ← identical tree to sources/, minus the .md
└── projects/                        ← unchanged; documents already inside a child are cited <repo>@<sha> + path, never copied

OUTSIDE the repo:
<store>/<scope>/<name>               ← the one document store: append-only; a new version is a new dated file;
                                        set the folder to "available offline"/mirror, not streaming placeholders
password manager / vault             ← every credential; findings record the location, never the value (AGENTS.md:46)
personal / HR / legal storage        ← anything that is not evidence for engineering work
```

## 3. Routing by document kind

| Document kind | Destination | Git handling | Citation |
|---|---|---|---|
| Text-native notes and small data (md, txt, csv, tsv, json, yaml, xml, log, ics) | original in `originals/<scope>/<date>-<slug>.<ext>`; `extract` writes `sources/<scope>/<name>.<ext>.md` (verbatim body + header) | text derivative tracked; original in the store | `sources/<scope>/<name>.<ext>.md@<blob12> L<n>` |
| Loose source, config and text-diagram files (sql, py, sh, toml, ini, conf, svg, drawio, mermaid, plantuml, ipynb, rst, adoc, tex) | same — ingested verbatim by MIME sniffing (any non-binary encoding); strip notebook outputs first if an `.ipynb` exceeds 1 MB | text derivative tracked | `…@<blob12> L<n>` |
| Office documents (docx, doc, rtf, odt, html) | same; derivative via `textutil` | text derivative tracked | `…@<blob12> §<heading> L<n>` |
| PDFs with a text layer (specs, manuals, papers, exported decks) | same; derivative via PDFKit (swift) with `<!-- page N -->` markers | text derivative tracked | `…@<blob12> p.<N>` |
| Scanned PDFs, images, whiteboard photos, diagrams | same; `extract` runs macOS Vision OCR when a PDF has no usable text layer, and on png/jpg/tiff/heic directly (§8) | OCR text tracked, `extractor: vision-ocr`; OCR claims ≤ medium confidence | `…@<blob12> p.<N>` or "figure, see original" |
| Presentations (pptx, key) | pptx: `extract` prints the text per slide (python3 stdlib, §8); Keynote `.key` is a folder bundle (and gitignored): export to pptx or PDF first | text derivative tracked | `…pptx.md@<blob12> slide <N>` or `…pdf.md@<blob12> p.<N>` |
| Spreadsheets (xlsx, numbers) | xlsx: `extract` prints each sheet as tab-separated rows (python3 stdlib, §8; empty cells are skipped, so columns can shift — export a CSV when column position matters); Numbers is a bundle: export to xlsx or CSV first | text derivative tracked | `…xlsx.md@<blob12> sheet <name> L<n>` |
| Emails (eml, emlx, msg) | save as Raw Message Source **with attachments removed first** (Mail: Message ▸ Remove Attachments) or paste headers + body into a `.txt`; attachments are ingested as their own documents; msg → eml first; only decision-bearing messages, never whole mailboxes | text derivative tracked | `…eml.md@<blob12> L<n>` |
| Live cloud documents (Google Docs/Sheets/Slides, Confluence, Notion, Apple Notes) | a routine, not an exception: export a dated snapshot — Docs → docx/pdf, Sheets → CSV per sheet, Slides → PDF, Confluence/Notion → HTML/Markdown — and ingest the export; put the source URL in the scope document's Changes entry (`as received: <url>`) | text derivative tracked | `…@<blob12>` + locator; the URL alone is never a citation |
| Chat threads (Slack/Teams exports, WhatsApp txt) | only decision-bearing threads, exported to txt/json, names of private individuals reviewed | verbatim derivative | `…@<blob12> L<n>` |
| Cross-cutting org documents (architecture, policies, roadmaps, vendor comparisons) | `sources/<system-scope>/…` or `sources/workspace/…` — exactly one home; other scopes cite by path | text derivative tracked | as above |
| Large media and datasets (video, audio, dumps, > 1 MB of text) | store only; header-only derivative `status: no-text` (paste a transcript or data dictionary under the header if one exists; split oversize text by chapter) | header tracked, bytes never | `…@<blob12> t=<mm:ss>` / "see original" |
| PII / NDA / no-copy (HR, compensation, customer exports, signed contracts naming people) | store only; `RESTRICTED=<name> ./workspace.sh extract …` writes a header-only derivative `extractor: none`, `status: restricted` | header tracked, text never | `…@<blob12>` (existence + sha256) |
| Anything containing a credential | never ingested — value to the vault; a REDACTED copy (`[REDACTED: what — where kept]`, always starting with `[REDACTED`) goes into the store under a new dated name and is ingested as a normal document | redacted derivative only | as above |
| Documents already inside a child repo (README, ADRs, openapi.yaml) | stay in `projects/<repo>`; `extract` refuses anything not under `originals/<scope>/` | not copied | `<repo>@<sha> path` (AGENTS.md:55-57) |
| Public versioned references (RFCs, cloud docs, papers with DOI) | out; a dated PDF snapshot enters only when the exact version is the claim | none | URL/DOI + version + access date in the finding |
| Archives (zip, tar) | unpack in scratch; a human places the members in the store; ingest individually | members as their own kinds | per member |
| Exact duplicates, sync-client conflict copies | keep one in the store; `extract` re-extracts identical bytes idempotently | nothing new | existing cite |
| Superseded / new versions | a NEW dated file beside the old one, never an overwrite; the old derivative **stays untouched** in `sources/` (it costs KB); supersession is recorded in the scope document's Changes entry and, if the old text is wrong, by a struck Open finding | both in history | old cites keep resolving |
| Agent-produced summaries, comparisons, analyses | `docs/<scope>.md` Open findings — never `sources/` | docs system | n/a |
| Untriaged pile, working extracts, OCR trials | `.agents/scratch/` | never | none |
| Personal / unrelated files | the human's own storage | none | n/a |

Removal of a derivative (a leaked or NDA text withdrawn) is a **human**
commit; its blob remains in history — say so in the Changes entry.

## 4. Naming

`originals/<scope>/YYYY-MM-DD-<slug>.<ext>` and its derivative
`sources/<scope>/YYYY-MM-DD-<slug>.<ext>.md` (extension appended, never
replaced, so `spec.pdf` and `spec.docx` cannot collide and pairs sort adjacent).

- `<scope>`: a `docs/<scope>.md` id (product or system) or `workspace`. One
  document, one home. Never name a scope `credentials*`, `projects` or `.env*`
  — `.gitignore:2,8,11` match directory names at any depth; `check`'s
  `git check-ignore` guard catches it, but do not go there. The date prefix
  defuses those patterns for every file name *(verified: a derivative named
  `…-credentials-policy.pdf.md` is not ignored; a scope directory
  `credentials/` is)*.
- `YYYY-MM-DD`: the document's OWN date (authored / signed / meeting /
  received), then the date received, then the ingest date. Do not trust
  `mdls -name kMDItemContentCreationDate` (download date, UTC-shifted).
- `<slug>`: lowercase ASCII `[a-z0-9-]`; no version words unless the source
  itself numbers editions. One-liner *(amended; expected:
  `Résumé du contrat.docx` → `2026-03-12-resume-du-contrat.docx`,
  `Payments API Spec FINAL v3 (2).pdf` → `2026-03-12-payments-api-spec-final-v3-2.pdf`;
  non-Latin titles produce an empty slug — write an English slug by hand)*:
  ```
  f="<as-received name>"; DATE=YYYY-MM-DD
  ext="$(printf '%s' "${f##*.}" | tr 'A-Z' 'a-z')"; b="${f%.*}"
  s="$(printf '%s' "$b" | iconv -c -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null | tr -d "'\`^~\"" | tr 'A-Z' 'a-z' | sed -E 's/[^a-z0-9]+/-/g; s/^-//; s/-$//')"
  [ -n "$s" ] || s=untitled; echo "$DATE-$s.$ext"
  ```
- `extract` enforces `^[0-9]{4}-[0-9]{2}-[0-9]{2}-[a-z0-9-]+\.[a-z0-9]+$` and
  SKIPs otherwise; the as-received filename is recorded once in the scope
  document's Changes entry for the ingest.
- Never rename or edit a file in the store: a corrected export or a new
  revision is a new dated name. `check` warns if a stored original's size or
  bytes no longer match its derivative's header.
- **Re-scoping** a document = the human moves the original to
  `originals/<newscope>/` in the store and, in the same human commit,
  `git rm`s the old derivative and re-runs `extract <newscope>`; the new
  derivative gets a new blob, the old blob still resolves via `git show`. A
  bare `git mv` of a derivative is wrong: its header would still name the old
  store path and `check` fails on it.

## 5. The manifest is the header of each derivative

No central `documents.yaml`: it would duplicate what every derivative carries
(BLUEPRINT.md:131 "duplication drifts"), conflict when two machines ingest,
and reach thousands of lines on day one. The header is written only by
`extract` and checked by `check`:

```
---
source: originals/payments/2026-03-12-acme-payments-api-spec.pdf
sha256: e76aa64cfa16a0e20d224e30b3642e6f25799172d96214fb354ba8a42b77b013
bytes: 13218
extractor: pdfkit
status: ok
---
<!-- page 1 -->
Acme Payments API — Specification v3
3.2 Rate limits: 120 requests per minute per tenant.
<!-- page 2 -->
…
```

Fields: `source` (path in the store — always under this derivative's own
scope), `sha256`/`bytes` (of the original — the integrity anchor for bytes
that never enter git), `extractor` (`verbatim | textutil | pdfkit | none`),
`status` (`ok | no-text | restricted`), optional
`secret_review: waived YYYY-MM-DD`. Provenance beyond the file (who sent it,
the as-received name or URL, "NOT ingested: … lives in 1Password › Payments",
supersessions) goes in the scope document's Changes at ingest:

```
### [Ingest 4 human-supplied sources] — 2026-09-03
#### Added
- sources/payments/2026-03-12-acme-payments-api-spec.pdf.md — as received "Payments API Spec FINAL v3 (2).pdf", from j.doe@acme.example 2026-03-15
- sources/payments/2026-06-15-vendor-onboarding-recording.mp4.md — header only; original 1.1 GB in the store
- NOT ingested: "acme creds and endpoints.xlsx" — contains API keys; lives in 1Password › Payments (values not recorded)
- sources/payments/2026-03-12-spec.pdf.md superseded by 2026-08-01-spec-v4.pdf.md
```

Finding aid on day one: `ls sources/*/`, `grep -rl 'phrase' sources/`,
`grep -h '^source:' -r sources | sort`. A generated `sources/INDEX.md` is a §4
trigger — but an ingest of more than ~100 documents has already met the
"outgrows eyeballing" trigger (BLUEPRINT.md:119): generate it at migration
step 7 and regenerate at each ingest.

## 6. Citation form

**Token:** `sources/<scope>/<name>.<ext>.md@<blob12>` + locator (`p.<N>`,
`L<n>`, `§<heading text>`) + optional ≤ 12-word verbatim quote that
`grep -rnF` re-finds. It mirrors `<repo>@<sha>` + file + symbol
(AGENTS.md:55-57): path = file, blob = commit, locator = symbol.

**Compute:** `git hash-object sources/<scope>/<name>.md | cut -c1-12` (printed
by `extract`). After the closeout commit the same value is
`git rev-parse --short=12 HEAD:sources/<scope>/<name>.md` *(verified equal)*.
A citation is provisional until that commit — `git show` of an uncommitted
blob fails *(verified)*.

**Example** (Open findings of `docs/payments.md`):
`- Acme allows 120 requests/min per tenant — sources/payments/2026-03-12-acme-payments-api-spec.pdf.md@3d2c68fbb0fc p.1 "120 requests per minute per tenant"; direct (pdfkit text layer); high; Q: per tenant or per key?`
`- payments-api enforces 100 rpm, below the contract — payments-api@9f1e2d3 src/ratelimit.go RateLimiter.Allow + sources/payments/…pdf.md@3d2c68fbb0fc p.1 (fleet line from one ./workspace.sh cite); corroborated; high.`

**Re-examine:** `git show 3d2c68fbb0fc` — works after the file was renamed,
replaced or removed *(verified)*; `git log --oneline --find-object=<blob>`
lists the commits that added or removed it. The header inside the blob names
the original and its sha256, so `shasum -a 256 originals/<scope>/<name>`
proves the store copy when it matters. Only shallow or blobless clones
(`--depth`, `--filter=blob:none`) break `git show <blob>` — clone the
workspace in full.

**Drift test** (document form of examination-bar rule 3):
`[ "$(git hash-object sources/…md | cut -c1-12)" = <blob12> ] && echo unchanged || echo RE-VERIFY`.

**Evidence rule:** a document is direct evidence of what it says; a claim
about code or the fleet drawn from it is `inferred` until re-verified in
`projects/` at a `<repo>@<sha>`. OCR-derived text caps confidence at medium;
when layout, figures or formulas matter, open the original before promotion.

**Paste contract:** a finding line pastes into `./workspace.sh restore`
unchanged: fleet tokens are restored, document tokens print "read it with:
git show <blob>", and file/symbol locators are ignored (§9, `restore` edit).

## 7. Who may write what

- Humans: place originals in the store (`originals/<scope>/`, dated name);
  run `extract`; make the rule-edit commit and the import commit (human
  commits, not agent closeouts); withdraw or re-scope derivatives.
- Agents: read `sources/`; open `originals/` only for a figure or table the
  derivative lost, or to `shasum` a cite; may run
  `./workspace.sh extract <scope> originals/<scope>/<name>` when `check`
  reports a missing derivative or the human dropped a new file — the only
  writes are `sources/<scope>/*.md`, and only as `extract` output; never
  hand-edit a derivative; never write into `originals/` or the store.

## 8. Text extraction with the tools on this machine

Present *(verified)*: `/usr/bin/swift` 6.2.1, `textutil`, `qlmanage`, `mdls`,
`file`, `iconv`, `python3` 3.11. Absent: `pdftotext`, `pandoc`, `gitleaks`,
`git-lfs`. `tesseract` is on PATH but **cannot launch** (`dyld: Library not
loaded: …/liblept.5.dylib`) — do not rely on it.

Recommended installs (outside the repo): `brew install gitleaks` (the hook
already calls it if present; without it the secret gate is only `extract`'s
grep) and optionally `brew install poppler` (`pdftotext -layout` as an alternative
PDF text route; not needed for OCR — PDFKit renders the pages). gitleaks syntax is unverified here: newer
releases use `gitleaks dir <path>` and `gitleaks git --pre-commit --staged`;
`detect`/`protect` are older forms — check `gitleaks --help` after installing.

Per format, as `extract` runs them:
- `md txt csv tsv json yaml yml xml log eml emlx ics` → verbatim body; any
  other extension whose `file -b --mime-encoding` is not `binary` → verbatim
  too (sql, py, svg, drawio, toml, …) *(amended)*.
- `docx doc rtf odt html htm webarchive` → `textutil -convert txt -stdout "$f"`
  *(docx round-trip verified; Word auto-numbering is not preserved — cite
  heading text, not numbers)*. `rtfd`, `key`, `pages`, `numbers` are folder
  bundles: `extract` SKIPs them — export from the app first *(amended)*.
- `pdf` → a 5-line Swift PDFKit program embedded in `extract`
  (`<!-- page N -->` per page; exit 2 unreadable, exit 3 encrypted →
  `status: no-text`) *(verified)*. With poppler, `pdftotext -layout "$f" -`
  is equivalent.
- `pptx xlsx` → the `ooxml-text` python3 program embedded in `extract` (§9):
  pptx per slide (`<!-- slide N -->`), xlsx per sheet as tab-separated rows
  *(verified on synthetic files built from the OOXML structure; test on real
  PowerPoint and Excel exports before applying)*. `msg` → save as eml first.
- Every derivative is normalised to **UTF-8 without BOM**: UTF-16/32 originals
  (Excel "Unicode Text", many Windows exports) are converted with `iconv`; a
  NUL byte anywhere makes git — and the hook — treat the file as binary
  *(amended)*.
- Images and scanned PDFs → the `ocr` Swift program embedded in `extract`
  (§9): PDFKit renders each page at 200 dpi and Vision recognises the text,
  `<!-- page N (ocr) -->` per page; png/jpg/tiff/heic go straight to Vision
  *(verified: a rendered one-page PDF is read correctly in 1.3 s)*. `extract`
  falls back to OCR when a PDF's text layer averages under 20 characters per
  page; a scan carrying a printed header line can slip through — force it with
  `OCR=<name>`. OCR text is medium quality: cite it at ≤ medium confidence;
  composite transparent PNGs onto white first.
- Secret gate (inside `extract`, before anything is written): key formats
  (`-----BEGIN … PRIVATE KEY`, `AKIA…`, `gh[pousr]_…`, `xox[abp]-…`, `sk-…`,
  `AIza…`, JWT `eyJ…`, `scheme://user:pass@`) plus case-insensitive
  `password|secret|api_key|token|bearer [:=] value`. A hit REFUSES the file and
  prints line numbers only. A redaction always starts with `[REDACTED` — the
  gate ignores values that begin with `[` *(amended)*. `SECRET_OK=<name>`
  waives a documented false positive and records `secret_review: waived <date>`.
- Restricted documents: `RESTRICTED=<name> ./workspace.sh extract <scope>
  originals/<scope>/<name>` writes the header-only derivative, so "generated by
  `extract` only" stays literally true *(amended)*.
- Size gate: extracted text over 1 MB is refused (split the original); the
  hook refuses any blob over 1 MiB and any binary regardless.

## 9. Exact rule and mechanics edits (human-applied, one commit before any ingest)

**.gitignore** — replace lines 1-5 with anchored patterns and add `.DS_Store`
(fixes Open finding 4 in `docs/workspace.md`) *(verified: `git check-ignore -v
originals` → `.gitignore:5:/originals`)*:
```
# Product layer — never tracked by the workspace repo
/projects/

# Document originals — the store, mirrored per machine as a symlink (anchored, no trailing slash so a symlink matches)
/originals

# Disposable working artifacts — safe to delete anytime
/.agents/scratch/
.DS_Store
```

**.githooks/pre-commit** — replace lines 5-8 with *(binary and size gates
verified; `ACMR` and the gitleaks fallback amended)*:
```
./workspace.sh check || exit 1
# Text only, ever: history is never rewritten, so one binary would be permanent.
git diff --cached --numstat | awk -F'\t' '$1=="-" { print "FAIL: binary staged: " $3 " — originals belong in ./originals, not in git"; bad=1 } END { exit bad }' || exit 1
git diff --cached --name-only --diff-filter=ACMR -z | while IFS= read -r -d '' f; do
  [ "$(git cat-file -s ":$f")" -le 1048576 ] || { echo "FAIL: $f is over 1 MiB — too big for this repo; store it as an original"; exit 1; }
done || exit 1
if command -v gitleaks >/dev/null 2>&1; then
  gitleaks git --pre-commit --staged --no-banner 2>/dev/null || gitleaks protect --staged --no-banner || exit 1
fi
```
Also change the comment at line 3 to "check inspects the working tree; the
binary/size gates inspect the index".

**workspace.sh**
- Header (lines 2-8): add `extract <scope> originals/<scope>/<file>…` and
  change both `sed -n '2,7p'` (lines 148, 152) to `2,8p`.
- Line 27: `case "$cmd" in clone|cite|restore|check|extract)`.
- Line 99, first statement inside `for token in $*; do` *(amended)*:
  ```
  case "$token" in
    sources/*@*) echo "[$token] is a document citation — read it with: git show ${token#*@}" >&2; continue ;;
    */*|p.[0-9]*|L[0-9]*) continue ;;   # file / symbol locators on a pasted finding line (Open finding 6)
  esac
  ```
  A bare symbol token (`RateLimiter.Allow`) still reports "not in the
  manifest" — the residue of Open finding 6; keep symbols on the finding
  line after the file token, or extend the arm to `*.*` if no repo id
  contains a dot.
- Line 12: `trap 'rm -f "$tmp" "$ocr" "$ooxml"' EXIT` (the two extra helper
  programs below are temp files too).
- New `extract)` subcommand before `check)` *(amended after the critic:
  no copy into the store; bundle guard; MIME fallback; UTF-8 normalisation;
  `[`-aware secret regex; `RESTRICTED`; write only after hashing succeeded;
  OCR and OOXML arms added for the owner's pile)*:
```
extract)
  shift; scope="${1:-}"; shift || true
  printf '%s' "$scope" | grep -qE '^[a-z0-9][a-z0-9-]*$' || { echo "usage: workspace.sh extract <scope> originals/<scope>/<file>…   (scope = a docs/<scope>.md name)" >&2; exit 1; }
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
    [ -f "$orig" ] && [ "$(cd "$(dirname "$src")" && pwd -P)" = "$(cd "originals/$scope" && pwd -P)" ] \
      || { echo "[$name] SKIP: place the file in originals/$scope/ first — humans write the store, extract only reads it" >&2; fail=$((fail+1)); continue; }
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
        binary) [ -s "$body" ] && { echo "[$name] REFUSED: extracted text is not text (encoding $enc)" >&2; rm -f "$body"; fail=$((fail+1)); continue; } ;;
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
    { printf -- '---\nsource: %s\nsha256: %s\nbytes: %s\nextractor: %s\nstatus: %s\n' "$orig" "$sha" "$(stat -f%z "$orig")" "$extractor" "$status"
      [ "${SECRET_OK:-}" = "$name" ] && printf 'secret_review: waived %s\n' "$(date +%F)"
      printf -- '---\n'; cat "$body"; } > "$out"; rm -f "$body"
    echo "[$name] → $out ($extractor, $status); cite as $out@$(git hash-object "$out" | cut -c1-12) after the closeout commit"
  done
  [ "$fail" -eq 0 ] || { echo "extract: $fail file(s) not ingested." >&2; exit 1; }
  ;;
```
- In `check)`, before line 140 (`[ "$n" -gt 0 ] || echo "warn: …"`)
  *(repo-internal FAILs verified; the scope-path check and the warn-not-fail
  mismatch branch amended)*:
```
  if [ -d sources ]; then   # document layer: every file is a .md derivative with a header; text only, ≤ 1 MiB
    find sources -type f ! -name .DS_Store | while read -r f; do
      case "$f" in *.md) : ;; *) echo "FAIL: $f — only .md derivatives live under sources/ (originals go to the store)" >&2; exit 1 ;; esac
      [ "$(head -1 "$f")" = "---" ] && grep -qE '^sha256: [0-9a-f]{64}$' "$f" && grep -qE '^source: originals/' "$f" \
        || { echo "FAIL: $f lacks the extract header (source/sha256) — regenerate with ./workspace.sh extract" >&2; exit 1; }
      [ "$(wc -c < "$f")" -le 1048576 ] || { echo "FAIL: $f is over 1 MiB — split the original and re-extract" >&2; exit 1; }
      git check-ignore -q "$f" && { echo "FAIL: $f is matched by .gitignore and would never be committed — rename it" >&2; exit 1; }
      o="$(sed -n 's/^source: //p' "$f" | head -1)"
      case "$o" in "originals/$(basename "$(dirname "$f")")/"*) : ;; *) echo "FAIL: $f: header source $o is not under this scope — re-extract in place" >&2; exit 1 ;; esac
      if [ -e "$o" ] && { [ "$(stat -f%z "$o")" != "$(sed -n 's/^bytes: //p' "$f" | head -1)" ] || [ "$(shasum -a 256 "$o" | cut -c1-64)" != "$(sed -n 's/^sha256: //p' "$f" | head -1)" ]; }; then
        echo "warn: $f: $o differs from its header — a new version is a new dated name; re-run extract or restore the store copy" >&2
      fi
    done || status=1
    echo "info: $(find sources -type f -name '*.md' | wc -l | tr -d ' ') document derivative(s) under sources/$([ -e originals ] || echo ' (originals not mounted: hashes not verified)')"
  fi
```

**AGENTS.md**
- Lines 8-11, replace with: "All records and documentation here are produced
  by agents: session logs written by the agent at every closeout (`check`
  only reports the newest one); the docs system per `docs/README.md`
  (findings into a scope document's Open findings; the examined body only
  past the examination bar). The one exception is `sources/` — text
  derivatives of human-supplied documents, written only by
  `./workspace.sh extract`; the originals live in your document store,
  mirrored at gitignored `originals/`."
- Line 18: also "list `sources/<scope>/` — the human-supplied documents about
  it" (merge with the scope-grammar plan's edit of the same line).
- Lines 32-35: "Read-only git in children and in this repo (`rev-parse`,
  `hash-object`, `show`, `log` for citations and re-examination)".
- Lines 42-45: add `sources/<scope>/*.md` **only as `./workspace.sh extract`
  output** (never hand-edited) to the write surface; "never write inside
  `originals/` or the store".
- After line 46, a red line: "Nothing binary and nothing over 1 MiB enters
  this repository — the pre-commit hook refuses it; originals go to the store.
  A document containing a credential is never ingested: a human vaults the
  value and places a redacted copy in the store. Documents already inside
  `projects/` are never copied into `sources/`."
- After line 60: the citation rule of §6 (token, compute command, re-examine
  with `git show`, evidence rule, OCR confidence cap; `restore` skips document
  tokens and locators).
- Lines 73-74: "(a `sources/` derivative is the agent-readable form of its
  original, not excluded output)".

**docs/README.md**
- Line 4: "(human-supplied documents are not in `docs/`: their text lives in
  `sources/<scope>/`, their originals in the store — see `AGENTS.md`)".
- Lines 17, 20: claims about what a document states carry `sources/…@<blob>`
  citations (+ locator).
- Lines 30-31, 35-39: examination-bar items 1 and 3 in document form
  (`hash-object` of the cited derivative still equals the cited blob; "reality
  moves" when it differs or a newer dated edition sits beside it).
- After line 61: "Files under `sources/` are generated by `workspace.sh extract`
  only (a restricted document via `RESTRICTED=<name>`); a bad extraction is
  fixed by re-running it, never by editing the derivative; a superseded
  document gets a new dated file and the old derivative stays; removal or
  re-scoping of a derivative is a human commit; each ingest appends a Changes
  entry (files, as-received names or URLs, provenance, supersessions,
  `NOT ingested: … lives at …`)."

**README.md** — lines 10-13 ("session logs written by the agent at closeout …
except `sources/` …"); tree lines 15-18 (add `sources/` and
`originals -> <store>`); Get started step 4
(`ln -s <your-document-store> originals && ./workspace.sh extract <scope> originals/<scope>/<files>`);
table: `workspace.sh` gains `extract`; a row for `sources/<scope>/` +
`originals/`; add the four missing rows (Open finding 17).

**docs/BLUEPRINT.md** — §1 idea 1 (line 25): the document layer sentence; idea
4 (line 38): "one written log per agent session"; idea 7 (lines 58, 63-64):
`extract` and the hook's binary / 1 MiB gate; §2 tree (lines 74-76, after 84):
`/originals`, `extract`, hook gate, `sources/<scope>/`, `originals/`; §4 rows:
Vision OCR inside `extract` (second load-bearing `no-text` scan); pptx/xlsx
extractors (second hand export); generated `sources/INDEX.md` (`ls`/`grep`
stop answering, or > ~100 documents); originals as a read-only child repo in
`repos.yaml` (second dispute over which version was read, or a store with
too-short history); `workspace.sh verify` (a store mismatch found late twice);
`restore` writing `git show <blob>` into scratch (second hand
re-examination); §5 rows: documents tracked as binaries here (rejected:
append-only history, no git-lfs, GitHub's 100 MB cap, agents read text); a
documents git repo as a read-only child on day one (rejected: full clone by
every machine, a leaked secret purgeable only by rewriting history, which
kills every later citation); a central `catalog/documents.yaml` (rejected:
duplicates the headers); Git LFS (rejected: a dependency on every clone,
quotas, pointers still fill history); §6 item 7 (lines 165-166): "…never the
memory; document originals are as safe as the store they live in (versioned
or snapshotted by requirement), their extracted text as safe as the remote";
§6 item 8: "a staged binary or > 1 MiB file makes the hook fail; a stray file
or a headerless derivative under `sources/` makes `check` fail, an edited
stored original makes it warn; `git show <blob>` of a document citation
returns the exact text the finding read".

**.agents/memory/sessions/TEMPLATE.md:4** — `{scope}` = a `docs/` scope id or
`workspace` (merge with the scope-grammar plan's edit).

**CHANGELOG.md** — `## [Document layer: text in sources/, originals in a store] — <date>`
/ Added (`sources/`, `extract`, hook gates, `check` extension) / Changed
(AGENTS.md surface and evidence rules; anchored `.gitignore`; "owner decision,
not a §4 trigger: documents were the first input class with no home").

## 10. What stays out, and where it goes

- Credentials: password manager or vault; never the repo, ideally not the
  store; findings record the location (AGENTS.md:46).
- Binaries and anything over 1 MiB: the store, cited by the header sha256.
- PII / NDA / no-copy material: the store only; `status: restricted` header in
  git so it is citable as existing.
- Documents inside child repos: stay there, `<repo>@<sha>` + path.
- Public versioned references: URL/DOI + version; snapshot only when the exact
  version is the claim.
- Agent summaries and analyses: `docs/<scope>.md`, never `sources/`.
- The untriaged pile and working extracts: `.agents/scratch/`.
- Personal/unrelated files: personal storage. The cloud-sync client must never
  point at the workspace folder itself — only `originals` links into the drive.

## 11. Migration steps (ordered)

0. **Rule commit (human):** apply §9; `./workspace.sh check` → PASS; commit
   and push. Then `brew install gitleaks` (recommended), optionally
   `brew install poppler`. Do not depend on tesseract.
1. **Create the store (settled: a plain local folder for now):**
   `mkdir -p ~/Documents/workspace-originals && ln -s ~/Documents/workspace-originals originals`.
   Until it becomes a versioned cloud-drive folder or a snapshotted NAS, only
   the extracted text is protected by the remote — keep the folder inside
   whatever backs up your home directory (Time Machine), and move it when a
   versioned store exists: the symlink target changes, nothing in git does.
2. **Export the live documents, then inventory without moving anything.**
   Google Docs → docx or pdf, Sheets → xlsx or CSV per sheet, Slides → pptx or
   pdf, Confluence/Notion → HTML or Markdown, Apple Notes → pdf; name each
   export by its export date and keep the source URL for the Changes entry.
   Then: types
   `find "$PILE" -type f | awk -F. '{print tolower($NF)}' | sort | uniq -c | sort -rn`;
   sizes `find "$PILE" -type f -size +1M | wc -l`; duplicates among files under
   50 MB `find "$PILE" -type f -size -50M -exec shasum -a 256 {} + | sort | awk '{print $1}' | uniq -d`
   (large media: spot by size + name); secret sweep with gitleaks (syntax per
   `gitleaks --help`) or the §8 grep, plus
   `find "$PILE" \( -name '.env*' -o -name '*.pem' -o -name '*.key' -o -iname '*credential*' \)`.
   Set hits aside: values to the vault, redacted copies for what is still evidence.
3. **Triage into scopes, coarsely, in scratch:** `.agents/scratch/inbox/<scope>/`
   is a naming and scope staging area, not a second copy — symlink or move
   large media into it rather than copying; `workspace` is the default scope
   when unsure (re-scoping later is the §4 procedure and old blob citations
   keep resolving). Nothing is expected to be restricted (`RESTRICTED` remains for exceptions); unpack
   archives; export bundles and unsupported formats from their apps. If the
   catalog is still empty, product scopes are the repo ids you intend to
   declare; declare and `clone` them before writing product findings.
4. **Rename** with the slug one-liner, the document's own date first; keep one
   of each byte-identical duplicate.
5. **Place and extract per scope (human):**
   `mv .agents/scratch/inbox/payments/* originals/payments/ && ./workspace.sh extract payments originals/payments/*`.
   Act on every non-OK line: `SKIP` (rename, or export a bundle), `REFUSED
   credential` (vault + redacted copy under a new name + rerun, or
   `SECRET_OK=<name>` for a documented placeholder), `REFUSED over 1 MB`
   (split), `no-text` (OCR found nothing, or "no extractor for .ext" — export from the
   app).
6. **Review:** `./workspace.sh check` → PASS; `du -sh sources` (hundreds of
   documents should be tens of MB); spot-check `head -12` of a few of each type.
7. **Provenance and index:** create `docs/<scope>.md` where absent and append
   the ingest Changes entry (§5); for > ~100 documents generate `sources/INDEX.md`.
8. **Import commit (human):** `git add sources docs && git commit && git push`
   — the hook runs `check` and the gates. No session log is fabricated for it.
9. **First agent session:** "survey `sources/<scope>`, open findings in
   `docs/<scope>.md`" — the agent cites `…@<blob>` per finding and closes out.
10. **Retire the pile** only after step 8 is pushed and the store is fully
    synced; keep it 30 days.
11. **Second machine:** `git clone … && ./workspace.sh setup && ln -s <store> originals && ./workspace.sh check`
    — PASSes before the store is mounted (hashes then unverified). Clone in
    full, never `--depth` or `--filter=blob:none`.
12. **Steady state:** a new document = the human drops it in the store under
    its dated name; `extract` runs in the session that first uses it; the
    closeout commit carries the derivative and the Changes line; a new version
    is a new name.

## 12. Growth triggers (bite twice)

Generated `sources/INDEX.md` checked by `check` (with many documents of every
kind it is generated at migration step 7 already); `workspace.sh verify` (batched
`shasum` of the store, launchd) — until then `check` compares sizes and hashes
only mounted originals whose size still matches; `restore` writing
`git show <blob>` into scratch; originals versioned as a read-only child repo
`projects/originals` (needs git-lfs or a size discipline of its own); a skill
for the OCR/export how-to; a second store for NDA material; plus two existing
defects worth fixing at the next script touch — the index-aware hook and the
`restore` fetch (Open findings 5 and 9 in `docs/workspace.md`). Not a
trigger but the first TODO after migration: move the originals folder to a
versioned store.

## 13. Accepted tradeoffs and rejected alternatives

Accepted: tracked text doubles a text-native original's bytes (KB) and grows
the repo by ~1-3 % of each PDF — for cross-machine, cross-runtime readability
and dead-disk survival of what agents actually read; a blob pins what was
read, not when (`git log --find-object` recovers the commits); originals are
as safe as the store — hence the versioned/snapshotted requirement; the secret
gate is a grep plus gitleaks-if-installed, prose secrets can pass — the
human's step-2 sweep is the fuller net; `check` re-hashes mounted originals
whose size matches (a non-hydrated cloud file forces a download — keep the
store "available offline"); extraction is macOS-only, Linux runtimes read but
cannot extract.

Rejected: originals tracked in git under `docs/<scope>/sources/` (permanent
bloat, secrets inside Office containers invisible to a text scan yet pushed);
a documents repo as a read-only child on day one (full clone everywhere, a
leaked secret purgeable only by rewriting history, `cite` exits 1 for the
whole fleet until it is cloned); a central `catalog/documents.yaml` plus
`ingest`/`verify` subcommands (duplicates the headers, conflicts across
machines, thousands of lines on day one); sha256 of the original as the
citation token (does not pin the derivative the agent actually read); Git LFS;
a tracked `_inbox/`; per-scope human READMEs inside the document tree (a second
unexamined home for scope knowledge); citing documents by URL/location only
(uncitable, unreproducible, unreadable on another machine); git submodules;
`extract` copying inputs into the store (an agent write to human-owned state);
`check` failing on store-side drift (blocks the mandatory closeout on state
the agent may not touch).

## 14. Settled by the owner (2026-09-03)

Answers given interactively in the session that wrote this plan; they replace
the earlier assumptions and questions.

- **Store:** none yet — a plain local folder outside the repo, symlinked as
  `originals/` (migration step 1). Consequence: until it moves to a versioned
  cloud-drive folder or a snapshotted NAS, the remote protects only the
  extracted text; the originals are as safe as the home-directory backup.
  Moving later changes only the symlink target. The "originals as a read-only
  child repo" trigger stays deferred: with no git-lfs, a pile of scans and
  decks would bloat it.
- **Sensitivity:** nothing restricted — all extracted text may reach the
  private remote. `RESTRICTED=<name>` stays available for exceptions;
  credentials still never enter (redacted copy under a new name).
- **Subjects:** a mix — product documents under product scopes, the rest under
  system scopes or `workspace`. Body claims about code are promoted only once
  the product's repos are declared and cloned.
- **Agents may run `extract`** on files placed in the store; the AGENTS.md
  wording in §9 stands as written.
- **Pile shape:** mostly PDFs, Office files and text, **plus** many scans or
  image-only files, many decks and spreadsheets, and many live cloud documents.
  Consequences, applied above: Vision OCR and the pptx/xlsx extractor ship in
  the rule commit (§8, §9) instead of waiting for a trigger; exporting live
  documents as dated snapshots is a routine step (§3, §11); with many
  documents of every kind, `sources/INDEX.md` is generated at migration.
- **Products span repos** (from the scope-grammar plan): `scope: <product>`
  keys go on those manifest entries when the fleet is declared, so
  `sources/<product>/` and `docs/<product>.md` share one id.
- **Cross-cutting systems are conventions with no home repo:**
  `sources/<system>/` may exist for such a scope; `docs/<system>.md` is created
  when the owner names it in a task; every claim cites a consumer repo.

Still unknown and not needed for the layout: the count and total size of the
pile. They decide only how long migration step 5 takes and whether the
`.agents/scratch/inbox/` staging should use symlinks for large media.

## 15. Amendments

### 2026-09-03 — agents may add originals to the store (`ingest`)

Owner instruction, recorded in `../../CHANGELOG.md` (entry "Agents may ingest
documents…"). Supersedes the first two bullets of §7 and the sentence "Humans
write the store; agents only read it" in §1: `./workspace.sh ingest <scope>
<file>…` copies a document from anywhere into
`originals/<scope>/YYYY-MM-DD-<slug>.<ext>`, mounting
`originals -> $WORKSPACE_STORE` (default `~/Documents/workspace-originals`)
when absent, then runs `extract` — so migration steps 1, 4 and 5 are one
command for either party. What §7 still forbids, now enforced mechanically:
overwriting (different bytes under an existing name are refused), renaming,
removing or editing an existing original; the one removal `ingest` performs is
of a file it had itself just added and `extract` then refused (credential,
oversize). The §4 slug recipe is applied only to ASCII titles; a non-ASCII
title must be named with `NAME=` — measured on this owner's pile, the recipe
silently deletes CJK and yields a plausible name that has lost its subject
(`docs/workspace.md` finding 25). A leading or trailing date in an ASCII title
is taken as the document's own date; `DATE=` overrides; the file's
modification date is the last resort. A derivative written by `ingest` carries
`received: <as-received name>`, so the scope document's Changes entry is no
longer the only index from an original title to its stored name. Why the rule
changed: the first real ingest (2026-09-03) was blocked outright — the agent
could not mount the store or place a file, so no document claim could be
cited — which contradicts the workspace's purpose of autonomous agent work.

### 2026-09-03 — no store, no symlink: originals copied into gitignored `docs/assets/<scope>/`, text under `docs/<scope>/sources/`

Owner instruction, recorded in `../../CHANGELOG.md`. Supersedes the layout of
§1 and §2 (external store, `originals` symlink, root-level `sources/`), the
destination and citation columns of §3 wherever they say `originals/<scope>/`
or `sources/<scope>/`, the paths of §4, the `source:` form of §5, the citation
form of §6, and migration steps 1, 5, 11 and 12 of §11. The layout now:

- `docs/assets/<scope>/YYYY-MM-DD-<slug>.<ext>` — the original, copied there by
  `./workspace.sh ingest`; `/docs/assets/` is gitignored and `check` fails if
  anything under it is tracked. A fresh clone has no originals, only text, as
  before; `check` then reports hashes as not verified.
- `docs/<scope>/sources/YYYY-MM-DD-<slug>.<ext>.md` — the derivative, written
  by `ingest` or by `extract <scope> docs/assets/<scope>/<name>`; header
  `source: docs/assets/<scope>/<name>`; cited
  `docs/<scope>/sources/<name>.<ext>.md@<blob12>` plus the same locators as
  before (`§heading`, `L<n>`, `p.<N>`).
- Everything human-supplied about a scope therefore sits under `docs/<scope>/`
  beside its scope document and topic files; `sources` and `assets` are
  reserved names so no topic file can collide.
- A rename (`docs/README.md` › Scopes) moves `docs/assets/<old>` with a plain
  `mv` (gitignored copies), `git mv`s `docs/<old>/sources`, and re-extracts to
  refresh the `source:` headers; old blobs still resolve with `git show`.

Why: the store and symlink existed to keep binaries out of git while backing
them up elsewhere; the owner decided the originals are simply copies of their
own files, wants them inside the repository directory, and does not need them
in git — so the mount step bought nothing. What §1 still guards is unchanged:
only text enters git, the hook refuses binaries and files over 1 MiB, and a
derivative's sha256 pins the bytes it was extracted from.

### 2026-09-04 — one optional folder below a scope: the repository the documents are evidence about

Owner instruction, recorded in `../../CHANGELOG.md`. Amends the layout of the
2026-09-03 "no store" amendment above, §3's destination column and §4's paths:
a document may sit one folder below its scope, and that folder can only be a
repository of the fleet —

- `docs/assets/<scope>/[<repo>/]YYYY-MM-DD-<slug>.<ext>` and
  `docs/<scope>/sources/[<repo>/]YYYY-MM-DD-<slug>.<ext>.md`, where `<repo>` is
  a `catalog/repos.yaml` id lowercased with `_` → `-` (`REA_PROTO` →
  `rea-proto`, `REA_UI` → `rea-ui`). `REPO=<manifest id> ./workspace.sh ingest
  <scope> <file>…` files documents there; `extract` accepts either level;
  `check` derives the scope from the path, refuses a second level and any
  folder that is not a manifest id, and pins each header's `source:` to
  exactly `docs/assets/<scope>/[<repo>/]<name>`. Citation:
  `docs/<scope>/sources/[<repo>/]<name>.<ext>.md@<blob12>` + the same locators
  as before; `restore` already skips any `sources/…@…` token.
- A document about the product rather than one repository — a PM
  specification, a meeting note — stays at the scope root, as before. So does
  a document about two repositories at once (a side-by-side comparison); the
  finding cites both repos.
- Depth stops at one level and the vocabulary is the manifest's, not
  free-form: the folder is the same axis as `<repo>@<sha>` citations — *what
  is this document evidence about* — never a kind, a feature or a date.
- `extract` now keeps an existing derivative's `received:` line when re-run
  without `RECEIVED=`. A bare re-extract used to drop it, so "fix a bad
  extraction by re-running it" changed the blob for a reason unrelated to the
  text. Surfaced by the sandbox test of this change.

Why: the owner organises evidence by which repository produced it —
screenshots of the prototype's rendering of a dialog beside the new UI's
rendering of the same dialog — and with scope as the only axis the only outlet
was a scope named after the repository (`nabu-ui` on 2026-09-03; `ui` and
`rea-proto` on 2026-09-04), which fragments the product's findings tray. The
scope grammar's "repository = the evidence axis" now also places documents.
Verified in a disposable sandbox (`.agents/scratch/assets-by-repo-test/`), 26
cases: root-level and repo-folder ingest; `received:` preserved; unknown and
grammar-violating `REPO=` refused with nothing written; `extract` refuses a
non-repo folder; `check` fails on a non-repo folder, on a second level and on
a tampered `source:`; the orphan warning names the right command; re-extract
is blob-stable; `restore` skips the new citation form.

### 2026-09-04 — no Changes entry per ingest: provenance in the header and the session log

Owner instruction, recorded in `../../CHANGELOG.md`; scope documents are
maintained state (`scope-grammar.md` §14, same date). Supersedes every mention
of a scope document's Changes entry in this specification: §3's "supersession
is recorded in the scope document's Changes entry", the "say so in the Changes
entry" of the removal note under §3, §4's "the as-received filename is
recorded once in the scope document's Changes entry for the ingest", §5 and
§7 wherever they name one, §11's migration steps, and the sentence on it in
the 2026-09-03 ingest amendment above. Provenance now lives in exactly two
places: per file, the derivative's header (`source:`, `sha256:`, `bytes:`,
`received:`, `status:`); for the narrative — the folder the files came from,
what was not ingested and why, which dated edition supersedes which — the
ingesting session's log. A derivative's removal (a human commit) is likewise
recorded in that session's log; its blob remains in history.

### 2026-09-04 — OCR recognition languages; markers alone are not text

Owner instruction, recorded in `../../CHANGELOG.md`. Amends §8's OCR
paragraph and §9's `ocr` program: `VNRecognizeTextRequest` was created without
`recognitionLanguages`, so Vision ran at its default `en-US` and every
Traditional-Chinese page or screenshot came back as Latin/symbol mojibake
under `status: ok` (`docs/workspace.md` finding 23; measured 3 junk lines vs
33 correct on the same image). The program now takes the languages as its
second argument, `extract` passes `OCR_LANGS` (default `zh-Hant,en-US`) at
both call sites, and `ingest` passes it through. An unsupported tag does not
fail — Vision falls back to `en-US` — so a wrong `OCR_LANGS` shows up as
mojibake, not as an error. §8's "OCR text is medium quality: cite it at
≤ medium confidence" stands; what changes is that the text now exists.
Second correction, same session: the no-text test counted the
`<!-- page N (ocr) -->` marker as body, so an extraction that recognised
nothing was stamped `ok`; page, slide and sheet markers are now excluded and
such a derivative is `status: no-text`. Verified in a sandbox on the two real
303 screenshots (png, jpg), an `en-US` override (3 lines again), `zh-Hant`
alone, an unsupported tag, an all-white image, and a verbatim text file.
