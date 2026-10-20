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
- Values recommended: `01` / `02`, the kernel's `DoctorTypes` vocabulary that the prototype's back end
  switched on (`SpecialistRuleGenerator.cs:63-86`); `Executor` / `Prescriber` the alternative.

## Decisions & pitfalls
- `6b8cdca` (2026-08-31) is the precedent: when the kernel renamed `EmploymentType` → `DoctorRole`
  the ui's stale key silently fell back to a text input — the same would happen in reverse.
- No `VisibleWhen` reader in the ui (rule-schema-api ruling); widening the linked-row helper to
  `radio` is the small change, a reader the large one — the plan takes the small.
- Stored 202 rows carry `DoctorRole`; after the rename they 400 on re-save — put to the kernel team.
- Order in 專任查核對象 has no meaning in the prototype (roles OR'd); kept `sortOptions` as asked.

## TODO
- Owner: rule on the option values and `EmploymentType`'s `Default`; sign, or send step 1 to the
  kernel team first.
