# Workspace CHANGELOG

Records changes to **this workspace's rules and infrastructure only** — the
boilerplate (`AGENTS.md` › Boilerplate and organizations): `AGENTS.md`,
`workspace.sh`, the hook, the docs system's rules and specifications, the
layout. Written on `main` only, and never naming an organization. Never a
child repository's state, an organization's own fleet declaration or the
sync of its branch, a manifest access or branch change made for a plan, or
a plan's progress: those live in the plan's header, the scope document and
the session log.
Append-only: never rewrite past entries.
Format: `## [description] — YYYY-MM-DD` + `### Added / Changed / Fixed`.

## [The owner's `Verified:` line closes a plan; `prune` removes what the documentation no longer cites] — 2026-09-16

### Added
- `Verified: <name> — <YYYY-MM-DD> — <what was checked>` — a twelfth
  lifecycle line, written by a human exactly once, after `Shipped:`, when
  the owner has checked the shipped result. `Status: verified` derives from
  it and is terminal, so `shipped` now reads as "landed, awaiting the
  owner's check". `check` fails a second `Verified:`, one without
  `Shipped:` or without its `<name> — <date>` prefix, and one below the
  first `##`; every run it lists the shipped plans still awaiting the line
  (`docs/README.md` › The signature gate). Resolves `docs/workspace.md`
  finding 34, carried from an organization's branch.
- `./workspace.sh prune [--apply]` — the document layer's removal as one
  command: without the flag, every derivative with what keeps it (the
  citing document and the heading the citation sits under) and what is
  removable; with `--apply`, `git rm` of each derivative nothing live cites
  (`rm` if it was never committed), `rm` of its original and of orphan
  originals, staged for the closeout commit. `check`'s unreferenced and
  orphan warnings are unchanged and now point to it; both share one scan
  (`keepers`, `unref_derivatives`, `orphan_originals`).

### Changed
- The closeout that first sees a `Verified:` line settles the plan's
  `[<feature>]`-tagged findings — promoted or deleted — and runs
  `prune --apply`, so the documents a plan needed leave with it
  (`AGENTS.md` › Every session › 5 and › Red lines; `docs/README.md` › The
  signature gate and › Writing rules; `README.md`; amendments dated today
  in `docs/workspace/scope-grammar.md` and `document-layer.md`).
- Why. Owner decision, prompted on an organization's branch: the agent's
  `Amended: … (confirmed by … in session)` never carried the reviewer's own
  hand, so a plan awaiting the owner's check and a plan done looked the
  same; and a derivative's removal, a hand procedure at closeout, gave no
  view of why a file was still kept. `Signed:` opens the gate, `Verified:`
  closes it — both human. Removal stays tied to citation, not to approval,
  but is now visible and one command.
- Migration, on an organization's branch after the sync: a plan already
  carrying a pre-rule `Verified:` line rewrites it in the adopted form —
  the owner's name first — and sets `Status: verified`; `check` names the
  plans that still need the line. Sandbox-verified (bash 3.2): seven header
  cases, the report, and `--apply` over tracked, never-committed and
  orphan files.

## [Rules and infrastructure change on main only; the boilerplate names no organization] — 2026-09-11

### Changed
- Owner decision. `main` is the boilerplate each organization's branch (or
  fork) is synced from, and every tracked path belongs to one of two parties
  (`AGENTS.md` › Boilerplate and organizations). **Organization content** is
  a closed list — `catalog/*.yaml` (on `main`, `repos.yaml` is the template
  with no entries), `docs/<scope>.md` and `docs/<scope>/` for its own scopes,
  `docs/plans/`, session logs not scoped `workspace`. **Boilerplate** is
  every other path: changed on `main` only, identical on every branch, and
  never naming an organization — its repositories, scopes, plans, people or
  facts. Defined by exclusion, so a path added later is boilerplate unless
  the change that adds it says otherwise. So the files that share this
  file's "rules and infrastructure only" range are, besides `AGENTS.md`,
  `README.md`, `CLAUDE.md`, `workspace.sh`, `.githooks/` and `.gitignore`:
  `docs/README.md`, `docs/BLUEPRINT.md`, `docs/workspace.md`,
  `docs/workspace/`, `.agents/memory/sessions/TEMPLATE.md` and the
  `-workspace--` logs — not the sessions folder as a whole, whose other logs
  are each organization's journey.
