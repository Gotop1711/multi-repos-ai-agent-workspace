# rea — 306-main-setting

Status: draft

## Goal
306 需同時併報項目 has no `mainSettingUIMap` entry, so its 主設定 falls through to the schema defaults and three of its five defects block data entry outright (rule-codes; `docs/rea/rea-ui/sources/2026-09-16-306-main-settings.jpg.md@247f52504336` against the prototype's three options, `docs/rea/rea-proto/sources/2026-09-16-306-main-settings-001.jpg.md@dd15c9f942ec`, `-002…@731a41ed8b64`, `-003…@b38ec24986f8`). When this ships, 306 renders as 305 does: one 主診斷代碼類別 dropdown with one sub-row beneath it, and the save payload carries only the chosen mode's fields.

The five, against `REA_kernel@2ff26b0`'s 306 `MainFields` (`docs/rea/rea-kernel/sources/2026-09-11-ruleschema-live.json.md@548ac767c5d8` L18749-L18823) and `REA_UI@bdba317`:

1. **`diagnosisCategory` is a text box.** The kernel serves it `Type: "String"` with three `Options` and `Required`; `getSchemaFieldType` (`src/utils/rule/ruleSchemaUtils.js:47-52`) maps every `String` to `text` and only a UI-map `inputs` entry makes a dropdown (305 does this at `src/utils/rule/ruleUIConfig.ts:289-294`). The mode cannot be chosen — it is typed.
2. **All six fields show at once.** The prototype shows the 類別 dropdown plus exactly one sub-row (`REA_PROTO@3fdf47c tests/mock/api/rulesSpecificSetting.json:6505-6671`, blocks `range` / `code` / `prefix`).
3. **The whole set is saved.** `collectMainPayloadFields` whitelists top-level inputs plus the *selected* sub-groups; with no `subGroups`, every 306 field stays top-level and every one of them is sent, mode or not (`ruleSchemaUtils.js:229-262`).
4. **`diagnosisCodes` is an empty dropdown.** `StringArray` defaults to `multiSelect`, and the field serves no options, so the shown control cannot take a code; the prototype uses `textAdd` (`:6630-6645`), as 305 does for `bodyPartCodes`.
5. **Server labels and sentence text both render.** Rows read `主診斷代碼前幾碼前 [ ] 碼`, `主診斷代碼結束值- [結束值]`, `主診斷代碼開頭值輸入開頭 [請輸入字首]` — the served `Label` next to the served `PrefixText` / `SuffixText`. The prototype hides the label and lets the sentence carry it (`label: ""`).

Also in scope, same cause: 參考日期 renders as a plain `multiSelect`, losing the ①② ordering every other code gets from `referenceInputs: { referenceDates: 'sortOptions' }`.

## Writes
`REA_UI` — one entry in `src/utils/rule/ruleUIConfig.ts` and its test. No kernel change: the schema already serves everything the entry needs. No prototype change (read-only).

## Steps
1. `'306'` in `mainSettingUIMap`, modelled on `'305'` (`ruleUIConfig.ts:279-337`):
   - `layout.rows`: one row, `['diagnosisCategory']`; `inputs: { diagnosisCategory: 'dropdown' }`; `inputWidths: { diagnosisCategory: 200 }`.
   - `linkedOptions.diagnosisCategory` **keyed on the kernel's values**: `'01' → diagnosisCode`, `'02' → diagnosisPrefix`, `'03' → diagnosisRange` (see the pitfall below).
   - `subGroups`, sentences from the prototype's blocks, all with `label: ''`:
     `diagnosisCode` → `diagnosisCodes: { type: 'textAdd', label: '', prefixText: '代碼輸入', placeholder: '請輸入一組代碼' }`;
     `diagnosisPrefix` → `diagnosisPrefixLen: PREFIX_LEN`, `diagnosisPrefix: { type: 'text', label: '', prefixText: '輸入開頭' }`;
     `diagnosisRange` → `diagnosisPrefixLen: PREFIX_LEN`, `diagnosisRangeStart: { type: 'text', label: '', prefixText: '輸入範圍' }`, `diagnosisRangeEnd: { type: 'text', label: '' }`.
     `PREFIX_LEN` is the existing shared const (`ruleUIConfig.ts:66`) — `前 [ ] 碼，`; 306 shares one `diagnosisPrefixLen` between its 開頭 and 開頭範圍 groups exactly as 305 does.
   - `referenceInputs: { referenceDates: 'sortOptions' }`, `referenceWidths: { referenceDates: 450 }`.
2. A test beside 305's: for each of `01` / `02` / `03`, the rendered rows are the 類別 dropdown plus that mode's sub-row only, and `collectMainPayloadFields` returns the top-level field plus that mode's fields and nothing from the other two.
3. `npx vitest run` and `npm run lint` (`max-len` 100 — the subGroups lines in 305 sit right at it).

## Pitfalls
- ⛔ **The 01/02/03 values mean different things on the two sides.** The kernel's `01 代碼 / 02 開頭 / 03 開頭範圍` is what the deployment serves and, the kernel's definition being primary (terms), what a stored value means; the prototype's `1-開頭範圍 / 2-代碼 / 3-開頭` is presentation. `linkedOptions` keys the **served** value, so a group id copied straight off the prototype's `linkedBlockId` order would wire every mode to the wrong sub-row and store the wrong meaning. The option *labels* are the kernel's too: no `1-`/`2-`/`3-` numbering.
- The prototype types its 前幾碼 field `text` where the kernel serves `Number` with `Min 0`; `PREFIX_LEN` is `number`, which keeps the served constraint. Taking the prototype's `text` instead would drop it.
- `DiagnosisRangeEnd` carries `CompareField >= DiagnosisRangeStart` — the same shape 305's `bodyPartRangeEnd` has; the sub-group override must not drop the served constraints (it overrides type and sentence only).

## Done when
The owner opens 306 in the running editor and sees, for each 類別: the dropdown plus that mode's sub-row alone, reading as the prototype's sentence; codes entered by typing and Enter; 參考日期 numbered ①②; and a saved 306 rule whose `Main` carries only the chosen mode's fields.
