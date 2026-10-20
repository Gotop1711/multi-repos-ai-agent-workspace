# rea — ui-202-employment-type: 202's 專兼任 radio and the 專任查核對象 it reveals

Status: draft

## Goal
The owner's mock-up (`docs/rea/rea-ui/sources/2026-10-20-202-main-setting-design.png.md@5d93e7c5c656`,
its picture `….p1.jpg@cf39fcf638e3`)
reshapes 202's 主設定: the radio 執行醫師 (`Executor` 執行醫師 / `FullTime` 專任) becomes **專兼任** —
`Any` 不限 / `FullTime` 限專任 — under the id `EmploymentType`, and a new sortable field
**專任查核對象** (`FullTimeDoctorTypes`, two options 執行醫師 / 處方醫師, both selected by default)
appears only while 限專任 is chosen. Nothing in the ui can deliver that alone: a 主設定 field's id, label,
options and `Default` are the kernel's (`REA_kernel@1706cb5 …/Codes/V1.0/_202.cs:23-28`, served live on
2026-10-08, `docs/rea/rea-kernel/sources/2026-10-08-ruleschema-live.json.md@476fba76c157`), the UI map
is looked up *by* the served id and an unmatched key is inert (rule-editor › Field names — the very
thing `REA_UI@6b8cdca` fixed when the kernel last renamed this field), and a `Main` key the schema
does not declare is a 400 (`SchemaExistenceValidator.cs:79-82`). So this is a kernel request first
and a ui change second. The kernel already has the gate: `RuleFieldDescriptor.VisibleWhen`
(`Descriptor/RuleFieldDescriptor.cs:75`), honoured by its validator since `1b0ecaf` — a hidden field
is not validated at all (`Validation/FieldRuleValidator.cs:76-81`). The ui ignores `VisibleWhen` and
gates with `linkedOptions` / `subGroups` (rule-schema-api › VisibleWhen), but only a **dropdown** opens
a linked row (`REA_UI@3ad7356 src/views/rules/MainSetting.vue:648`); a radio never does, while the
read view (`RuleShows.vue:326`, `:391`) and the payload whitelist (`collectMainPayloadFields`,
`ruleSchemaUtils.js:235-242`) already treat radio and dropdown alike. When this ships, the dialog
renders the mock-up from the served schema, a rule saved with 不限 carries no `FullTimeDoctorTypes`
key, one saved with 限專任 carries the chosen roles in order, and offline mode shows the same.

**Open — the option values of `FullTimeDoctorTypes`** (the owner decides before signing):
- (A, recommended) `01` 執行醫師 / `02` 處方醫師 — the kernel's own `DoctorTypes` vocabulary in
  202, 205 and 206 (`_202.cs:54-55`), the prototype's (`REA_PROTO@3fdf47c
  tests/mock/api/rulesSpecificSetting.json:3240-3258`), and what the prototype's back end switched on
  to build 執行專任 / 處方專任 (`REA_PROTO_BE@ba161ff Services/Rules/SpecialistRuleGenerator.cs:63-86`:
  doctorType `01` + 專任 → 執行專任, `02` + 專任 → 處方專任). The new field names *which of those roles*
  must be full-time, so it is a subset of that list and should spell it the same way.
- (B) `Executor` / `Prescriber` — self-describing like `Any` / `FullTime`, but a second vocabulary for
  the same two roles, and `Executor` is the value being retired from `DoctorRole`.
Also open: `EmploymentType`'s `Default` — the prototype defaulted to 專任 (`…:3568-3581`); the mock-up
shows 限專任 chosen; the kernel's `DoctorRole` has none.

## Writes
`REA_UI (develop)`. `REA_kernel` is read-only here: step 1 is a request to its team, and steps 2–4
land only once the schema serves the new shape (the map keys would be inert before that).

## Steps
1. Kernel request (`_202.cs`): `DoctorRole` → `EmploymentType` 專兼任, `String`, options `Any` 不限 /
   `FullTime` 限專任; new `FullTimeDoctorTypes` 專任查核對象, `StringArray`, options per the ruling,
   `Default` both, `VisibleWhen = { Field = "EmploymentType", Value = "FullTime" }`. Ask too what
   happens to 202 rows stored with `DoctorRole` — they 400 on their next save as an undeclared key
   (rule-editor › Form → `Main`); none translates today (translator: 201, 203, 204 only).
2. `ruleUIConfig.ts` 202: `inputs { specialistCodes: 'checkbox', employmentType: 'radio' }`,
   `linkedOptions { employmentType: { FullTime: 'fullTimeCheck' } }`,
   `subGroups { fullTimeCheck: { inputs: { fullTimeDoctorTypes: 'sortOptions' } } }`; `doctorRole` out.
3. `MainSetting.vue:648` — `buildLinkedInputIdsMap` accepts `radio` as well as `dropdown`, so a radio
   opens its linked row in both the `layout.rows` and the column path (`:768-813`); a test pins it.
4. `mock/rulesData.js` 202 mirrors step 1 (field, options, `default`, `visibleWhen`); tests:
   `ruleSchemaUtils.test.js:71-93` re-keyed to `employmentType`, a case that `collectMainPayloadFields`
   drops `fullTimeDoctorTypes` under `Any` and keeps it under `FullTime`, a `RuleShows` case for the
   two labels. `npx vitest run`, `npm run lint` clean; one commit per step 2–4.

## Done when
Against a deployment serving the new schema: 202's 主設定 shows 專科醫師別, then 專兼任 with 不限 / 限專任,
and 專任查核對象 (①執行醫師 ②處方醫師, reorderable) only while 限專任 is chosen; saving under 不限 sends no
`FullTimeDoctorTypes`; the saved rule reads back with the same labels. Offline the same. Every test
passes.