- On an organization's branch a defect in or a change to the workspace is a
  `[workspace]` proposal in the session log's TODO — worded without the
  organization's names — which the owner takes to `main`; `docs/workspace.md`
  finding ids are allocated on `main` only (23–33 are skipped: used on
  organization branches or in reverted history). The organization's own
  infrastructure — its fleet declaration, a sync with `main`, the migration
  after one — is logged under one of its scope ids, never here.
  `docs/workspace/sources/` holds documents about the workspace only; an
  organization-wide document goes under one of that organization's scopes.
  Rule text in `AGENTS.md`, `docs/README.md`, `TEMPLATE.md`, `README.md`,
  `docs/BLUEPRINT.md` (§3, §4 — the ~25-scope table moves to
  `catalog/scopes.yaml` — §5, §6 item 9); amendments in
  `docs/workspace/scope-grammar.md` §14 and `document-layer.md` §15.
- `workspace.sh check`: on `main`, fails on organization content (manifest
  entries, scope documents other than `workspace`, plans, logs not scoped
  `workspace`); on any other branch, fails on each boilerplate path changed
  since its merge base with `main` and names the remedy, warns when `main`
  has commits the branch lacks, and warns where `main` names one of the
  branch's own manifest or scope ids. The boilerplate ref is `main`, or `git
  config workspace.boilerplate` (in a fork: `upstream/main`); a detached HEAD
  skips the check. The orphan scan now skips scopes with no document on the
  current branch: in a clone shared by several branches, a closeout on
  `main` was told to delete another branch's originals.
- Organization names removed, by owner instruction, from this file's earlier
  entries, the two specifications, `workspace.sh`'s comments and the
  `-workspace--` session logs — names and organization-only details replaced
  by generic wording, no rule changed. Git history still holds the old text.
- Migration, once, on an organization's branch after its next sync: `check`
  lists what to move. That one sync may stop on conflicts in boilerplate
  files the branch edited; `git rebase -X ours main` keeps `main`'s side,
  which the migration restores anyway (never a standing habit: it would
  also override a conflict inside the branch's own manifest), and the
  pre-sync tip keeps the branch's text. Each boilerplate file the branch
  changed is restored (`git checkout <merge base> -- <path>`) after any
  workspace finding in it is re-worded as a `[workspace]` proposal in the
  migration's log; its other facts already stand in the branch's session
  logs. Each `-workspace--` log the branch wrote is renamed (`git mv`) to
  one of its own scope ids.

## [CHANGELOG records the workspace only — never a project or a plan] — 2026-09-08

### Changed
- Owner clarification. An entry here is for a change to the workspace's
  rules or infrastructure. A change under `projects/` (a branch, a commit,
  an access level or default branch set in `catalog/repos.yaml` for a
  plan) or to a plan under `docs/plans/` is recorded where its state lives
  — the plan's header (`Amended:`, `Shipped:` …), the scope document's
  Body, the session log — and never here. Stated in this file's header,
  `AGENTS.md` › Every session › Close out, `README.md` and
  `docs/BLUEPRINT.md`. The one misfiled entry (2026-09-07, two repositories
  opened as pr-only) is removed from the organization's branch, where it
  was written; its facts stand in both plans' headers and the 2026-09-07
  session log.

## [One signature per plan; amendments confirmed in session; the header carries the whole lifecycle] — 2026-09-08

### Changed
- Owner decision. A plan is signed once (`Signed:`), for the write set its
  new `Writes:` header line names. A later change that stays inside that
  set — same repositories and branches, same lead scope, the deliverable
  the H1 names — is confirmed by the owner in the session and recorded by
  the agent as `### A<n>` under `## Amendments` plus an `Amended:` header
  line; there is no second signature. A change beyond the set is a new
  plan carrying `Supersedes:`, signed on its own; the old plan receives
  `Superseded:`. Every lifecycle line — `Scope:`, `Scopes:`, `Writes:`,
  `Status:`, `Signed:`, `Amended:`, `Shipped:`, `Abandoned:`, `Superseded:`,
  `Supersedes:`, `Renamed:` — sits in the header between the H1 and the
  first `##`, and a one-word `Status:` (draft | signed | paused | shipped |
  abandoned | superseded), maintained by the agent, names the state. Rules
  in `docs/README.md` › The signature gate; amendment in
  `docs/workspace/scope-grammar.md` §14; `docs/BLUEPRINT.md` item 6.
