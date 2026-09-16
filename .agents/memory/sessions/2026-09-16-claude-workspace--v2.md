# 2026-09-16 | claude | workspace | v2

## Task
Owner: the documentation — the workspace's own and each organization's — grows too verbose and too big. Keep today's `main` as branch `v1`; rewrite `main` under new rules: documents made and unmade by command, small by rule, task-oriented material removable in one command; layout `docs/<product>/index.md` + modules + `<repo>/` folders.

## Done
- `v1` branched at cdc97d9. `main` rewritten: `AGENTS.md` 58 lines, `README.md` 47, log template 13, manifest template with `product:`; `workspace.sh` gains `doc init|add|rm`, `plan new|done`, line caps in `check` (index 80 · module 150 · repo doc 100 · plan 80 · log 40, counted wrapped at 100 columns), the v2 paths for `ingest`/`extract`/`prune`; `clone`/`cite`/`restore` and the text/OCR pipeline unchanged.
- Retired to `v1`: CHANGELOG, `docs/README.md`, BLUEPRINT, `docs/workspace.md`, both specifications, twelve workspace logs. No findings tray, no changelog: a fact goes into its module, a defect or decision into `plan new`, history into `git log`.
- Sandbox (bash 3.2): doc init/add/rm, reserved names, plan new, ingest with and without REPO=, prune keepers, every cap, the v1-layout and stray-folder FAILs, plan done (plan + its log + the source only it cited removed, index unlinked), the party split.

## Decisions & pitfalls
- Caps are the lever, not prose asking for brevity: a file over its cap fails `check`. Counted wrapped at 100 columns (`fold`) — the first migration wrote paragraphs on single lines and showed a physical-line cap is trivially dodged.
- `docs/workspace/index.md` deliberately not created: `README.md` + `AGENTS.md` are the workspace's description, and a `docs/` exception would re-complicate the party split. Workspace defects travel as a `[workspace]` log line.
- `plan done` gates on `Status: verified|abandoned` only; whether the result is in the modules is judgment, done before running it.
- `grep -qxF "$link"` broke on a link starting with `- [` — options; `--` fixed it. The sandbox caught it.
- Kept `REPO=` as an env var for `ingest` so the OCR/ingest code stayed byte-identical apart from paths.
- This log was lost from the v2 commit (a heredoc in a long `&&` chain) and rewritten here — check's "newest session log: none yet" was the tell.

## TODO
- Owner: push `main` and `v1`; the organization's branch is migrated (its own log).
