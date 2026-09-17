# rea — leaf-group-name: the leaf's `Name` is the group name, not the rule's

Status: signed
Writes: REA_UI (debug-api)
Signed: gotop1711 — 2026-09-17

## Goal
Saving a rule module with two or more groups succeeds, and a saved group name survives a page reload. Today the live kernel rejects the second group: `POST /api/v1/RuleSet` answers `400` with `{Code: "201", Path: "Logic", Message: "Code 201 下有重複的群組名稱，每個 Leaf 的 Name 必須唯一"}` (owner's browser, 2026-09-17). The two sides disagree about which field carries the group name — `REA_kernel` says the leaf's `Name` (on `develop` since `458e663`), `REA_UI` sends the rule code's display name there and puts the group name in a `GroupName` the kernel does not have (rule-editor › The leaf envelope). The kernel's definition is primary (terms), so the ui moves.

## Writes
`REA_UI (debug-api)`. Nothing in the kernel: the carrier already exists there.

## Steps
1. `moduleToLeafNode` (`src/utils/rule/ruleNodeUtils.js:205-212`) emits the group name as `name`, not `groupName`; drop the `groupName` key — the kernel discards it.
2. `addLeafMeta` (`:288-303`) stops stamping `name` from `nameByCode`: the leaf's `name` is now set upstream and must not be overwritten. `nameByCode` loses its only reader — drop it and the `rules[].name` it reads if nothing else wants it. (`logicToArrangement` takes the display name from `rulesList`, not from the leaf, so the read path is unaffected — `:395-415`.)
3. `RuleEditorDialog.vue` blocks a save that would 400: `groupNameRules` gains a per-code uniqueness validator beside its `required` (`:301-303`), and `normalizeGroupNames` (`:344-350`) keeps filling the default `群組N` so `Name` is never blank. Trim before comparing and before sending — the kernel's check is `IsNullOrWhiteSpace` plus an exact-string `Distinct()`.
4. `decomposeRuleNodeToEditorState` (`:539-546`) reads the group name from `leaf.name`, falling back to `leaf.groupName` for rules stored before this ships. The `groupNames` array that `buildRuleData` stashes in the store (`RuleEditorDialog.vue:538`, read at `:569-576`) then has a real source behind it and can go: `loadFromRuleSet` never sets it (`src/stores/ruleEditor.js:83-106`), which is why a reload loses the names today.
5. Tests: two groups of one code produce two leaves with distinct `name` and no `groupName`; a duplicate group name is caught in the dialog before the request; a leaf carrying only the legacy `groupName` still decomposes. `npx vitest run` and `npm run lint` clean.

## Done when
In the running editor against the live kernel, a 201 rule with two groups saves with `200`; reopening the dialog after a page reload shows the typed group names, not `群組1` / `群組2`; two groups given the same name are refused by the dialog with a message, not by a `400`. The engine rule names this makes the kernel derive (`Rule_201_<群組名>`) are **not** what its own result parser accepts — that is plan translated-rule-names, and it blocks nothing here: nothing executes the translated rules yet.
