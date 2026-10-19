# rea — ui-scope-option-flags: 檢核範圍 honours the kernel's option flags, and the mock says what the kernel serves

Status: draft

## Goal
Since `REA_kernel@667734c` (2026-10-13) and `4b889a8` (2026-10-19) the schema flags *options* inside
檢核範圍 conditions: 診療之部位 類別 `04` 群組 (`Codes/V1.0/_101.cs:449` at `1706cb5`) and 年齡 基準日
`06`/`07`/`08` (`:540-542`), in every code; its translator refuses both (`Translator/V1.1/
RuleSetTranslator.Condition.cs:458`, `:363-373`), and a refused rule is stored with `TranslatedRules`
null, which the ETL will not run (translator). The ui at `REA_UI@3ad7356` greys a flagged option only
where `SortOptionsInput` or `ReferenceSetting` renders it (`src/components/rules/SortOptionsInput.vue:30`,
`src/views/rules/ReferenceSetting.vue:36`, `:84`) — so 基準日 is right — but the scope dropdown and
multi-select `el-option`s bind no `disabled` (`src/views/rules/ScopeSetting.vue:300-305`, `:331-339`),
so 類別 `04` 群組 is pickable and saves. Separately, the mock still describes the 2026-09-17 deployment:
201 alone flags nine conditions and no code flags `Robotic` (`mock/rulesData.js:5-8`, `:1038`), 主次診斷
has two 比對欄位 not 22 (`:152`), 基準日 `06`–`08` and 類別 `04` carry no `disabled` (`:211`, `:240`),
and no condition has `PrefixLen` (02 開頭); the tests pin the old shape
(`tests/unit/utils/rule/ruleSchemaUtils.test.js:461-470`). When this ships, a flagged option in any
檢核範圍 input is greyed and unpickable, a stored flagged value fails the form as a disabled condition
does today (rule-editor › Disabled conditions), and offline mode renders what `_101.cs` serves.

## Writes
`REA_UI (develop)`. Nothing in `REA_kernel`.

## Steps
1. `ScopeSetting.vue` — `:disabled="option.disabled === true"` on both `el-option` loops; a stored
   value that is now flagged gets the same `error` treatment as a disabled condition (`:236`, `:462`).
2. `mock/rulesData.js` — `DISABLED_CONDITIONS_201` becomes a `robotic`-only flag applied to every
   code; 主次診斷 `filterOptions` the 22 served (`_101.cs:226-258`); `disabled: true` on 類別 `04` and
   基準日 `06`–`08`; `prefixLen` (`Number`, min 1, `visibleWhen` 類別 `02`) in the four code-type
   conditions, mirroring `_101.cs:287`, `:377`, `:471`, `:681`.
3. Tests — `disabledOf('201')` and `disabledOf('101')` both `['robotic']`; a dialog case that a
   flagged option renders disabled in a scope dropdown; `prefixLen` renders in 02 mode.
4. `npx vitest run` and `npm run lint` clean; two commits — the binding, then the mock.

## Done when
Against the deployment (once it runs `1706cb5` or later): in any code's 檢核範圍, 診療之部位 → 類別 shows
群組 greyed; 年齡 → 基準日 shows 調劑日期, 物理治療起日, 檢驗日期 greyed; 欄位 lists 僅機械手臂輔助手術 greyed in
every code. Offline, the same. `grep -c "disabled: true" mock/rulesData.js` reflects the four flags.
Every test passes.
