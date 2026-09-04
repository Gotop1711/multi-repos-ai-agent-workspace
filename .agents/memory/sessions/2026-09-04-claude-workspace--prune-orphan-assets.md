# Session Log — 2026-09-04 | claude | workspace

## Task
Owner: the rules should tell agents and human maintainers to remove asset
files under `docs/assets/` that are no longer in use. Infrastructure →
`main`, then rebase `rea`.

## Completed
1. Definition and duty: an original is in use while its derivative exists
   under `docs/<scope>/sources/`; otherwise it is an orphan, removed at the
   next closeout by whoever sees it. `AGENTS.md` › write surface (the one
   removal anyone makes there); trees in `docs/README.md` and `README.md`;
   `document-layer.md` §15 amendment; CHANGELOG entry.
2. `workspace.sh check` — one `warn:` per orphan naming `rm` as the remedy
   (`extract` only for a file meant to be ingested) and a count line;
   still never fails on store-side state. Sandbox-tested with two orphans
   (one at a scope root, one in a repo folder): both listed, count 2, gone
   after `rm`.

## Decisions & pitfalls        ← the valuable part
- **"In use" is defined by the tracked tree, not by citations.** A
  derivative may be uncited and still in use; an original whose derivative
  is gone is not, whatever cited it — the blob still resolves from git. This
  keeps the test mechanical (`[ -f docs/<scope>/sources/<rel>.md ]`) and
  makes today's fold the canonical case: the re-ingested copies under
  `rea/` had derivatives, the old `rea-proto/` and `ui/` copies did not.
- **A notice, not an auto-delete.** `check` runs in the pre-commit hook;
  deleting files from a hook would be a surprise. The remedy is one `rm` the
  reader runs deliberately. A `prune` subcommand is a five-line addition if
  it ever bites.
- **`check` on `main` now warns about 13 orphans that are not orphans** —
  the `docs/assets/rea/` originals whose derivatives live on `rea` only.
  Expected on this branch model (gitignored assets are shared across
  branches; derivatives are not) and harmless; the notice says "before
  closing out", and a closeout on `main` never touches `docs/assets/rea/`.
  Worth remembering before "cleaning up" from `main`: check out `rea` first.
- The remedy text is built with a `sed` that turns `extract <scope>/<rest>`
  into `extract <scope> docs/assets/<scope>/<rest>` — verified on both a
  root-level and a repo-folder orphan.

## TODO / known-incomplete
- Rebase `rea` onto this commit (CHANGELOG conflict expected, main-first).
- Carried over: Open finding 8, `origin/nabu-dashboard`, SSH for github.com.
