# 2026-10-20 | claude | rea | ui-validation-result-deduction

## Task
Owner's updated mock-up of the 檢核結果 tab (`04 · 批次完整性 × 判定追蹤.html`, with screenshots):
continue binghan60's first version — four-key required scope, 批次進度, 核減率, 核減代碼／中文名稱 in the
list, and 核減原因 + 申報欄位比對 sections in the drawer. The 檢核結果 buttons stay as they are.

## Done
- Mock-up ingested as `rea-ui/sources/2026-10-20-validation-result-design.html.md@6b3e7652` (textutil
  keeps the visible text only; the demo script — `deductionByCode`, the `hospType` arg — is in the
  gitignored asset). Screenshots not ingested: the HTML is the whole spec.
- Diffed the mock-up against `REA_UI@4909dc7` (`develop` = `origin/develop`, clean): plan
  ui-validation-result-deduction drafted, three commits, three open items. validation-result ›
  Provenance now points at the ingested mock-up. No write to the child: the plan is unsigned.
- Kernel facts: `ClaimResult` still has no `ErrorCode` / field evidence (`REA_kernel@2704043
  ClaimResult.cs:76-159`); 201 → `CD9` only in `docs/codes/201-translator.md:56`; code labels are
  `_201.cs:11` 限制申報科別 and `_401.cs:11` 門住診限制; no `ApplType` label source anywhere.

## Decisions & pitfalls
- 檢核結果 buttons: owner's word this session — order and default (全部, ruled 2026-10-19) unchanged,
  although the mock-up selects 失敗 and orders 失敗 / 全部 / 正確.
- 醫事類別 options: the plan uses the kernel-consistent `mock/rulesData.js:1660-1680` values (住診 has
  `20` / `29`, the mock-up's `23` is the designer's); a real screen would call `PBA/011|012|013`.
- `HospId` exact match and `ORDER_CODE` default 全部 are open items, defaults stated.
- Index at 101 wrapped lines again after `plan new`: the new entry must be ASCII-short (the link
  alone is 75 columns). Plan at 73 of 80 wrapped lines.

## TODO
- Owner: rule the three open items, sign; ship three commits on `develop`.
- Index line for ui-202-employment-type still says "draft" (shipped; another task's line).
