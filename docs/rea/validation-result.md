# rea / validation-result

The 檢核結果 tab of `REA_UI`: a screen that shows, per 醫令, what the kernel's validation job decided.
It runs on four built-in demo rows today, because no kernel endpoint returns a result yet. Cited at
`REA_UI@442ef39` (`develop`, paths under `src/`) and `REA_kernel@692bdc0` (paths under `src/Model/`).

## Provenance
- Written by binghan60 on `origin/feature-ValidationResult` (`caadcfd` init, `7aa9400` feat, merged
  onto `develop` by livia.chen as `63a1f57`, a merge the owner did not push); the owner squashed that
  tree onto `bdd28ec` as `ae5a379` (2026-10-19), identical except the layout's aside comment restored
  to its original wording and the test's `ValidationResult` mock dropped (`git diff 7264c61 ae5a379`).
  The demo data's header says the screen follows a design sketch 「批次完整性 × 判定追蹤」
  (`views/validationResult/validationResultDemoData.js:2`); that sketch is not in the workspace.

## What the screen is
- The fifth `el-tab-pane` of the frame, label 檢核結果, name `validationResult`, rendering
  `views/ValidationResult.vue` (`layouts/DefaultLayout.vue:43-49,81`). Every heading carries a
  示意資料 label and the empty table says 示意 (`ValidationResult.vue:7-9,136,337`).
- Scope form: 費用年月 (`FEE_YM`, a month picker), 院所代號 (`HOSP_ID`, substring match), 醫令代號
  (`ORDER_CODE`, a select over `['51018C', '09001C']` plus 全部醫令) (`ValidationResult.vue:33-72`);
  defaults `2025-12`, `0401180014`, all (`validationResultDemoData.js:80-86`). 查詢 copies the draft
  into the applied scope, 清除 empties both and resets the mode (`ValidationResult.vue:572-584`).
- Result mode: a radio group 全部 → 失敗 → 正確 over `OrderCodeResult` (`All`/`Fail`/`Pass`,
  `utils/validationResult/claimResult.js:7-18`). Default is 全部; the code says the sketch wants 失敗
  (`ValidationResult.vue:456-458`) — ruling (owner, 2026-10-19): it stays 全部.
- Statistics, computed on the applied scope regardless of mode (`ValidationResult.vue:467-481`):
  ValidationJob counts per status in `ValidationJobStatusEnum` order with labels 待處理 / 執行中 / 完成 /
  工作失敗 / 已放棄 (`claimResult.js:22-34`, names from `api/modules/validationJob/index.ts:19`);
  `ClaimResult` counts for `Pass`, `Fail`, `NoRule`, `Skipped`; pass and fail rates over `Pass + Fail`
  only (`claimResult.js:83-99`). The job counts are demo constants, zeroed when the scope holds no
  rows (`validationResultDemoData.js:63-71`, `ValidationResult.vue:472-477`); a banner says the
  figures are provisional while jobs run (`ValidationResult.vue:197-198`).
- List: an `el-table` of the scoped rows filtered by mode and sorted by `SeqNo` (toggle), page sizes
  2 and 10, caption 顯示 a–b 筆，共 N 筆 (`ValidationResult.vue:450,484-506`); clicking a row opens
  the detail, clicking the same row again closes it, switching to a mode that excludes the selected
  row closes it (`ValidationResult.vue:535-570`). 匯出 downloads the filtered rows as
  `ClaimResult_filtered_demo.json` (`:586-590`).
- Detail: a page-local `<el-drawer>` (44%, `result-drawer`) titled 醫令判定明細 with 複製 JSON and
  下載單筆 (`ClaimResult_<SeqNo>_<OrderSeqNo>.json`) in its header (`ValidationResult.vue:381-415,
  552-561`), body `views/validationResult/ResultDetailPanel.vue`: identity fields (`HOSP_ID` …
  `ORDER_SEQ_NO`, a `Job ID` prefix of eight characters), the rule path — one card per `Code`, failed
  codes first, all expanded, each group with `Result`, `Skipped`, `MainResult` — the version fields
  (`LogicExpression`, 規則生效日, `Schema`, `Translator`, 未記錄 when null) and the raw JSON
  (`ResultDetailPanel.vue:126-173`, `claimResult.js:104-128`). The drawer is deliberately not the
  frame's: the comment at `ValidationResult.vue:379-380` keeps page-only state in the page (rea-ui ›
  Layout has the owner's matching ruling).
- Helpers: `helpers/file.js` — `downloadJson` (Blob + anchor) and `copyText` (Clipboard API, falls
  back to `execCommand`), domain-free (`file.js:1-30`); `views/validationResult/ResultOutcomeTag.vue`
  renders a result as a coloured tag (`bi` icons — `bootstrap-icons`, `package.json:22`); colours are
  a scoped `@mixin result-tokens` in `views/validationResult/resultTheme.scss`, no global CSS.
- Tests: `tests/unit/views/validationResult/{ValidationResult,ResultDetailPanel}.test.js`,
  `tests/unit/utils/validationResult/claimResult.test.js`, `tests/unit/helpers/file.test.js` — mode
  order and default, scope defaults, statistics against the demo rows, paging, drawer open/close
  rules, copy/download, export (not run in the workspace; the names are the evidence).

## The shape it assumes, against the kernel
- The demo rows are the kernel's `ClaimResult` field for field, PascalCase kept on purpose
  (`validationResultDemoData.js:1-28,30-61`): `Id` `{JobId}_{SeqNo}_{OrderSeqNo}`, `JobId`,
  `CreatedAt`, `HospId`, `HospDataType`, `FeeYm`, `ApplType`, `ApplDate`, `CaseType`, `SeqNo`,
  `OrderSeqNo`, `OrderCode`, `Result` (`POCO/V1/Jobs/ClaimResult.cs:7-74`); `Result` =
  `ClaimResultDetail` — `OrderCodeResult`, `LogicExpression` (e.g. `401&&201`, null on NoRule),
  `VersionEffectiveDate`, `SchemaVersion`, `TranslatorVersion`, `Codes[]` (`:76-109`); a code —
  `Code`, `Result`, `Groups[]` (`:114-131`); a group — `GroupName`, `Result` (`Skipped` when
  skipped), `Skipped`, `MainResult` (null when skipped) (`:136-159`). Results are the strings
  `Pass` / `Fail` / `NoRule` / `Skipped` (`POCO/V1/Enums/ResultEnum.cs:8-30`, string-serialised).
- Dates: the demo's `FeeYm` is `2025-12-01` and `ApplDate` `2026-01-13`, shown as `YYYY/MM` and the
  first ten characters (`claimResult.js:57-60`); the kernel's are `DateTime` (`ClaimResult.cs:38,48`),
  so a real response's `T00:00:00` suffix would pass through those two formatters unchanged.
- When a real endpoint exists the ui's axios boundary will camelCase the response (rea-ui › Folders),
  and the demo header says the field access in `utils/validationResult/` changes with it
  (`validationResultDemoData.js:3`).

## Not wired
- No controller returns `ClaimResult` rows (validation-job-api › Read); the tab reads
  `demoClaimResults` only (`ValidationResult.vue:442-448,468`). The page's own note: `ClaimResult`
  gives 醫令 / Code / Group verdicts, no field-level error reason and no input claim JSON
  (`ValidationResult.vue:375-377`).
- `demoRuleCodeNames` (201 申報科別, 401 門住診) names the rule-path cards
  (`validationResultDemoData.js:74-77`); a real screen would take names from the schema (rule-codes).
