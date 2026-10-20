# 2026-10-20 | claude | rea | ui-202-employment-type

## Task
Owner's mock-up for 202's 主設定: 執行醫師 radio → 專兼任 (`employmentType`, `Any` / `FullTime`) and a new
專任查核對象 (`fullTimeDoctorTypes`, `sortOptions`, 執行醫師 / 處方醫師) shown only under 限專任; option
values to be discussed after reading `REA_UI`. Then, on the owner's word: rulings, signing, shipping.

## Done
- Mock-up ingested (`docs/rea/rea-ui/sources/2026-10-20-202-main-setting-design.png.*`); plan
  ui-202-employment-type: the field is the kernel's (map keyed by served id; undeclared `Main` 400s).
- Kernel fetched: `develop` → `2704043` (CI only). `REA_kernel@480e69e` (Kenny Chen, 2026-10-20,
  `origin/demo-feature-RuleSetTranslator-202`, not on `develop`) already lands `EmploymentType` /
  `FullTimeDoctorTypes` with `01` / `02`, `Default Any`, `VisibleWhen`; 202's references reshaped
  (`FuncDate`, five `Disabled`, 轉(代)檢 dropped), 僅機械手臂 enabled; no translator yet.
- Owner ruled: `01` / `02`, `Default` `Any`, keep `sortOptions`; asked the kernel team for the
  mock-up's labels (the map relabels only a sub-group input). Signed in the IDE.
- Shipped `REA_UI@514f817` (a radio opens a linked row, `MainSetting.vue:648`) and `@f959c2a`
  (202 map, mock mirroring `480e69e`, tests); owner's `19cfc98` (width 320), `4909dc7` (comment),
  replayed over them with the test re-pinned to 320. 55 files / 1167 tests, lint clean.

## Decisions & pitfalls
- No `VisibleWhen` reader in the ui (rule-schema-api ruling): widening the linked-row helper to
  `radio` is the small change; the map expresses the kernel's gate.
- Steps 2 and 4 share a commit — the map without the mock breaks the 202 test at that commit.
- `RuleShows.test.js` has its own `mockRuleSchema`: import the dev mock under another name.
- A sub-group input's width is the object form in `subGroups`; `inputWidths` is top-level only.
- `git cherry-pick` has no `-q`; a statement after a failed `&&` chain still runs — it amended
  `f959c2a` into an identical twin `007a928` (reflog only). Rebuilt on `f959c2a` to keep citations.
- Stored 202 rows carry `DoctorRole` / `ApplyDate` / 轉(代)檢 → 400 on re-save; put to the kernel team.

## TODO
- Owner: verify against a host serving `480e69e` (or offline), then `Verified:`; push `develop`, `rea`.
- Kernel: the label commit; the branch onto `develop`; stored 202 rows. Modules cite `480e69e`
  only from the plan until it reaches `develop`.