- `workspace.sh check` fails a plan with no `Scope:` or `Status:`, with a
  lifecycle line below the first `##`, with more than one `Signed:`, with
  a `Status:` that contradicts its lines, or — when signed — without
  `Writes:` or with a `Writes:` token that is not a manifest repo id. A
  `Superseded:` plan is history for the derivative scan like a shipped or
  abandoned one.
- Why: a second `Signed:` for an amendment leaves a plan without one
  nameable state; the trigger was a plan's seventh amendment on an
  organization's branch (2026-09-08). The three existing plans are migrated
  to the header form in that branch's closeout.

## [A shipped or abandoned plan no longer keeps a document alive] — 2026-09-04

### Changed
- Owner decision (option B of three). A citation keeps a derivative and its
  original only when it stands in a **live** document: a scope document, a
  workspace specification, or a plan carrying neither `Shipped:` nor
  `Abandoned:`. A shipped or abandoned plan is history, like a session log —
  its knowledge has dissolved into the Body (`scope-grammar.md` §6), so from
  then on a Body claim or an Open finding must cite the document or the pair
  is removed at the next closeout. The plan's own text and its blob citations
  are untouched; `git show <blob>` still reads a removed derivative.
  `check`'s unreferenced scan drops referencing files under `docs/plans/`
  whose first column matches `^(Shipped|Abandoned):`. Rules in
  `docs/README.md`; amendment in `docs/workspace/document-layer.md` §15.

### Fixed
- `check` no longer dies with "d: unbound variable" under bash 3.2: a `case`
  pattern's `)` closes the enclosing `$( … )` in that version, which the
  document layer commits to supporting. The plan filter uses a
  `${d#docs/plans/}` prefix test instead. Caught by the sandbox before the
  real script was touched.

## [Derivatives nothing cites are removed with their originals at closeout] — 2026-09-04

### Changed
- Owner instruction, completing the orphan rule of the same day: a
  derivative under `docs/<scope>/sources/` is needed only while a document
  under `docs/` outside `sources/` cites it by its full file name (session
  logs do not count); one nothing cites any more is removed at closeout
  together with its original — `git rm` and `rm` — by agents and human
  maintainers alike. `check` lists each such derivative with both commands
  and a count, beside the orphan-original notice; it still never fails on
  either. Git keeps the text; cited blobs still resolve with `git show`.
  Supersedes "the old derivative stays" and "removal of a derivative is a
  human commit". Rules in AGENTS.md and docs/README.md; trees in README.md;
  amendment in `docs/workspace/document-layer.md` §15. First application on
  an organization's branch: 13 screenshots whose findings were promoted into
  claims that cite the code and a prototype's template instead.

## [Orphan originals under docs/assets/ are removed at closeout] — 2026-09-04

### Changed
- Owner instruction. An original under `docs/assets/<scope>/[<repo>/]` is in
  use only while its derivative exists under `docs/<scope>/sources/`; one
  whose derivative was removed or re-filed is an orphan and is deleted at the
  next closeout, by agents and human maintainers alike. `ingest` still never
  overwrites or renames an original, and nobody edits one. `check` now lists
  each orphan with `rm` as the remedy (`extract` only for a file meant to be
  ingested) and prints a count; it still never fails on store-side state.
  Why: the fold of two repo-named scopes into their product's left duplicate
  copies under the old folders with no rule allowing their removal, and a
  `check` message that told the reader to extract them. Rules in AGENTS.md,
  trees in docs/README.md and README.md; amendment in
  `docs/workspace/document-layer.md` §15.

## [OCR reads Traditional Chinese: recognition languages default to zh-Hant,en-US; marker-only OCR is no-text] — 2026-09-04

### Fixed
- `extract`'s embedded Vision program never set `recognitionLanguages`, so it
  ran at Vision's default `en-US` and every Traditional-Chinese document
  extracted to mojibake — measured on a real screenshot: 3 junk lines before,
  33 correct lines (141 Han characters) after. The default is now
  `zh-Hant,en-US`; `OCR_LANGS=<bcp47,…>` on `ingest`/`extract` overrides it
  per call (an unsupported tag falls back to `en-US` inside Vision, it does
  not fail). `docs/workspace.md` finding 23.
- A derivative whose OCR produced nothing was stamped `status: ok` because the
  `<!-- page N (ocr) -->` marker alone made the body non-empty; markers
  (page/slide/sheet) no longer count, so an empty extraction is `no-text`.
  Amendment in `docs/workspace/document-layer.md` §15.

