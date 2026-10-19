# rea / rule-schema-api

`GET /api/v1/RuleSchema` — the contract every rule dialog is rendered from: the envelope, the seven
objects inside it, what the kernel actually puts in each optional key, and what `REA_UI` does with
each. Kernel cited at `REA_kernel@e5ba92e` (`develop`), paths relative to
`src/Model/NHI.Model.ClaimValidator/` unless a root is given; ui at `REA_UI@a024004` (`develop`).
Counts are of the live capture of 2026-09-17
(`docs/rea/rea-kernel/sources/2026-09-17-ruleschema-live.json.md@ecc4c965567f`); 307 and 401 were
re-issued after it (rea-kernel), so read theirs as a floor; the owner's GET of 2026-09-30 (compared
in session, not ingested) differs from it in 203 alone — `FuncDate` first in `Default` and five
options `Disabled`, both in `Codes/V1.0/_203.cs:29-38` at `REA_kernel@6540a4c`. Written from two documents the owner
supplied on 2026-09-24: the swagger response-schema screenshot
(`docs/rea/rea-kernel/sources/2026-09-24-ruleschema-swagger-schema.jpg.md@30e681f74fc9`) and the
example body the same page prints
(`docs/rea/rea-kernel/sources/2026-09-24-ruleschema-swagger-example.json.md@0541b25a4cf9`).
Who renders what from it: rule-editor; the 檢核範圍 menus in particular: scope-conditions.

## The envelope

- **The response is an array, not an object.** `GetAsync()` returns `IEnumerable<RuleSchema>` under
  `[EnableQuery]`, so the list is OData-queryable like `RuleSet`
  (`src/API/NHI.API.ClaimValidator/Controllers/V1/RuleSchemaApiController.cs:18-23`). It is served
  from a static in-memory registry ordered by `Version` descending — no database, no request
  parameters (`src/Service/…/Implementation/V1/RuleSchemaSL.cs:9-10`; rea-kernel).
- **One entry exists today**: `Version "1.0"`, `EffectiveDate 2026-01-01`, twenty codes hard-coded
  in order 101–106, 201–206, 301–307, 401 (`src/Service/…/Specification/V1/RuleSchemaRegistry.cs:8-39`).
  A second version is a source edit, and the array is how it would arrive.
- **The ui picks the newest by date, not the one in force.** `pickLatestSchema` sorts by
  `effectiveDate` descending, ties broken by `version`, and takes the first
  (`src/api/modules/rules/index.ts:34-43`, `:141-158`); nothing compares the date with today, so a
  future-dated version would take effect the moment it is served. It also accepts either a bare
  array or an OData `{ value: [...] }` wrapper (`unwrapOData`, `:45-51`).

## The seven objects

| Object | Required keys | Optional keys | In one line |
|---|---|---|---|
| `RuleSchema` | `Version`, `EffectiveDate`, `Codes` | — | one version of the whole registry |
| `RuleCode` | `Value`, `Label`, `MainFields` | `Description`, `ReferenceFields`, `Conditions` | one rule code (101 … 401) |
| `RuleFieldDescriptor` | `Value`, `Label`, `Type` | nine, below | one input box, anywhere |
| `OptionDescriptor` | `Value`, `Label` | `Disabled` | one item of a fixed dropdown |
| `ConstraintDescriptor` | `Type`, `Message` | `Value`, `Pattern`, `Field`, `Op` | one validation rule on a field |
| `VisibleWhenRule` | `Field`, `Value` | — | show this field only when a sibling equals a value |
| `ConditionDescriptor` | `Value`, `Label`, `Fields` | `Disabled` | one 檢核範圍 condition and its fields |

`RuleSchema.cs:6-22`, `Rules/RuleCode.cs:8-39`, `Descriptor/RuleFieldDescriptor.cs:10-76`,
`Descriptor/OptionDescriptor.cs:6-22`, `Rules/ConstraintDescriptor.cs:8-39`,
`Rules/VisibleWhenRule.cs:6-17`, `Descriptor/ConditionDescriptor.cs:6-27`.

