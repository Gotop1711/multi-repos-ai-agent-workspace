# rea — ui-validation-result-deduction: 檢核結果 takes the four-key scope, 核減原因, 欄位比對

Status: draft

## Goal
The owner's updated mock-up of the 檢核結果 tab and its drawer
(`docs/rea/rea-ui/sources/2026-10-20-validation-result-design.html.md@6b3e7652`; the original, with
its demo script, in `docs/assets/rea/rea-ui/`) continues binghan60's first version at
`REA_UI@4909dc7` (validation-result). Four things change. (1) The scope form becomes the kernel's
`ClaimBatchKey` (validation-job-api): `HOSP_ID`, `FEE_YM` (labelled 申報年月／費用年月),
`HOSP_DATA_TYPE`, `APPL_TYPE` required and exact-match, `ORDER_CODE` optional (L18-66, L75).
(2) The overview shows 檢核中 / 已完成 only, Pass and Fail with a 核減率, and an exception line
for NoRule / Skipped (L85-109). (3) List and drawer show, per failed code, a 核減代碼 with its
name and a 申報欄位比對 row — a demo mapping, since `ClaimResult` carries no `ErrorCode` and no
field evidence (`REA_kernel@2704043 POCO/V1/Jobs/ClaimResult.cs:76-159`); the one example is
201 → `CD9` (`docs/codes/201-translator.md:56`). (4) Labels follow the mock-up (L16-17, L129-161).
Unchanged, on the owner's word: the 檢核結果 buttons — order 全部 → 失敗 → 正確, default 全部 —
and the ruling that the drawer is the page's own. Code names are the kernel's labels:
201 限制申報科別, 401 門住診限制 (`_201.cs:11`, `_401.cs:11`).

## Writes
`REA_UI (develop)`. Three commits.

## Steps
1. `feat(validation-result): the scope is the ClaimBatchKey` — `validationResultDemoData.js`:
   `DEFAULT_SCOPE` + `hospType: '11'`, `applType: '1'`; `demoHospDataTypes` (groups 門診 / 住診 /
   其他, the values and labels of `mock/rulesData.js:1660-1680`, the kernel's `PBA/011|012|013`);
   `demoApplTypes` (the mock-up's eight, L51-58; no kernel source); `demoRuleCodeNames` 201 →
   限制申報科別, 401 → 門住診限制. `claimResult.js`: `filterByScope` matches `HospId` (a substring
   today, `:70`), `HospDataType`, `ApplType` exactly; `formatHospDataType` / `formatApplType` →
   `11 · 門診西醫診所` / `1 · 送核`, the value alone when unknown. `ValidationResult.vue`: the
   three-column grid in the mock-up's order, `*` on the four required fields, 選填 on `ORDER_CODE`,
   `el-select` + `el-option-group` for 醫事類別 (disabled while `HOSP_ID` is empty, hint L29 area:
   請先輸入院所代號…), 查詢 refuses with 請填寫必要條件：… until the four are filled, 清除條件
   empties all five; footer and chips as L75-84; table columns `HOSP_DATA_TYPE` / `APPL_TYPE`
   formatted; subtitle L16. Tests: scope defaults, refusal, exact match, formatters.
2. `feat(validation-result): 批次進度, 核減率, exception line` — the overview as L85-109: left
   block 批次進度 with 檢核中 = `Pending + Processing`, 已完成 = `Done` (inferred from the demo
   counts, L91-95) and the note L96; right block 通過 Pass / 不通過 Fail, caption L104, rates
   L105 (不通過率 → 核減率), exception line L106; banner L108-109, still hidden at zero jobs.
   `JOB_STATUS_ITEMS` stays exported. Tests: statistics and zero-scope tests re-pinned.
3. `feat(validation-result): 核減代碼 in list and drawer; 申報欄位比對` —
   `validationResultDemoData.js`: `demoDeductionByCode = { 201: { code: 'CD9', name:
   '支付標準限制申報科別', field: '醫令段科別（OrderFuncType）', claimValue: '99', expected:
   'DeptCodes：11' } }` (the asset's script). `claimResult.js`: `buildDeduction(item, map)` → the
   first failed code's entry or null. List: 失敗 RuleCode → 不通過模組／RuleCode (pill `201
   限制申報科別`), new column 核減代碼／中文名稱 (`CD9` + name + a 示意 mapping tag; 待補模組對照
   when a failed code has no entry; — otherwise); table note L129; limitation note L134 reworded in
   the ui's own voice. Drawer: buttons 複製 ClaimResult / 下載單筆; meta 申報年月; identity
   `HOSP_DATA_TYPE`, `APPL_TYPE` formatted, `FEE_YM / 申報年月`; new section 核減原因 (L144-145: a
   card `CD9 · 201 限制申報科別`, 二代核減對照示意, the name; or 無適用規則 / 此筆醫令未核減 with the
   asset's sentences); new section 申報欄位比對 (L147-153, an empty row when no entry); 規則判定路徑
   hint 不通過模組優先, group headers 群組名稱 / 結果 / 略過 / 主設定, only the first card expanded;
   JSON head L158, description L159, closing note L161. `ResultDetailPanel` takes a `deduction`
   prop. 匯出 → 匯出核減案件 JSON: the scoped `Fail` rows whatever the mode,
   `DeductionClaims_filtered_demo.json`. Tests: column, sections, first-card expansion, export.
4. After each commit `npx vitest run`, `npm run lint` (`max-len` 100); `Shipped:` lines.

## Open — the owner rules at signing
- `ORDER_CODE` default: the mock-up selects `51018C` (L64, L82); the first version's test pins
  全部 (`ValidationResult.test.js:89`). Default: keep 全部.
- 住診 group: the mock-up lists `23 住診其他醫事機構` (L40); the kernel-consistent mock has `20`
  and `29`. Default: the mock's. A real screen loads `PBA/011|012|013` through `fetchOptionsByApi`
  (`stores/ruleEditor.js:167`) — out of scope until an endpoint serves `ClaimResult` rows.
- `HospId` exact match (the ClaimBatchKey identity; default) or keep the substring match.

## Done when
`npm run dev` with `VITE_USE_MOCK=true`: the tab renders the mock-up's form, overview, columns and
drawer sections on the four demo rows; 查詢 with an empty required field shows the error; the
檢核結果 buttons still read 全部 / 失敗 / 正確 with 全部 selected; row 4 shows `CD9` with its name in
the list and the three new drawer sections. Every test passes and lint is clean.
