# Workspace CHANGELOG

Append-only: never rewrite past entries.
Format: `## [description] — YYYY-MM-DD` + `### Added / Changed / Fixed`.

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
  change only by owner decision. Cause: the first rename left `docs/nabu-ui.md`
  as a tombstone the owner did not want. Amendment in
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
