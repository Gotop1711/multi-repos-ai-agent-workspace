# rea / ruleset-api

The `RuleSet` round trip: the row `GET /api/v1/RuleSet` returns, the `Reference` shape the kernel changed on 2026-09-29, what `REA_UI` reads of it, and what the dev store holds. Kernel cited at `REA_kernel@6540a4c` (`develop`, 2026-09-30) and at the swagger the deployment served that day (`docs/rea/rea-kernel/sources/2026-09-30-swagger.json.md@407d8f46c91a`, cited as `L<n>`); ui at `REA_UI@7bfff25` (`develop`, unpushed); a line marked `458e663`, `392230e` or `a024004` was read at that sha. The store as read by GET on 2026-09-17 — 1,731 rows / 1.77 MB into gitignored scratch, not captured; on 2026-09-30 the same host answers `[]` (The store). `:8080` (the kernel) and `:8081` (the ui's nginx, proxying `/api`) answer from one store.

## The row
- `Get()` is `IQueryable<RuleSet>` with OData Filter | OrderBy | Top | Skip only (`API/NHI.API.ClaimValidator/Controllers/V1/RuleSetApiController.cs:23-25`); `$select` is refused — the deployment answers "Query option 'Select' is not allowed" — so a client cannot trim a row. The model: `POCO/V1/Rules/RuleSet.cs:10-81`; `Logic` is a `RuleNode` tree (`:86-141`) of `Condition` (`:146-174`) and, since 2026-09-29, `ReferenceGroup` (`:179-192`; the section `Reference` below). The 2026-09-30 swagger matches the source key for key (`RuleSet` L2827, `RuleNode` L2731). Nulls are not serialized (`Program.cs:11`), so two rows differ in key set: `TranslatedRules`, `TranslatorVersion`, `RuleEndDate` appear only where set. **Three keys GET serves that POST never takes**, all filled by `RuleSetSL` on save from the `Logic` tree: `LogicExpression` — the root as text, e.g. `401&&201` (`a63ad16`, 2026-09-18; L2864) — and `Codes` / `Conditions`, the leaf codes and the condition `Field`s the tree uses, deduplicated (`851bbb3` 2026-09-29, `1b0e0ff` 2026-09-30; `Implementation/V1/RuleSetSL.cs:126-131`; L2835, L2843). `RuleSetParameter` takes `OrderCode`, `SchemaVersion`, `RuleStartDate`, `Logic`, `OtherNote` only (L2909); the ui names none of the three (`src/api/modules/rules/types.ts:28-40`).
- The ui loads one row per selection — `$filter=OrderCode eq '…'`, `$orderby=RuleStartDate desc`, `$top=1` (`src/api/modules/rules/index.ts:191-198`, `src/views/Payment.vue:772-774`) — the newest row whatever `ruleStartDate` the caller passed (`:768-774`), so a history row shows the newest rule set (read from source, not tried in the browser).

## What the ui reads
Share is the field's bytes over the store's 1,731 rows.

| Field | Read | Where, or what the ui does instead | Share |
|---|---|---|---|
| `OrderCode` | yes | the header, `src/views/Payment.vue:744-753` | 2.0% |
| `RuleStartDate` | yes | the header | 2.8% |
| `RuleEndDate` | yes | the header (set on 2 rows) | 0.0% |
| `Logic` | yes | `src/stores/ruleEditor.js:83-106`, `RuleEditSection.vue:366-372` | 66.3% |
| `OtherNote` | yes | per-code summaries, `ruleEditor.js:92-97` | 16.6% |
| `SchemaVersion` | **no** | a save sends the loaded schema's version (`ruleEditor.js:130`) | 2.1% |
| `TranslatedRules` | **no** | no reader, ui or kernel; 3 rows (all 201), 5–10× their `Logic` | 0.5% |
| `TranslatorVersion` | **no** | — | 0.0% |
| `CreatedAt` | **no** | — | 4.7% |
| `UpdatedAt` | **no** | the dialog shows the leaf's `UpdatedAt` (`RuleEditorDialog.vue:28`) | 4.7% |

The five unread fields — 12% together — are named only by `src/api/modules/rules/types.ts:28-40` and `mock/rulesData.js:1629-1632`. Inside `Logic`:

| Key | Read | Where |
|---|---|---|
| `Op` `Left` `Right` `Code` | yes | `src/utils/rule/ruleNodeUtils.js:361-433` |
| `Condition` and its five keys | yes | `:435-479`, `:541-542` |
| `Reference` | yes, the dictionary | `:488-526` (the section `Reference`) |
| `Main` | yes | `:544` |
| `UpdatedAt` (leaf) | 1 group only | 上次更新時間; the multi-group `Or` branch has none (`:374-391`) |
| `Name` (leaf) | **no** | a save overwrites it with the code's display name (`:288-303`) |

**Fully unread inside `Logic`: only the leaf `Name`.** Every other nested key has a reader in the load path; one of them, the leaf `UpdatedAt`, is read for single-group codes only.

- **Leaf `UpdatedAt`, single-group codes only.** `extractRuleNodesFromLogic` hands the store the highest node whose leaves are one code — for a multi-group code, the `Or` branch (`ruleNodeUtils.js:374-391`) — and `loadFromRuleSet` reads `updatedAt` off that node (`ruleEditor.js:103`); a branch carries none, so 上次更新時間 shows `-` for every multi-group rule. Verified 2026-09-17 by running the ui's own `extractRuleNodesFromLogic` / `decomposeRuleNodeToEditorState` (imports stubbed in scratch, no repo write) on two store rows:

| Row | Groups | Node handed to the store | `updatedAt` the store reads |
|---|---|---|---|
| `05151B` / 204 | 1 | the leaf | `2026-06-05T09:08:49+00:00` |
| `51018C` / 201 | 4 | the `Or` branch | `""` — the four leaves' timestamps go unread |

  A ui defect, not a field the kernel could drop: all leaves of one code carry the same value (`addLeafMeta`, `:288-303`), so the fix is to read the timestamp off a leaf — one line (plan ruleset-unread-fields › Found alongside).
- **`Name` is unread and overwritten.** The arrangement names a rule from the schema's code table (`:402`, `:411`); the group name is read from `groupName`, which the kernel carries since `a63ad16` (2026-09-18) and requires unique per code, `Name` being display-only there (rule-editor › The leaf envelope); a save stamps `name` with the code's display name.
- **Unread yet echoed.** A rule not opened in its dialog goes back as loaded (`ruleEditor.js:45`, `ruleNodeUtils.js:324-334`). 242 rows hold a `GroupName` key inside `Main` (a free dictionary on read) that no code declares and the ui never reads — the 2026-08-21 loader's mark (The store); `SchemaExistenceValidator` rejects an undeclared `Main` key (`Validation/SchemaExistenceValidator.cs:76-82`), so saving such an order code without re-saving that rule through its dialog (whose whitelist drops the key, rule-editor › Form → `Main`) should 400. Inferred from source; no save executed.
- **`OtherNote` outlives `Logic`.** `loadFromRuleSet` keeps a note only for a code that has a leaf (`ruleEditor.js:99-105`) and `buildRuleSet` rebuilds the string from `ruleData` alone (`:108-115`), so a note whose code has no leaf is invisible on load and gone on the next save — 743 stored rows carry such notes (The store).

## `Reference` — the shape the kernel changed on 2026-09-29

- **Old and new.** Until `851bbb3` a leaf's `Reference` was `ReferenceItem[]`: rows of `{ Params: { <field>: [values] }, Condition? }`, one row per value set, in no defined order (`RuleSet.cs:155-167` at `458e663`). Since `851bbb3` (2026-09-29, the 203 translator) it is `Dictionary<string, List<ReferenceGroup>>` — the key a served `ReferenceFields[].Value` (`ReferenceDates`, `HospCodes`, …), the value an ordered list of `ReferenceGroup { Fields: string[], Condition? }` (`RuleSet.cs:130-135`, `:179-192`; L2767, L2576). One `RuleNode` type is both `RuleSetParameter.Logic` and `RuleSet.Logic` (`Specification/V1/RuleSetParameter.cs:18`; L2909, L2827), so **GET returns exactly the shape POST takes** — a stored row comes back as the dictionary, PascalCase keys and all.
  ```
  "Reference": { "ReferenceDates": [
    { "Fields": ["FuncDate"], "Condition": { "Field": "CaseType", "Params": { … } } },
    { "Fields": ["ExecutionStartDate", "TreatmentEndDate"] } ] }
  ```
- **What it means** (the kernel's comments, `RuleSet.cs:131-134`, `:182-190`, and the one consumer, `Translator/V1.1/RuleSetTranslator._203.cs:83-136`): the groups under a key are tried top-down and the first whose `Condition` holds is used; the last group may omit `Condition` and is the default when none holds; inside the chosen group `Fields` is a fallback chain, left to right, the first field with a value — all empty, the claim fails, and no other group is tried. The old shape said nothing about order; the ui emits the default row *first* (`ruleNodeUtils.js:172-178`), which in the new shape is a structural error.
- **What the kernel checks on save**, in order. `StructureValidator`: a key's list non-empty, every group but the last carries a `Condition`, each `Condition` a valid tree (`Validation/StructureValidator.cs:79-121`). `SchemaExistenceValidator`: a code without `ReferenceFields` may carry no `Reference` at all (as before), each key must be one of its `ReferenceFields[].Value`「不允許的 Reference 欄位」, each `Condition`'s fields must exist (`:65`, `:128-159`). `FieldRuleValidator`: `Fields` non-empty and every entry among the descriptor's `Options` values「不允許的選項」(`Validation/FieldRuleValidator.cs:253-299`; `OptionsSet` is every option, `Disabled` ones included — `Descriptor/RuleFieldDescriptor.cs:32-35`). Only 203's translator reads it, and it accepts `ExecutionStartDate`, `TreatmentEndDate`, `FuncDate` alone (`_203.cs:127-136`); any other option is a `NotSupportedException`, which since `a63ad16` stores the row untranslated instead of answering 500 (rea-kernel › Save translates).
- **The ui at `a024004` still speaks the old shape, both ways.** Encoding: `pickReferenceRowsFromSetting` emits `{ params: { <key>: values }, condition }` rows, defaults first (`src/utils/rule/ruleNodeUtils.js:163-190`), for every code whose field has values — and seventeen codes serve `ReferenceDates` with a `Default`, so nearly every save carries one. A JSON array where the kernel binds a dictionary cannot deserialize: a 400 from model binding before any validator runs (inferred from the types; no save executed). Decoding: `referenceToSetting` expects rows with `params` and passes its input through `toArray`, which turns any non-array into `[]` (`:481-515`; `src/utils/common.js:1`) — a served dictionary yields no fields, the dialog falls back to the schema `Default`, and the stored groups are gone on the next save. The shape is pinned again by `ReferenceItem` (`src/api/modules/rules/types.ts:11-14`), by `mock/rulesData.js`, and by `tests/unit/utils/rule/ruleNodeUtils.test.js:86`, `:91`. **Shipped 2026-09-30, `REA_UI@82908a2`** (plan reference-groups): the encoder builds the dictionary — a field's condition groups in the user's order, then its default values as a trailing group without `condition`, no key when nothing is set (`ruleNodeUtils.js:166-197` at `7bfff25`); the decoder reads groups with a `condition` into the setting's groups and the trailing one into `defaultValues`, and any non-object, the old array included, into no fields (`:488-526`); `types.ts` names `ReferenceGroup`; a round-trip test pins the order. Not yet tried against the deployment. `stripUnsupportedReference` (`0fdb36d`) is unchanged: it drops the key whole for a code without `ReferenceFields`.
- **The dialog's default 參考欄位 are unchanged.** They still come from `RuleSchema`'s `ReferenceFields` (rule-schema-api › A field's three homes); the owner's 2026-09-30 GET of it differs from the 2026-09-17 capture in 203 alone — `FuncDate` first in `Default` (`db59964`) and five options `Disabled` (`851bbb3`; rule-schema-api › What the kernel actually fills in). The ① ② chips of 參考日期 are that ordered multi-select; their order is the `Fields` order the new shape reads as a fallback chain.

## The store
- 1,695 of the 1,731 rows were created 2026-08-21 15:17–15:19 (+08:00) in one load whose leaves are dated 2026-06-05 … 06-12 — prototype-era rules converted by a loader outside both repositories (no fixture in either; the kernel's `docs/ruleSetExample/*.json` at `0638bb3` carry no `GroupName`). Its marks: `Main.GroupName` in 242 rows, and in 743 rows an `OtherNote` naming codes the `Logic` lacks — 305 (544 rows), 306 (345), 303 (120), 101 (95), 304 (63): 303–306 entered the registry on 2026-09-03 (`e409495`, `d412d35`), after the load, so those leaves were dropped by the loader or refused by `SchemaExistenceValidator` (since `1d449cc`, 2026-07-07).
- The translator landed 2026-09-15 (`745ebc2`); 3 rows carry `TranslatedRules`, all 201, each 5–10× its row's `Logic` — the field's share grows as the translator covers more codes (rea-kernel › Save translates). `51018C` was written 2026-09-17 15:17 by the unpushed `REA_UI` build `9f091c3`, whose leaves carry the group name in `Name` (rea-ui › Branches).
- **Emptied by 2026-09-30.** `GET /api/v1/RuleSet?$top=3` on `:8080` answers `[]` (read in session, not captured) while its swagger already shows `ReferenceGroup` and the three new top-level keys: the store was reset with the new build, so no row of the old `Reference` shape is left there to deserialize — the loader's marks and the translated rows above describe the old build's store and survive only as this description. Whether other hosts keep old-shape rows is not known; the kernel has no converter for them (`grep ReferenceItem` hits one test file).
