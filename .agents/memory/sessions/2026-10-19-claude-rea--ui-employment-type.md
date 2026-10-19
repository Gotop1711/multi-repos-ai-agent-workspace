# 2026-10-19 | claude | rea | ui-employment-type

## Task
Owner's question: where does `REA_UI` use `employmentType`; is it a legacy key for the RuleSchema /
RuleSet POST APIs? Then, on the owner's word: plan ui-205-206-stale-fields (signed in session),
drop plans 205-main-fields and field-locking. Kernel checkout moved 692bdc0 → 1706cb5 mid-session.

## Done
- `REA_UI@442ef39`: `ruleUIConfig.ts:131,140` (205/206 map entries, never matched — the map is
  looked up by served id, `ruleSchemaUtils.js:111`), `mock/rulesData.js:1170,1207`, one test comment.
- `REA_kernel@1706cb5`: `EmploymentType` was a typed property of `UiRule.cs:69`, deleted by
  `1d449cc` (2026-07-07, RuleSet CRUD, `Main` a free dictionary checked against the schema);
  `de35a2f` (2026-09-03) rewrote 205/206 to `SpecialistCodes` + `DoctorTypes` reference; an
  undeclared `Main` key 400s (`SchemaExistenceValidator.cs:79-82`, already in ruleset-api).
- Shipped `REA_UI@3ad7356` (`develop`, unpushed): 205/206 `inputs` → `{ specialistCodes: 'radio' }`;
  mock 205/206 drop `doctorRole` + `employmentType`, gain `doctorTypes` (01/02/03, default all), 206
  `specialistCodes` → `String`; a test pins it. 55 files / 1164 tests, lint clean.
- `plan rm` 205-main-fields and field-locking (no sources of their own). References rewritten:
  field-map (seven orphans, line numbers −8), terms, rule-editor (two lines), rea-proto/index,
  ui-map-orphans, rea-ui › Branches. Owner verified in session; `plan done` — the modules hold it.

## Decisions & pitfalls
- 205-main-fields asked the kernel to *add* the field; `de35a2f` dropped it instead — hence the
  new plan rather than a reuse. ui-map-orphans excludes 205/206 by name, unchanged in scope.
- `plan rm` refuses while the previous removal is uncommitted: two removals = two commits.
- `Status:` must be lowercase `signed`; the pre-commit hook rejects `Signed`.
- Kernel resync to `1706cb5`: the owner's "do it now" — log kernel-1706cb5-resync.

## TODO
- Owner: push `develop` (`3ad7356`) and `rea`.
