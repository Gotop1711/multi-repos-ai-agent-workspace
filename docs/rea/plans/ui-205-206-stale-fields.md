# rea — ui-205-206-stale-fields: 205 and 206 in the ui carry only fields the kernel serves

Status: signed
Writes: REA_UI (develop)
Signed: gotop1711 — 2026-10-19

## Goal
`employmentType` (專任 / 不限專任) and a `doctorRole` main field for codes 205 and 206 survive in the
ui from the prototype-era schema, while the kernel dropped them: `EmploymentType` was a typed
property of the pre-RuleSet model (`REA_kernel` `UiRule.cs:69` before `1d449cc`, 2026-07-07), and
`de35a2f` (2026-09-03) rewrote 205 and 206 to one main field, `SpecialistCodes` (`String`, `1` /
`2`, required), plus a `DoctorTypes` reference field (`StringArray` 01/02/03, default all three) —
`REA_kernel@1706cb5 Codes/V1.0/_205.cs:12-58`, `_206.cs` identical. No file in the kernel names
`employmentType`; a `Main` key the schema lacks is refused with 「不允許的欄位」
(`Validation/SchemaExistenceValidator.cs:79-82`; ruleset-api). In `REA_UI@442ef39`:
- `src/utils/rule/ruleUIConfig.ts:128-132` and `:137-141` map `doctorRole` and `employmentType` to
  `radio` for 205 and 206; `applyUIMapToBlock` matches by served field id
  (`src/utils/rule/ruleSchemaUtils.js:111`), so both entries never fire — dead, not harmful.
- `mock/rulesData.js:1165-1173` and `:1203-1208` give the mock 205/206 a `doctorRole` (01/02/03)
  and an `employmentType` main field, and `:1174-1185`, `:1211-1222` a `referenceFields` with
  参考日期 only — so offline mode renders two inputs the deployment never shows and lacks the
  醫師角色 selector it does. The 202 comment at `ruleUIConfig.ts:111` and the test comment at
  `tests/unit/utils/rule/ruleSchemaUtils.test.js:61` are history, kept.
When this ships, the 205 and 206 UI-map entries and mock blocks say exactly what `_205.cs` /
`_206.cs` serve, and the owner's ruling (2026-10-19: remove) is on record.

Related: 205-main-fields (draft, written at `REA_kernel@62948dd`) asked the kernel to *add*
`EmploymentType` and fix `DoctorRole`; `de35a2f` answered three of its four points the
prototype's way and dropped the field instead. field-locking's 205/206 lock of `employmentType`
has no field left to lock. Both are reported here, not amended — the owner's call.

## Writes
`REA_UI (develop)`. Nothing in `REA_kernel`: the drop is its decision, shipped.

## Steps
1. `ruleUIConfig.ts` — 205 and 206 `inputs` become `{ specialistCodes: 'radio' }` (a `String` with
   `Options`, as 301's `genderCode` is overridden); `referenceInputs` unchanged (`doctorTypes:
   'sortOptions'` already there).
2. `mock/rulesData.js` — 205 and 206: drop `doctorRole` and `employmentType`; add the `doctorTypes`
   reference field (label 醫師角色, options 01 執行醫師 / 02 處方醫師 / 03 遠距, default all three)
   after `referenceDates`, mirroring `_205.cs:44-55`. Mock keys stay camelCase as the interceptor
   delivers them (rule-editor › Field names).
3. Tests — a `ruleSchemaUtils.test.js` case that 205's and 206's `specialistCodes` normalise to
   `radio` and that no `doctorRole` / `employmentType` input is produced from the mock; the
   ui-map-orphans guard (every map key names a mock `Value`) lands there if that plan ships first.
4. `npx vitest run` and `npm run lint` clean; one commit.

## Done when
Offline (`VITE_USE_MOCK=true`) and against the deployment, the 205 and 206 dialogs render the same
inputs: 專科醫師別 as a radio, 參考日期 and 醫師角色 as sort-options; no 專任 input anywhere.
`grep -rn employmentType src mock` returns only the two history comments. Every test passes.
