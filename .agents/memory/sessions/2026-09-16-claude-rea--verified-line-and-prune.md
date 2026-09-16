# 2026-09-16 | claude | rea | verified-line-and-prune

## Task
Owner: the mechanism for recording a human's verification of a shipped plan, and for removing stale sources/assets, were not intuitive. Proposals for `main` (adopted the same day: `Verified: <name>` as the final, human-written line; `prune`).

## Done
- Explained the state: one signature (`Signed:`), no verification line, removal keyed on citations.
- Filed the two proposals; the owner adopted them on `main` and rewrote the four plans' lines.

## Decisions & pitfalls
- The human writes `Verified:`; an agent-written "confirmed in session" line never carries the reviewer's own hand — that was the missing feeling.
- `shipped` had meant both "landed" and "done"; `verified` as the final word fixed it.
- Removal stays keyed on citation, not on approval; what was missing was seeing *why* a file is kept — `prune` shows the keepers.
- Three revisions in one day (`Closed:` state and `close` command added, then withdrawn; history reset to the clean point): each removed a line, the direction held.

## TODO
- none carried; superseded by the v2 migration.
