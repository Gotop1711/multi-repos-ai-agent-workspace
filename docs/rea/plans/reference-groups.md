# rea — reference-groups: the ui speaks the kernel's new `Reference` shape and its `Disabled` options

Status: draft

## Goal
On 2026-09-29 the kernel changed a leaf's `Reference` from `ReferenceItem[]` — rows of
`{ Params: { <field>: [values] }, Condition? }` — to `Dictionary<string, List<ReferenceGroup>>`:
the key a served `ReferenceFields[].Value`, the value an ordered list of `{ Fields: string[],
Condition? }` where groups are tried top-down, the last may omit `Condition` as the default, and
`Fields` is a left-to-right fallback chain (`REA_kernel@6540a4c POCO/V1/Rules/RuleSet.cs:130-135`,
`:179-192`, `851bbb3`; ruleset-api › `Reference`). GET serves the same shape. `REA_UI@a024004`
still encodes the old rows, default row first (`src/utils/rule/ruleNodeUtils.js:163-190`), and
decodes only rows with `params` (`:481-515`), so against the deployed kernel a save of any of the
seventeen codes with 參考日期 cannot bind (a 400, inferred) and a loaded rule shows the schema
`Default` instead of its stored groups. When this ships the dialog round-trips the dictionary: the
groups in the order the user set them, the default group last, each chip list as `Fields`.

Second deliverable, same dialog (the owner's word, 2026-09-30): 203 now serves five
`ReferenceDates` options with `Disabled: true` (`Codes/V1.0/_203.cs:32-36`); the 參考日期
`el-option` binds no `disabled` (`src/views/rules/ReferenceSetting.vue:20-37`, `:68-84`), so they
are selectable, pass the kernel's option check, and fail its translator. When this ships a flagged
option shows greyed and cannot be picked, in the default select and in every group's select alike;
a stored value that is now flagged still loads (the kernel admits it) but the form marks it so the
user replaces it before saving.

## Writes
`REA_UI (develop)`. Nothing in `REA_kernel`: the shape is its decision, already shipped.

## Steps
1. Encoder — `pickReferenceRowsFromSetting` returns an object: for each field with values,
   `[key]: [ ...groups.map(g => ({ fields: g.values, condition: g.scopeCondition })),
   { fields: defaultValues } ]`; omit the default group when `defaultValues` is empty; omit the
   key when nothing remains (`moduleToLeafNode` then sends no `reference`). Keys pascalize at the
   axios boundary as `Main`'s do (rule-editor › Field names).
2. Decoder — `referenceToSetting` takes the object: per key, a group with a `condition` becomes a
   `groups[]` entry (`scopeMode` `exclude` when its `op` is `Not`, as today), the trailing group
   without one becomes `defaultValues`; ignore a non-object as today's `toArray` ignores a non-array.
3. `ReferenceItem` in `src/api/modules/rules/types.ts:11-14` becomes `ReferenceGroup`
   `{ fields: string[]; condition?: Condition | null }` and `RuleNode.reference` a
   `Record<string, ReferenceGroup[]>`; `mock/rulesData.js` rows and `RuleShows.vue`'s read view
   follow.
4. Tests — rewrite `tests/unit/utils/rule/ruleNodeUtils.test.js:86`, `:91` and every fixture with
   `params`; add a round-trip case (two conditioned groups + default → encode → decode → same) and a
   case that a group without a condition is emitted last.
5. `:disabled="option.disabled"` on both 參考日期 `el-option`s; a stored value whose option is now
   flagged fails the group's form rule with a message naming the option, so `handleSave` stops
   before the request as it does for a disabled 檢核範圍 condition (rule-editor › Disabled
   conditions). A test that a flagged option cannot be selected and a flagged stored value blocks.
6. `npx vitest run` and `npm run lint` clean; two commits — the shape, then the flag.

## Done when
A rule with two conditioned 參考日期 groups and a default saves to the deployed kernel without a 400,
reloads with the same groups in the same order, and `GET /api/v1/RuleSet` shows the leaf's
`Reference.ReferenceDates` as three groups, the last without `Condition`. In 203's dialog the five
flagged dates are greyed and unpickable. Every test passes.
