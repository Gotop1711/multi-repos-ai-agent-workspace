# rea — disabled-conditions

Status: shipped
Writes: REA_UI (debug-ui)
Signed: <name> — 2026-09-17
Shipped: 2026-09-17 — REA_UI@392230e (debug-ui, unpushed)

## Goal
The kernel marks a 檢核範圍 condition `Disabled` when its translator does not exist yet: "顯示於 UI 但
不可選" (`REA_kernel@458e663 POCO/V1/Descriptor/ConditionDescriptor.cs:23-26`, added `de35a2f`). Only
201 sets it, on nine of its thirteen conditions — every condition but `CaseType`, `HospCode`,
`OrderType` and `Department`, which are exactly the four the translator implements; saving any other
one throws, and the API answers 500 (rea-kernel › Save translates). The deployment of 2026-09-17
serves the same nine (`docs/rea/rea-kernel/sources/2026-09-17-ruleschema-live.json.md@ecc4c965567f`
L6404-L7425). `REA_UI@411c809` (`debug-ui`) drops the flag before the 欄位 select sees it, so all
thirteen are selectable and nine of them end in a 500 at save (rule-editor › Disabled conditions).

When this ships, a disabled condition is listed but greyed out and cannot be picked, and a stored
rule that already holds one shows the row with a field error and refuses to save until it is
removed or changed — the error arrives before the request, not as a 500.

## Decisions (2–4 are defaults — change them before signing)
1. **Branch** `debug-ui` — the owner's choice, 2026-09-17.
2. **A stored disabled condition blocks save.** Its row still renders with its values, so the user
   sees what is stored; the 欄位 item fails validation with 「此條件尚未開放，請移除或改選其他條件」.
   Letting it through would only move the failure to the kernel's 500.
3. **Presentation is Element Plus's own disabled option** — the kernel's label unchanged, no suffix.
4. **Out of scope:** the add-on board (`src/views/addOn/AddOnBoard.vue:870-874`) reads 101's
   conditions, which carry no flag; the read view `RuleShows.vue` only prints what is stored.

## Writes
`REA_UI` — `src/utils/rule/ruleSchemaUtils.js`, `src/views/rules/ScopeSetting.vue`,
`src/api/modules/rules/types.ts`, `mock/rulesData.js`, and their tests. No kernel change: the
schema already serves the flag. No prototype change: its `disabled` locks an input inside a
condition, not a condition (plan field-locking).

## Steps
One commit.
1. Carry the flag: `buildScopeFieldConfig` sets `disabled: block.disabled === true`
   (`ruleSchemaUtils.js:284-298`); `fieldOptions` keeps it (`ScopeSetting.vue:1000-1014`);
   `ConditionDescriptor` gains `disabled?: boolean` (`types.ts:89-93`).
2. Grey the option in both 欄位 selects: `:disabled="field.disabled"` on the `el-option`
   (`ScopeSetting.vue:246-251`, `:470-475`).
3. Count only enabled options where the component asks whether anything can be added —
   `canAddConditions` and the four 加入 buttons and the empty-state click (`:36-83`, `:1381`).
4. Refuse a disabled field in `getFormRules`' `field` rule (`:1543-1552`); `validate()` (`:1637`)
   already stops `handleSave` on a failed form.
5. `mock/rulesData.js`: 201's `conditions` flag the same nine, so `VITE_USE_MOCK=true` matches the
   deployment.
6. Tests: `tests/unit/utils/rule/ruleSchemaUtils.test.js` (the flag survives
   `buildScopeFieldConfig`); `tests/unit/views/rules/ScopeSetting.test.js` (the option is disabled,
   add counts enabled only, a stored disabled field fails validation). `npx vitest run`,
   `npm run lint`.

## Done when
- In the 201 dialog against the live kernel, 檢核範圍's 欄位 list shows thirteen conditions, nine
  greyed and unclickable; 案件分類 / 醫事類別 / 醫令類別 / 就醫科別 pick and save as before — with one
  group: a second is rejected until the kernel carries `GroupName` (rule-editor › The leaf envelope).
- Every other code's list is unchanged: nothing greyed.
- A 201 rule holding, say, 層級別 opens with that row shown and flagged, and 儲存 is refused without a
  request; after removing the row it saves.
