# 2026-10-20 | claude | rea | ui-202-employment-type

## Task
Owner's mock-up for 202's 主設定: rename the 執行醫師 radio to 專兼任 (`employmentType`, `Any` 不限 /
`FullTime` 限專任) and add 專任查核對象 (`fullTimeDoctorTypes`, `sortOptions`, 執行醫師 / 處方醫師) shown
only under 限專任; the two option values to be discussed after reading `REA_UI`.

## Done
- Ingested the mock-up (`docs/rea/rea-ui/sources/2026-10-20-202-main-setting-design.png.*`).
- Plan ui-202-employment-type (draft): the kernel serves the field (`_202.cs:23-28`, live 2026-10-08),
  the map is keyed by served id, an undeclared `Main` key 400s — so a kernel request first, then
  map + mock + tests; the kernel's `VisibleWhen` is the gate its validator already honours.
- rule-editor › Schema → form: `buildLinkedInputIdsMap` opens a linked row for `dropdown` only
  (`MainSetting.vue:648`); payload whitelist and read view already treat radio alike.
- Values recommended `01` / `02` (the kernel's `DoctorTypes` vocabulary, the prototype's back end
  switched on it); owner ruled: those, `Default` `Any`, keep `sortOptions`.
- Kernel fetched: `develop` → `2704043` (CI only). `REA_kernel@480e69e` (Kenny Chen, 2026-10-20,
  `origin/demo-feature-RuleSetTranslator-202`, not on `develop`) already lands `EmploymentType` /
  `FullTimeDoctorTypes` with exactly those values and `VisibleWhen`, plus 202's references reshaped
  (`FuncDate`, five `Disabled`, 轉(代)檢 dropped) and 僅機械手臂 enabled; no translator yet. Plan rewritten.

## Decisions & pitfalls
- `6b8cdca` (2026-08-31) is the precedent: when the kernel renamed `EmploymentType` → `DoctorRole`
  the ui's stale key silently fell back to a text input — the same would happen in reverse.
- No `VisibleWhen` reader in the ui (rule-schema-api ruling); widening the linked-row helper to
  `radio` is the small change, a reader the large one — the plan takes the small.
- Stored 202 rows carry `DoctorRole`; after the rename they 400 on re-save — put to the kernel team.
- Order in 專任查核對象 has no meaning in the prototype (roles OR'd); kept `sortOptions` as asked.

- Labels differ (kernel 任職類型 / 專任 / 專任醫師角色, mock-up 專兼任 / 限專任 / 專任查核對象); the map can
  relabel only a sub-group input, so the owner asked the kernel team to adopt the mock-up's words.

## TODO
- Owner: sign the plan; the kernel's label commit and the branch's landing on `develop` are awaited.
- Modules still cite `1706cb5`; `480e69e` enters field-map / rea-kernel when it reaches `develop`.
