# 2026-09-24 | claude | rea | payload-rule-end-date

## Task
Owner: the 產出規則 changes one value — `form.ruleEndDate` is 9999-12-31, not 2910-12-31. Re-ingest
it and carry the change through the project, the documents and the plans.

## Done
- `REA_PROTO_DATA_CREATOR@949e7c4`: `RULE_END_DATE` in `src/collect.js`. 12 026 bodies rebuilt, every
  one carrying 2026-01-01 / 9999-12-31, every file `validate` clean.
- Re-ingested as `sources/2026-09-24-data-creation-payload-item-rules.txt.md@926b9e0fc1f3`, replacing
  the 09-23 copy; setup plan amended and shipped; the other documents follow.

## Decisions & pitfalls
- Two facts wore the same string until today: `RULE_END_DATE` (the body's `form.ruleEndDate`) and
  `OPEN_END_DATE` (the `LMT_E_DATE` that marks a 資料表檔's row in force). They were both 2910-12-31
  and are now different; `collect.js` and the repository doc say so, so nobody "fixes" one to match
  the other.
- The value changes nothing on the host — `Save` and `SaveWork` store 9999-12-31 whatever the body
  says (`RuleService.cs:339`, `:413`) — but the body no longer reads as a second sentinel.
- The 2026-09-23 log is at its 40-line cap, so today's work has its own; same session, new day.
- **I clobbered another session's work.** Two sessions ran against this branch on 2026-09-23
  (`0582dcc`, `1267126`): they recorded the owner's own acceptance run and profiled `MHCT_PAYLTYPE`.
  My next turn rewrote the acceptance plan and the repository doc with `cat >` from what I remembered,
  not from disk, and dropped it. Restored today from `git show <sha>:<path>`, merged with what came
  after. Rewrite a document whole only from its current text; targeted edits otherwise.

## Restored
- The owner's 2026-09-23 run (01023C accepted by both endpoints) and its caveat; the handoff of the
  validation job to whoever has declaration rows; the 暫緩 list (remote, README wording); the
  `MHCT_PAYLTYPE` profile, narrowed to the 14 limit types still unmapped.
- New with it: a body for 01023C is now refused, since the fixed start date 2026-01-01 is earlier
  than the 2026-10-01 the host already holds for it.

## TODO
- Owner: the acceptance plan, steps 1–7; its `Signed:` before 303–307 / 401 are written.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).
