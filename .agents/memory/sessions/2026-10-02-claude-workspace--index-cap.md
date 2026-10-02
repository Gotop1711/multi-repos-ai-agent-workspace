# 2026-10-02 | claude | workspace | index-cap

## Task
Owner, in session: raise a document cap where that is the better fix. The product index of one
organization sat at exactly 80 wrapped lines before a session that adds a plan.

## Done
- `CAP_INDEX` 80 → 100 (`workspace.sh:23`), AGENTS.md › Documents, one CHANGELOG line. `check` PASS.
- Not raised: the repository-doc cap (100) — the doc that brushed it lost one clause instead.

## Decisions & pitfalls
- The index is one line per module, repository and plan and cannot be split; every other cap can.
- `fold -w 100` counts characters, so a 101-character line costs two; prose reflowed at 98 passes.

## TODO
- Organizations rebase onto `main` and run `check`.
