# 2026-10-27 | claude | workspace | index-cap

## Task
Owner, in session: raise the index cap. One organization's product index sat at exactly 100 wrapped
lines with eleven shipped plans awaiting `Verified:`, so each new plan cost a trim elsewhere.

## Done
- `CAP_INDEX` 100 → 120 (`workspace.sh:23`), AGENTS.md › Documents, one CHANGELOG line. `check` PASS.
- Not raised: the repository-doc cap (100) — a doc that brushed it was reflowed at 100 columns instead.

## Decisions & pitfalls
- 120, not more: the index is one line per module, repository and plan; the backlog that fills it is
  verification, which `plan done` retires — the cap should stay a nudge toward that, not disappear.

## TODO
- Organizations rebase onto `main` and run `check`.
