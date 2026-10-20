# rea — ui-202-employment-type: 202's 專兼任 radio and the 專任查核對象 it reveals

Status: shipped
Writes: REA_UI (develop)
Signed: gotop1711 — 2026-10-20
Amended: 2026-10-20 — 專任查核對象 `sortOptions` width (sub-group object form), 320 by the owner
Shipped: 2026-10-20 — REA_UI@514f817, @f959c2a, @19cfc98, @4909dc7 (develop, unpushed)

## Goal
The owner's mock-up (`docs/rea/rea-ui/sources/2026-10-20-202-main-setting-design.png.md@5d93e7c5c656`,
its picture `….p1.jpg@cf39fcf638e3`) reshapes 202's 主設定: the radio 執行醫師 becomes **專兼任** —
不限 / 限專任 — and a sortable **專任查核對象** (執行醫師 / 處方醫師, both by default) appears only under
限專任. A 主設定 field's id, options and `Default` are the kernel's: the map is looked up *by* the served
id, an unmatched key is inert (rule-editor › Field names — what `REA_UI@6b8cdca` fixed when the kernel
last renamed this field), and an undeclared `Main` key 400s (`SchemaExistenceValidator.cs:79-82`).
**The kernel side is landed, on a branch.** `REA_kernel@480e69e` (Kenny Chen, 2026-10-20, on
`origin/demo-feature-RuleSetTranslator-202`, one commit over `origin/demo@8c7cc03`, not on `develop`)
rewrites `_202.cs:22-48`: `DoctorRole` → `EmploymentType` 任職類型, `String`, `Any` 不限 / `FullTime`
專任, `Default "Any"`, `Required`; new `FullTimeDoctorTypes` 專任醫師角色, `StringArray`, `01` 執行醫師 /
`02` 處方醫師, `Default` both, `Required`, `VisibleWhen = { EmploymentType, FullTime }` — the values the
owner ruled on 2026-10-20: the kernel's `DoctorTypes` vocabulary (`_202.cs:72-73`).
Its validator skips a hidden field (`Validation/FieldRuleValidator.cs:76-81`, since `1b0ecaf`), so a
rule saved under 不限 needs no `FullTimeDoctorTypes`. The same commit reshapes 202's references —
參考日期 `ApplyDate` → `FuncDate`, order 醫令執行起日 / 治療結束日 / 就醫日期, five
`Disabled`, `Default` those three; 醫師角色 `Default` `01`,`02`; 醫事機構代號欄位 drops `TRAN_INSPECT_HOSP_ID`,
order 實際服務 / 醫事機構 — and un-flags 僅機械手臂 for 202 (`_202.cs:52-87`, `:800-803`); the ui
renders served options as served (ReferenceSetting greys `Disabled`), so those follow by themselves,
but a 202 row stored with `DoctorRole`, `ApplyDate` or `TRAN_INSPECT_HOSP_ID` 400s on its next save
(rule-editor › RuleSet → editor). No 202 translator yet. On the ui side the gate
is `linkedOptions` / `subGroups` — the ui ignores `VisibleWhen` (rule-schema-api) — but only a
**dropdown** opens a linked row (`REA_UI@3ad7356 src/views/rules/MainSetting.vue:648`); the payload
whitelist (`ruleSchemaUtils.js:235-242`) and the read view (`RuleShows.vue:326`, `:391`) already treat
radio and dropdown alike; `el-form` validates only rendered items, so a hidden required field does
not block a save (inferred).

**Labels come from the kernel.** `480e69e` says 任職類型 / 不限 / 專任 and 專任醫師角色; the owner asked
the kernel team on 2026-10-20 to adopt the mock-up's 專兼任 / 不限 / 限專任 and 專任查核對象. The ui adds
no label override (the map can relabel only a sub-group input, `ruleUIConfig.ts:50-64`); it renders
what is served, so the words land with the kernel's next commit, not with this plan.

## Writes
`REA_UI (develop)`. `REA_kernel` is read-only here: `480e69e` must reach the deployment (merge, build)
before steps 2–4 can be verified; before that the new map keys are inert and the old ones dead.

## Steps
1. Owner → kernel team (asked 2026-10-20): the mock-up's labels; when the branch lands on `develop`
   and the host; what becomes of stored 202 rows (`DoctorRole` / `ApplyDate` / 轉(代)檢).
2. `ruleUIConfig.ts` 202: `inputs { specialistCodes: 'checkbox', employmentType: 'radio' }`,
   `linkedOptions { employmentType: { FullTime: 'fullTimeCheck' } }`, `subGroups { fullTimeCheck:
   { inputs: { fullTimeDoctorTypes: 'sortOptions' } } }`; `doctorRole` out; served labels as served.
3. `MainSetting.vue:648` — `buildLinkedInputIdsMap` accepts `radio` as well as `dropdown`, so a radio
   opens its linked row in both the `layout.rows` and the column path (`:768-813`); a test pins it.
4. `mock/rulesData.js` 202 mirrors `480e69e` whole (the two fields, `default`, `visibleWhen`, the
   reshaped references, `robotic` enabled); tests: `ruleSchemaUtils.test.js:71-93` re-keyed to
   `employmentType`, `collectMainPayloadFields` drops `fullTimeDoctorTypes` under `Any` and keeps it
   under `FullTime`, a `RuleShows` case for the labels. `npx vitest run`, `npm run lint` clean; one
   commit per step 2–4.

## Done when
Against a deployment serving `480e69e`'s schema: 202's 主設定 shows 專科醫師別, then the radio with 不限
chosen by default, and 專任查核對象 (①執行醫師 ②處方醫師, reorderable) only while 限專任 is chosen; saving
under 不限 sends no `FullTimeDoctorTypes`; the saved rule reads back with the kernel's labels; 參考日期
offers 醫令執行起日 / 治療結束日 / 就醫日期 with five greyed. Offline the same. Every test passes.
