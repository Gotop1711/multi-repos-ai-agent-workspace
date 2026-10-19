# rea / ruleset-api

The `RuleSet` round trip: the row `GET /api/v1/RuleSet` returns, the `Reference` shape the kernel changed on 2026-09-29, what `REA_UI` reads of it, and what the dev store holds. Kernel cited at `REA_kernel@6540a4c` (`develop`, 2026-09-30) and at the swagger the deployment served that day (`docs/rea/rea-kernel/sources/2026-09-30-swagger.json.md@407d8f46c91a`, cited as `L<n>`); ui at `REA_UI@7bfff25` (`develop`; pushed by 2026-10-01); a line marked `458e663`, `392230e` or `a024004` was read at that sha. The store as read by GET on 2026-09-17 — 1,731 rows / 1.77 MB into gitignored scratch, not captured; on 2026-09-30 the same host answers `[]` (The store). `:8080` (the kernel) and `:8081` (the ui's nginx, proxying `/api`) answer from one store.

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

## Save — the gate `POST /api/v1/RuleSet` runs
Kernel at `REA_kernel@6540a4c`; to `692bdc0` (2026-10-07, what the host ran) the validators,
`RuleSetParameter` and the translator's reach are unchanged. To `1706cb5` (2026-10-19): one validator
change — `FieldRuleValidator` skips a field whose `VisibleWhen` controller holds another value, so a
hidden `Required` field no longer fails the save (`:76-81`, `1b0ecaf`; the line numbers below shift
by +7 from `:76`) — and the translator now covers 204 and twelve conditions (rea-kernel › Save
translates; scope-conditions › 7).
- **The body is an array.** `SaveAsync([FromBody] IEnumerable<RuleSetParameter>)`「支援批次儲存」
  (`API/NHI.API.ClaimValidator/Controllers/V1/RuleSetApiController.cs:30-32`); the ui sends a one-item
  array — the owner's capture of its 2026-10-02 save of `01116B`:
  `docs/rea/rea-kernel/sources/2026-10-02-api-post-ruleset-request-body-example.json.md@07a15b0b3ef4`
  (the swagger skeleton beside it:
  `docs/rea/rea-kernel/sources/2026-10-02-api-post-ruleset-request-body-schema.json.md@cab27b4809c1`). 200 answers
  `[{OrderCode, RuleStartDate}]`; 400 answers `ErrorResults [{Code, Name, Path, Message}]`.
- **Four validators, in order, first failing stage answers 400 with all its errors**
  (`API/…/Attributes/RuleSetValidationFilter.cs:18-24`, `:50-60`; an empty array is 400「參數不可為空」,
  an item whose `Logic` is null skips them all — null clears the 醫令, `:33-50`).
  1. `SchemaVersionValidator`: the version is in the registry (`Validation/SchemaVersionValidator.cs:14-20`).
  2. `StructureValidator`: a node is a branch (`Op`) xor a leaf (`Code`); `And`/`Or` need both children,
     `Not` a `Left` only; a leaf's `Name` and `GroupName` are non-blank and `GroupName` is unique per
     code; a `Reference` key's list is non-empty and every group but the last has a `Condition`
     (`Validation/StructureValidator.cs:29-35`, `:50-54`, `:72-76`, `:87-115`, `:159-174`).
  3. `SchemaExistenceValidator`: the code exists「不存在的 RuleCode」; every `Main` key is a served
     `MainFields[].Value`「不允許的欄位」, an `ObjectArray`'s elements are objects of declared sub-keys; a
     `Condition.Field` is a served condition and its `Params` keys are its fields; `Reference` only on a
     code with `ReferenceFields`「此 RuleCode 不支援 Reference 欄位」and each key among them
     (`Validation/SchemaExistenceValidator.cs:55-65`, `:76-103`, `:112-147`, `:174-186`).
  4. `FieldRuleValidator` walks the **schema's** fields, not the body's keys: a `Required` field that is
     missing, null, `""` or `[]` is「此欄位必填」; a present value must match the type (`String`,
     `Number`, `StringArray`/`ObjectArray` = JSON array), pass `Min`/`Max`/`MinLength`/`MaxLength`/
     `Pattern`, and `CompareField` when both sides are numbers; a string or every string of an array
     must be one of `Options` when the field has them「不允許的選項」; `SubFields` are walked per element;
     `Condition.Params` and each `ReferenceGroup.Fields` entry the same way
     (`Validation/FieldRuleValidator.cs:74-100`, `:116-183`, `:188-206`, `:211-224`, `:253-303`, `:307-314`).
     No `Reference` key is ever required: only keys present are checked.
- **Then the service** (`Service/NHI.Service.DTO.ClaimValidator/Implementation/V1/RuleSetSL.cs:27-91`):
  the same `OrderCode` twice in one batch fails the batch「請分批提交」(`:31-42`); per item, against the
  醫令's current version (`RuleEndDate` null): an earlier `RuleStartDate` is an error (`:54-63`), a later
  one closes the current version at start − 1 day (`:65-70`), the same date overwrites it keeping
  `CreatedAt` (`:75-76`); any error and **nothing is saved**, else all of it in one transaction
  (`:85-89`; DAO `Implementation/V1/RuleSetSL.cs:31-47`). `LogicExpression`, `Codes`, `Conditions`
  are filled (`:128-131`) and the latest translator run — `NotSupportedException` leaves
  `TranslatedRules` null (`:133-145`; rea-kernel › Save translates).
- **A row without `TranslatedRules` is not checkable.** The ETL worker loads the effective row for an
  order code and date and deserializes `TranslatedRules`; blank, it throws「缺少 TranslatedRules」
  (`src/ETL/NHI.ETL.ClaimValidator/Workers/ClaimValidationWorker.cs:226-252`); the loop around it turns
  only *no row* into `NoRule` results (`:85-113`), nothing there catches the throw — what the job then
  records was not traced. Today that is every code but 201 and 203.
- **What the ui sends — the owner's eighteen records of 2026-10-08.** One save per rule kind on
  `33116B` from the running ui, under `docs/rea/rea-kernel/sources/`:
  `2026-10-08-post-ruleset-101.json.md@6e0778368c2e`, `2026-10-08-post-ruleset-102.json.md@1fe2ad063bc5`,
  `2026-10-08-post-ruleset-103.json.md@b467b5903a92`, `2026-10-08-post-ruleset-104.json.md@3157a491efe9`,
  `2026-10-08-post-ruleset-106.json.md@fcf4d020a21f`, `2026-10-08-post-ruleset-201.json.md@f60f66f6dcbc`,
  `2026-10-08-post-ruleset-202-01.json.md@2010353700b6`, `2026-10-08-post-ruleset-202-02.json.md@3e034b98ffeb`,
  `2026-10-08-post-ruleset-203.json.md@532103a6f5a9`, `2026-10-08-post-ruleset-204.json.md@2e5f81ae9d99`,
  `2026-10-08-post-ruleset-205.json.md@f1d549c51dfd`, `2026-10-08-post-ruleset-206.json.md@2c5addac36e6`,
  `2026-10-08-post-ruleset-301.json.md@7bfd35685c0b`, `2026-10-08-post-ruleset-302-01.json.md@15b46331d9bc`,
  `2026-10-08-post-ruleset-302-02.json.md@1e1fa6ea9406`, `2026-10-08-post-ruleset-302-03.json.md@a799b0c18647`,
  `2026-10-08-post-ruleset-307.json.md@e159e6e20a7c`, `2026-10-08-post-ruleset-401.json.md@f178711aab38`. Every body is a one-item array; the leaf carries `Code`,
  `Name` (the code's label), `GroupName` 群組1, `Main`, `UpdatedAt`, and **every `ReferenceFields` key
  the code serves, one group each, at its schema `Default`** — `DoctorType [{Fields: ["Doctor"]}]` on
  103, `HospCodes` on 106 and 202, `DoctorTypes` all three on 202/205/206, `AgeReference` on 302/307 —
  while 201 and 301 carry no `Reference`. 205/206 `SpecialistCodes` and 301 `GenderCode` go as single
  strings; 302's three records exercise every `MinOp`/`MaxOp`; 307's rows carry `RangeEnd1 =
  RangeStart1` for a single code and `0`–`9999` months where no age applies, and 202's radio emits
  `DoctorRole "Executor"` or `"FullTime"`. `OtherNote` is the ui's text form, labels not values.
  `AgeReference`'s options are `Birthday`, `ChildBirthday` since `REA_kernel@692bdc0` (2026-10-07,
  `_302.cs:91-94`, `_307.cs:98-101`), which the host serves
  (`…/sources/2026-10-08-ruleschema-live.json.md@476fba76c157`); a body with the old lowercase values
  is now「不允許的選項」.
- **The store on 2026-10-08**: seven rows — `12116B` 101 (2026-10-01) and `01116B` 102 (10-02),
  `TranslatorVersion` null; `01115A` 201, `51018C` 201, `02028B` 203 and `00111C` 201+203 (10-03),
  all `1.1`; `33116B` 202 (10-09), null — the records above overwrote one another on the same start
  date and the last, 202, stands. Read in session, not captured.