**A field's three homes.** The same `RuleFieldDescriptor` shape appears as `RuleCode.MainFields`
(主設定), `RuleCode.ReferenceFields` (參考欄位) and `ConditionDescriptor.Fields` (a 檢核範圍
condition's inputs), and inside itself as `SubFields`. That is why the screenshot is twelve
thousand pixels tall: swagger expands the same object at every nesting level.

### `RuleFieldDescriptor` key by key

| Key | Type | Means |
|---|---|---|
| `Value` | string, required | the field's identifier — the `Main` dictionary key a save writes |
| `Label` | string, required | the caption shown above the control |
| `Type` | enum, required | `String` · `Number` · `StringArray` · `ObjectArray` (`Enums/RuleFieldTypeEnum.cs:9-19`) |
| `Options` | `OptionDescriptor[]` | a fixed dropdown's items |
| `OptionsApi` | string | an endpoint the items come from instead, `{Token}` = a sibling field's value |
| `Default` | **any** | the pre-filled value — a string, an array, anything (`object?`) |
| `SubFields` | `RuleFieldDescriptor[]` | the row template of an `ObjectArray` |
| `PrefixText` / `SuffixText` | string | words printed before / after the control, inline |
| `Placeholder` | string | the grey hint inside an empty box |
| `Constraints` | `ConstraintDescriptor[]` | the validation rules |
| `VisibleWhen` | `VisibleWhenRule` | the one sibling value that makes this field appear |

The seven constraint types are `Required`, `MinLength`, `MaxLength`, `Min`, `Max`, `Pattern`,
`CompareField` (`Enums/ConstraintTypeEnum.cs:9-25`) — the screenshot shows them only as a
collapsed `Array [ 7 ]`. `Value` carries the number a `Min` / `Max` / `…Length` compares against,
`Pattern` the regex, and `Field` + `Op` the sibling and operator a `CompareField` compares with.

## Reading the example body

The JSON the swagger page prints is a **generated skeleton, not data**: every leaf is the
generator's placeholder for its type. Its key set and nesting are exact; its values are worth
nothing, and four of them actively mislead.

| In the example | Why it is wrong | What real data looks like |
|---|---|---|
| `"SubFields": ["string"]` (L32-34) | recursion is cut off, so a nested field becomes a bare string | an array of whole field objects |
| `"Default": "string"` (L31) | the key is `object?`, which the generator prints as a string | `"In"`, or `["ApplyDate","ExecutionStartDate"]` |
| `"EffectiveDate": "2026-09-24"` (L12) | the day the page was opened | `2026-01-01` |
| `"Disabled": true` (L27), `"Value": 0` (L42) | the generator's default for `bool` / `number` | at the capture only 203's five date options carried `Disabled` (91 options at `REA_kernel@1706cb5`: 203's and 204's five dates, 204's 遠距, and in every code 年齡's `06`–`08` and 診療之部位's `04`); a constraint's `Value` is its real bound |

`"Type": "String"` (L22) and `"Type": "Required"` (L40) are likewise the first member of each enum.
Line numbers are of the derivative cited in the header.

**Two things to know about the schema page itself.** A property that is a bare `$ref` shows the
*referenced type's* description instead of its own — `Type` reads 「規則欄位的資料型別。」 (the enum's
summary) and `VisibleWhen` reads 「欄位顯示條件規則…」 (`VisibleWhenRule`'s), not the property comments
in `RuleFieldDescriptor.cs:23`, `:73`. And `nullable: true` is printed beside `Version`, `Codes` and
every other string / array / object property even where the C# is `required` and non-null
(`RuleSchema.cs:11-21`); it is an artefact of the generator, not a promise. Where it means what it
says is the value types — `OptionDescriptor.Disabled`, `ConditionDescriptor.Disabled`,
`ConstraintDescriptor.Value` — which really are `bool?` / `double?`. Seen at
`docs/rea/rea-kernel/sources/2026-09-24-ruleschema-swagger-schema.jpg.p1.jpg@9e1b0e90b4cc`.

## What the kernel actually fills in

Across the 2026-09-17 capture: 20 codes, 1,088 field descriptors (1,084 top-level and 4 inside one
`SubFields`), 1,557 options, 260 conditions — thirteen per code, of which 201's nine were
`Disabled`; at `REA_kernel@1706cb5` one per code, `Robotic` (rule-editor › Disabled conditions).

| Key | Used | Where it shows up |
|---|---|---|
| `Constraints` | 780 fields | `Required` 766 · `CompareField` 86 (`Op` `>=` 85, `>` 1) · `Min` 12 |
| `Options` | 548 fields | — |
| `Placeholder` | 400 fields | — |
| `VisibleWhen` | 341 fields | `Field` is `Category` in every one of them |
| `Default` | 267 fields | strings (`"In"`) and arrays alike |
| `OptionsApi` | 129 fields | `/api/v1/Options/PxxtCode/…`, the Oracle code table (rea-kernel) |
| `PrefixText` / `SuffixText` | 14 / 12 fields | 303 and 304's sentences only |
| `SubFields` | **1 field** | 307's `DiagnosisCodes`, the one `ObjectArray` in the registry |
| `Description` (on `RuleCode`) | **0 codes** | never set |
| `Disabled` (on an option) | 0 in the capture; **5 since `851bbb3`** (2026-09-29), **91 at `1706cb5`** (rea-kernel › The schema) | 203's `ReferenceDates`: `AdmissionDate`, `DischargeDate`, `DispensingDate`, `PhysicalTherapyStartDate`, `ExaminationDate` (`_203.cs:32-36`); the three left enabled are the ones its translator accepts (ruleset-api › `Reference`) |

Field types: `String` 713, `StringArray` 320, `Number` 54, `ObjectArray` 1. Of the seven constraint
types only three are ever served; `MinLength`, `MaxLength`, `Max` and `Pattern` exist in the enum
and nowhere in the data. Every one of the twelve `Min`s is `Value: 0` 「不得小於 0」 on a count or a
prefix length (302, 303, 304, 305, 306).

## What the ui does with each key

The response passes two layers before the editor sees it: the axios interceptor camelizes every key
and `normalizeFieldIds` lowers the identifier *values* (rule-editor › Field names). One rename
happens there: **`Constraints` arrives as the ui's `validations`** — the kernel renamed the key and
the client folds it back, deleting `constraints` (`src/api/modules/rules/index.ts:82-87`, comment at
`:69`), which is why no ui file mentions `constraints` at all.

| Key | Read by the ui? | Where |
|---|---|---|
| `Value` `Label` `Type` `Options` `OptionsApi` `Default` `SubFields` | yes | `src/utils/rule/ruleSchemaUtils.js:37-80`, `MainSetting.vue:517-545` |
| `PrefixText` `SuffixText` `Placeholder` | yes | printed inline, `src/utils/rule/inputTypeConfig.js:67-73` |
| `Constraints` | as `validations`, three of seven types | below |
| `VisibleWhen` | **no reader in the ui** | not in `src`, `tests` or `mock`; absent from the ui's own `RuleFieldDescriptor` (`src/api/modules/rules/types.ts:75-87`). The kernel reads it since `1b0ecaf` (2026-10-14): a field whose controller holds another value is not validated at all (`FieldRuleValidator.cs:76-81` at `1706cb5`) |
| `Options[].Disabled` | **no** | absent from the ui's `OptionDescriptor` (`types.ts:61-64`); served for 203's five dates since 2026-09-29; at `a024004` no 參考日期 option bound `disabled`, so they were selectable, admitted by the kernel's option check and refused by its translator; since `REA_UI@7bfff25` (2026-09-30, plan reference-groups) the sortable input and both `el-select` fallbacks bind it (`src/components/rules/SortOptionsInput.vue:30`, `src/views/rules/ReferenceSetting.vue:36`, `:84`) |
| `RuleCode.Description` | **no** | never served either |
| `ConditionDescriptor.Disabled` | yes | rule-editor › Disabled conditions |

- **Three of the seven constraint types are implemented.** The three call sites that turn served
  rules into Element Plus validators handle `required`, `compareField` and `maxLength` and drop
  everything else without a warning (`src/views/rules/MainSetting.vue:830-869`,
  `src/views/rules/ScopeSetting.vue:1592-1616`, `src/components/rules/GroupAddInput.vue:230-256`;
  the validators themselves in `src/utils/rule/inputValidation.js:35-151`). So **`Min` is served
  twelve times and enforced nowhere in the browser**, while `maxLength` is implemented and never
  served. The kernel enforces all seven on save (`src/API/…/Validation/FieldRuleValidator.cs:103-185`),
  so a negative 次數 passes the dialog and comes back as a 400 —「不得小於 0 (目前為 -1)」. Read from
  source; not executed against the deployment.
- **`Op` is spelled three different ways.** The schema's own comment offers 「例如 eq、gt、lt」
  (`Rules/ConstraintDescriptor.cs:36`), the kernel compares `>` `>=` `<` `<=` `=` and lets anything
  else **pass** (`FieldRuleValidator.cs:153-172`), and the ui compares `>` `>=` `<` `<=` `===` `!==`
  and makes anything else **fail** (`inputValidation.js:173-190`, defaulting to `===` when `Op` is
  absent). The only ops served are `>=` and `>`, where the two agree; `=` or an `eq` from the
  comment would silently pass the kernel and block the form.
- **`VisibleWhen` is ignored because the UI map already does its job.** All 341 served rules say
  "show me when `Category` is this value", and the editor gets the same effect from its own
  `linkedOptions` / `subGroups` entries, which are keyed by the prototype's blocks rather than by
  the served rule (scope-conditions › 2, rule-editor › Schema → form). The cost is that a code
  whose fields carry `VisibleWhen` but whose UI-map entry does not name them shows every field at
  once, as 306 did before its entry (rule-codes › 306).
- **`Default` is read under two names** — `field.defaultValue` first, then the served `default`
  (`ruleSchemaUtils.js:43-44`) — and fills only an absent value; a stored value always wins
  (rule-editor › RuleSet → editor).
- **`ObjectArray` + `SubFields` has exactly one instance in the whole registry** (307's
  `DiagnosisCodes`, four sub-fields), rendered by the `groupAdd` control
  (`ruleSchemaUtils.js:47-53`, `GroupAddInput.vue`). The schema allows `SubFields` to nest without
  limit; nothing uses a second level.
