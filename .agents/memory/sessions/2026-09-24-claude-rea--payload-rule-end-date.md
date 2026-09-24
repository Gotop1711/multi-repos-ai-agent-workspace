# 2026-09-24 | claude | rea | payload-rule-end-date

## Task
Owner: the 產出規則 changes one value — `form.ruleEndDate` is 9999-12-31, not 2910-12-31. Re-ingest
it and carry the change through the project, the documents and the plans.

## Done
- `REA_PROTO_DATA_CREATOR@949e7c4`: `RULE_END_DATE` in `src/collect.js`. 12 026 bodies rebuilt, every
  one carrying 2026-01-01 / 9999-12-31, every file `validate` clean.
- The document re-ingested as `sources/2026-09-24-data-creation-payload-item-rules.txt.md@926b9e0fc1f3`,
  replacing the 09-23 copy; setup plan amended and shipped; repository doc, acceptance plan step 1 and
  the index line follow.

## Decisions & pitfalls
- Two facts wore the same string until today: `RULE_END_DATE` (the body's `form.ruleEndDate`) and
  `OPEN_END_DATE` (the `LMT_E_DATE` that marks a 資料表檔's row in force). They were both 2910-12-31
  and are now different; `collect.js` and the repository doc say so, so nobody "fixes" one to match
  the other.
- The value still changes nothing on the host: `Save` and `SaveWork` store 9999-12-31 whatever the
  body says (`RuleService.cs:339`, `:413`). What it buys is that the body no longer contradicts what
  the back end stores, and no longer reads as a second sentinel.
- The 2026-09-23 log is at its 40-line cap, so today's work has its own; same session, new day.

## TODO
- Owner: the acceptance plan, steps 1–7; its `Signed:` before 303–307 / 401 are written.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).
