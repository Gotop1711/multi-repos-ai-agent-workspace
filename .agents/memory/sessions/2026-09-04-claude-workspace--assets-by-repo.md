# Session Log — 2026-09-04 | claude | workspace

## Task
Owner adopted, in the session discussion, the proposal that a human-supplied
document may sit one folder below its scope's document layer, in a folder
named for the fleet repository it is evidence about — so the prototype's
screenshots and the new UI's screenshots of the same dialog stay separated
without a repo-named scope. Implement it as workspace infrastructure on `main`
(owner's branch rule: infrastructure → `main`, project work → `rea`). The
fold-in of scopes `rea-proto` and `ui` into `rea` follows on `rea` after the
rebase and is logged there.

## Completed
1. `workspace.sh` — `repo_sub`/`repo_subs` helpers; `ingest` takes
   `REPO=<manifest id>` (validated against the manifest, lowercased `_`→`-`,
   grammar-checked) and files under `docs/assets/<scope>/<repo>/`; `extract`
   locates an original at the scope root or one repo folder down and writes
   the derivative to the mirrored path; `check` derives the scope from the
   path segment after `docs/`, refuses a second level or a non-repo folder,
   pins `source:` to exactly `docs/assets/<scope>/[<repo>/]<name>`, and the
   orphan-original warning names the right `extract` command. `extract` also
   keeps `received:` across a re-extract.
2. Sandbox `.agents/scratch/assets-by-repo-test/` (gitignored, disposable):
   the patched script against a three-repo fake manifest, 26 cases — see
   `docs/workspace/document-layer.md` §15 for the list. The real file was
   patched with the same script afterwards and asserted byte-identical to the
   tested copy.
3. Specifications and rules: `document-layer.md` §15 amendment,
   `scope-grammar.md` §14 amendment, trees in `README.md`, `docs/README.md`,
   `BLUEPRINT.md`; `AGENTS.md` write-surface path and citation form gain
   `[<repo>/]`; `CHANGELOG.md` entry; `docs/workspace.md` Changes entry.

## Decisions & pitfalls        ← the valuable part
- **Folder = a manifest repo id, one level, nothing else.** The owner's need
  is "separate by project", and the only vocabulary the workspace already owns
  for "project" is the manifest. Free-form folders would reopen the
  kind-first / feature-first debate the scope grammar settled; a repo folder
  is the grammar's own "repository = the evidence axis" applied to where
  evidence sits. Depth stops at one, same discipline as topic files.
- **Why not header-only (`repo:` line, flat files).** Greppable, but the owner
  asked for *separation*, and `ls docs/assets/rea/` interleaving proto and ui
  frames by date is the thing they were working around with repo-named scopes.
- **The one concrete breakage was `check`'s scope derivation** —
  `basename(dirname(dirname f))` returns `sources` for a nested derivative,
  so the old `source:` prefix test would have failed for the wrong reason.
  Replaced by a path-segment derivation and, while there, the prefix test
  became an equality (`source:` must be exactly the mirrored path). Stricter
  is safe: `extract` has always written exactly that.
- **Sandbox T6 exposed a pre-existing defect, fixed in the same change:** a
  bare `extract` re-run dropped `received:` (only `ingest` set it), so the
  spec's "fix a bad extraction by re-running it" changed the blob for a reason
  unrelated to the text — and finding 23's remedy (re-extract after the OCR
  fix) would have silently done the same to 13 derivatives. Now `extract`
  reads `received:` back from the existing derivative when `RECEIVED=` is
  unset; a derivative that never had one still gets none (no invented value).
  Called out separately in the CHANGELOG (Fixed) so it is not buried.
- **Sandbox first, real file second, byte-identical assertion.** The real
  script was never edited by hand; the same patch script produced both copies
  and `cmp` proved it. The 2026-09-03 ingest session used the same pattern.
- **Repo id → folder: `tr 'A-Z_' 'a-z-'`, then the id grammar.** `REA_PROTO`
  → `rea-proto`; an id such as `odd.name` lowercases to something outside the
  grammar and `REPO=` is refused with nothing written (T5).
- **`main` has an empty manifest** — the REA fleet was registered on `rea`
  (`2fbbd31`) — so `REPO=REA_PROTO` cannot run on `main`; `check` on `main`
  only warns about the 12 `docs/assets/rea-proto/` originals whose derivatives
  live on `rea`, which is expected and, incidentally, exercised the new orphan
  warning on real files.
- **Pitfall: the CHANGELOG anchor differs between branches.** The first
  insertion anchored on `rea`'s top entry ("Rebase rea onto the docs/assets
  main"), which does not exist on `main`; the assertion caught it and the
  entry was inserted above whatever the first `## [` is. Anchor on structure,
  not on a sibling's text, when the same file diverges across branches.
- **Not `git add -A` on `main`.** `docs/ui/` (the owner's own ingest of the
  ui screenshot) is untracked in the working tree and belongs to the fold-in
  on `rea`; the infrastructure commit stages explicit paths only.
- **Expected rebase shape next.** `rea` and `main` both append a Changes entry
  at the same anchor of `docs/workspace.md` (rea: finding 23; main: this
  change) — one conflict, resolved oldest-first by date (rea's entry first,
  it was committed earlier today). `CHANGELOG.md` will not conflict (rea's
  commits did not touch it); `docs/workspace.md` Open findings will not
  conflict (rea appended 23 at EOF, main did not touch it).

## TODO / known-incomplete
- On `rea`, after the rebase: re-ingest the 12 proto frames with
  `REPO=REA_PROTO` and the 1 ui frame with `REPO=REA_UI` into scope `rea`;
  `git rm` the `rea-proto` derivatives and `docs/rea-proto.md`; move P1–P3
  into `docs/rea.md` as F13–F15; remove the byte-identical `docs/assets/
  rea-proto/` and `docs/assets/ui/` copies after sha verification; dated note
  on workspace finding 23 (paths changed). Logged on `rea`.
- `scope: rea` on the three manifest entries — on `rea`, where the fleet is
  declared; the manifest is outside the agent write surface (Open finding 8),
  done here only because the owner adopted the whole proposal that named it.
- Finding 23 (English-only OCR) is still the owner's one-line edit at
  `workspace.sh` — the request line inside the `ocr` program, now a few lines
  further down than the `:150` the finding cites (the header comment grew).
- BLUEPRINT §4's deferred `docs/<scope>/sources/INDEX.md` row is unchanged;
  if repo folders make `ls` answer "do we have a document about X" well
  enough, that trigger recedes rather than advances.
- Carried over: SSH for `git@github.com`; `origin/nabu-dashboard`
  merge-or-abandon; `docs/workspace.md` Open finding 8.