## [Scope documents are maintained state: no Changes sections, no struck findings] — 2026-09-04

### Changed
- Owner decision. `docs/<scope>.md` has two parts — Body and Open findings —
  and both are rewritten in place whenever a session finds them stale: a
  promoted or refuted finding is deleted (a refutation that proved a positive
  fact becomes a Body claim), finding ids are never reused, the deleting
  session fixes live references, and pruning is part of every closeout that
  touches a scope document. `git log -- docs/<scope>.md` is a document's
  history, the scope's session logs its journey, this file the workspace's own
  release history — the one ledger left; each scope document carries a
  `History:` line under its title saying so. Why: three ledgers wrote every
  event, every rebase conflicted at each ledger's anchor, and readers paid for
  struck and stale text on every session start; git already keeps every prior
  version. Rules in `docs/README.md` and `AGENTS.md`; amendments in
  `docs/workspace/scope-grammar.md` §14 and `document-layer.md` §15;
  `BLUEPRINT.md` §4 loses the `archive.md` row and §5 records the rejection.

### Removed
- `docs/workspace.md` › Changes (10 entries, each mirrored here or in a
  session log); its findings 14–17 and 22 rewritten to what remains open.
  Each organization's scope documents follow on its own branch.

## [Documents may sit one folder below a scope, named for the fleet repo they are evidence about] — 2026-09-04

