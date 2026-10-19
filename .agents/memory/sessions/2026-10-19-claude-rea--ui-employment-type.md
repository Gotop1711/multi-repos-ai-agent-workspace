# 2026-10-19 | claude | rea | ui-employment-type

## Task
Owner's question: where does `REA_UI` use the `employmentType` property, and is it a legacy key for
the RuleSchema / RuleSet POST APIs? Read-only; answered in chat. Owner updated the kernel checkout
mid-session (`REA_kernel` `develop` 692bdc0 → 1706cb5, five commits); re-checked against the new HEAD.

## Done
- `REA_UI@442ef39`: three files. `src/utils/rule/ruleUIConfig.ts:131,140` (205 and 206 `inputs` map
  it to `radio`; line 111 comments that 202's key became `doctorRole`), `mock/rulesData.js:1170,1207`
  (205/206 mock main field 專任 / 不限專任), `tests/unit/utils/rule/ruleSchemaUtils.test.js:61`
  (comment). Only consumer of the map: `ruleSchemaUtils.js:111`, keyed by the live schema's fields.
- `REA_kernel@1706cb5`: no `employmentType` anywhere. History: `EmploymentType` was a typed property
  of `POCO/V1/UiRule.cs:69` (`SpecificConfig`, since init `e4d767a`); `1d449cc` (2026-07-07, RuleSet
  CRUD) deleted `UiRule.cs` for `Rules/RuleSet.cs` whose `RuleNode.Main` is a free
  `Dictionary<string, JsonElement>` checked against the served schema. `de35a2f` (2026-09-03) rewrote
  205/206 main fields to `SpecialistCodes` (+ `DoctorTypes` reference); `_202.cs` keeps `DoctorRole`
  with Executor / FullTime. `SchemaExistenceValidator.cs:79-82` 400s an undeclared `Main` key
  (「不允許的欄位」) — already recorded in ruleset-api.

## Decisions & pitfalls
- Nothing written to the modules: the answer is a code location plus history the modules already
  hold (ruleset-api › validator). On the owner's "sure", plan ui-205-206-stale-fields (draft):
  drop the dead 205/206 map entries and mock fields, mock gains `doctorTypes`. Not folded into
  ui-map-orphans (it excludes 205/206 by name) nor 205-main-fields (it asks the kernel to *add*
  the field — stale since `de35a2f`; reported in the new plan, not amended).
- The kernel moved to `1706cb5` (204 translator, condition fields, RelDate/TherSDate/AssayDate
  removed, Age 基準日 06–08 disabled, CI notify). Modules cite `458e663`…`692bdc0`; not resynced here.

## TODO
- Owner: sign ui-205-206-stale-fields; rule on 205-main-fields and field-locking's 205/206 lock
  (both predate `de35a2f` — abandon, or re-aim).
- Resync session for `REA_kernel@1706cb5`: field-map (dropped date fields, Age options), rule-editor
  (204 translator), scope-conditions (`667734c`), ruleset-api (`1b0ecaf` VisibleWhen).
