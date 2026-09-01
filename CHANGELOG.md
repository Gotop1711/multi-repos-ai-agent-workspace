# Workspace CHANGELOG

Append-only: never rewrite past entries.
Format: `## [description] — YYYY-MM-DD` + `### Added / Changed / Fixed`.

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