### Added
- `REPO=<manifest id> ./workspace.sh ingest <scope> <file>…` files documents
  under `docs/assets/<scope>/<repo>/` and `docs/<scope>/sources/<repo>/`, where
  `<repo>` is the id lowercased with `_` → `-` (`MY_API` → `my-api`).
  `extract` accepts either level; `check` derives the scope from the path,
  refuses a second level or a folder that is not a manifest id, and pins each
  `source:` header exactly. The citation form gains the optional folder:
  `docs/<scope>/sources/[<repo>/]<name>.<ext>.md@<blob>`. Owner decision: the
  owner organises evidence by which repository produced it (the prototype's
  rendering of a dialog beside the new UI's rendering of the same dialog), and
  with scope as the only axis the outlet was a repo-named scope (three in
  two days), which fragments a product's findings. Scope stays
  the product; the folder is the manifest's vocabulary applied to where
  evidence sits. Rules and trees in AGENTS.md, docs/README.md, README.md and
  BLUEPRINT.md; amendments in `docs/workspace/document-layer.md` §15 and
  `docs/workspace/scope-grammar.md` §14. Verified by 26 sandbox cases.

### Fixed
- `extract` keeps an existing derivative's `received:` line when re-run
  without `RECEIVED=`; a bare re-extract used to drop it, changing the blob
  for a reason unrelated to the text. Found by the sandbox test above.

## [Originals copied into gitignored docs/assets/, text under docs/<scope>/sources/] — 2026-09-03

### Changed
- No external store and no `originals` symlink any more. `workspace.sh ingest`
  copies a document to `docs/assets/<scope>/<YYYY-MM-DD-slug.ext>` — gitignored,
  never committed — and `extract` writes its text to
  `docs/<scope>/sources/<name>.md`, beside the scope's own documents. Citation
  form: `docs/<scope>/sources/<name>.<ext>.md@<blob>`. `check` validates each
  pair by size and hash when the original is present and fails if anything
  under `docs/assets/` is tracked; `ingest` refuses to run unless
  `docs/assets/` is ignored. Root-level `sources/` and `originals/` are gone;
  `assets` is a reserved id. Owner decision: the symlinked store added a manual
  mount step for no benefit once originals are simply copied into the
  repository directory. Amendment in `docs/workspace/document-layer.md` §15.

## [No tombstone documents: a scope id change is a recorded rename] — 2026-09-03

### Changed
- `docs/README.md` › Scopes: when the owner names a scope that an existing
  document covers, the document is renamed with `git mv` — with its topic
  folder and its plans — and records one `[Renamed from scope <old>]`
  Changes entry; no superseded file stays behind. Ids are stable handles that
  change only by owner decision. Cause: the first rename left a repo-named
  scope document as a tombstone the owner did not want. Amendment in
  `docs/workspace/scope-grammar.md` §14.

## [Agents may ingest documents; workspace specifications leave docs/plans/] — 2026-09-03

### Added
- `workspace.sh ingest <scope> <file>…`: copies a document from anywhere into
  the store as `originals/<scope>/YYYY-MM-DD-<slug>.<ext>`, mounting
  `originals -> ~/Documents/workspace-originals` (or `$WORKSPACE_STORE`) when
  absent, then runs `extract`. `NAME=` names one file and is required for a
  non-ASCII title (the slug rule silently drops non-Latin words); `DATE=` dates
  a default name; a leading or trailing date in the title is taken as the
  document's own. The store is only ever added to: identical bytes are reused,
  different bytes under an existing name are refused, and a file `extract`
  refuses (credential, oversize) is removed from the store again. Derivatives
  gain a `received: <as-received name>` header line.

### Changed
- AGENTS.md: the store joins the agent write surface through `ingest` only;
  existing originals are still never touched. Owner decision: the human-only
  store blocked the first real ingest (docs/workspace.md finding 23) and
  contradicted the workspace's purpose of autonomous agent work.
- The two founding plans are now specifications at
  `docs/workspace/document-layer.md` and `docs/workspace/scope-grammar.md`;
  `docs/plans/` is reserved for plans that authorize child-repo work, and a
  workspace design change is adopted by owner instruction and recorded here.

## [Document layer: text in sources/, originals in a store] — 2026-09-03

### Added
- `sources/<scope>/<name>.<ext>.md`: one tracked UTF-8 text derivative per
  human-supplied document, written by `workspace.sh extract` (textutil,
  PDFKit, Vision OCR, a python3 OOXML reader) with a header carrying the
  original's sha256; originals live in an external document store mirrored at
  gitignored `originals/`. Cited as `sources/…@<blob>` (`git hash-object`),
  re-examined with `git show <blob>`.
- The pre-commit hook refuses staged binaries and blobs over 1 MiB; `check`
  validates derivatives (header, size, ignore-match, scope path) and warns
  when a stored original drifted; `extract` refuses credential-shaped text;
  `restore` skips document tokens and locators on a pasted citation line.

### Changed
- AGENTS.md: write surface, red lines and evidence rules cover documents;
  read-only git in this repo is sanctioned; logs are "written by the agent".
  `.gitignore` patterns anchored (`/projects/`, `/originals`,
  `/.agents/scratch/`), `.DS_Store` added.
- Owner decision, not a §4 trigger: documents were the first input class with
  no home. Plan: `docs/plans/workspace--document-layer.md`.

## [Scope grammar for docs/] — 2026-09-03

### Changed
- A scope is a product or a cross-cutting system a human names; ids are
  lowercase kebab and immutable; an optional `scope:` on a manifest entry
  names a repo's home scope (default: the repo id) and `check` validates it.
- Plans live at `docs/plans/<scope>--<feature>.md` with `Scope:`/`Scopes:` and
  appended `Signed:`/`Shipped:`/`Abandoned:` lines; session logs are
  `YYYY-MM-DD-{agent}-{scope}--{task}.md`. The two founding plans and the
  first session log were renamed to this grammar in the same commit.
- A split moves examined Body topics to `docs/<scope>/<topic>.md`; the root
  document never moves. New §4 rows: aliases / scope table, findings archive,
  `check` extension. Plan: `docs/plans/workspace--docs-scope-grammar.md`.

## [Reabsorb fleet coherence and reproduction as cite/restore] — 2026-09-01

### Added
- `workspace.sh cite` prints the whole fleet as one coherent citation line;
  cross-repo findings paste it — the full line when the claim's dependency
  surface is uncertain.
- `workspace.sh restore` checks cited commits back out straight from a
  finding's `<repo>@<sha>` citations (a pasted line splits even as a single
  argument); bare `<repo>` returns a child to its manifest branch.

### Changed
- The standalone lockfile artifact stays deferred behind the audit trigger
  in `docs/BLUEPRINT.md` §4; §5 records the reasoning.

## [Simplify the records system] — 2026-09-01

### Changed
- Session logs are simple journals: task, decisions & pitfalls, TODO — the
  separate `tasks/` directory is gone, and findings no longer live in logs.
- Findings moved into the docs system: each `docs/<scope>.md` now has an
  Open-findings intake and an examined body, separated by the examination bar
  in `docs/README.md`. All records and documentation are agent-written.
- Snapshot/lockfile machinery removed; evidence is anchored per finding with
  `<repo>@<sha>` citations. `workspace.sh` slims to `setup | clone | check`.
- Disposable working artifacts live in gitignored `.agents/scratch/`.
