# rea — ruleset-unread-fields: the RuleSet response carries fields the ui never reads

Status: draft

## Goal
`GET /api/v1/RuleSet` returns a `RuleSet` (`REA_kernel@458e663 POCO/V1/Rules/RuleSet.cs:10-64`).
What `REA_UI@392230e` does with each top-level field (rule-editor › RuleSet → editor); the share
is the field's bytes over the dev store's 1,731 rows / 1.77 MB, read 2026-09-17:

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

The five unread fields — 12% together — are named only by `src/api/modules/rules/types.ts:28-40`
and `mock/rulesData.js:1629-1632`. Inside `Logic` (`RuleNode`, `RuleSet.cs:69-117`):

| Key | Read | Where |
|---|---|---|
| `Op` `Left` `Right` `Code` | yes | `src/utils/rule/ruleNodeUtils.js:361-433` |
| `Condition` and its five keys | yes | `:435-479`, `:541-542` |
| `Reference[].Params` / `.Condition` | yes | `:481-515` |
| `Main` | yes | `:544` |
| `UpdatedAt` (leaf) | yes | 上次更新時間, `ruleEditor.js:103`, `RuleEditorDialog.vue:28` |
| `Name` (leaf) | **no** | a save overwrites it with the code's display name (`:288-303`) |

The ui cannot trim the request: the endpoint allows Filter | OrderBy | Top | Skip only
(`Controllers/V1/RuleSetApiController.cs:24`; the deployment answers `$select` with "Query option
'Select' is not allowed"). `TranslatedRules` is the field to watch: the kernel never reads it back
either (rea-kernel › Nothing consumes) and its share grows as the translator covers more codes.
Today one row per selection (`$top=1`) keeps the cost small; a list view over `RuleSet` would not.

This plan is the ruling on those fields, one of:
- **(a) leave them** — no change; the ruling goes into rule-editor › RuleSet → editor.
- **(b) `$select`** — the kernel allows it, the ui asks for the five keys it reads.
- **(c) drop `TranslatedRules` / `TranslatorVersion` from the GET** — engine-internal, no reader
  anywhere; the kernel keeps them in the store.

## Writes
`REA_kernel` is read-only here: the plan carries the request's exact content for its owners.
- (b) kernel: `RuleSetApiController.Get` adds `AllowedQueryOptions.Select` — one token at `:24`.
  Untested against the Mongo provider with `Logic` stored as one JSON string
  (`Context/ClaimValidatorDbContext.cs:13-18,34-40`); the owners verify `$select=Logic` projects.
- (c) kernel: `[JsonIgnore]` on `RuleSet.TranslatedRules` and `.TranslatorVersion` (`RuleSet.cs:48`,
  `:53`) — `RuleSet` is the GET shape only (POST takes `RuleSetParameter`), and EF's Mongo mapping
  does not read System.Text.Json attributes, so the store is untouched; the owners confirm.
- (b) ui, after the kernel ships: `REA_UI (debug-ui)` — `getRuleSetList` adds
  `$select=OrderCode,RuleStartDate,RuleEndDate,Logic,OtherNote` (`src/api/modules/rules/index.ts:167`);
  `types.ts` `RuleSet` drops the five or marks them optional; `mock/rulesData.js:1629-1632` follows;
  `tests/unit/api/modules/rules.test.js` gains the `$select` expectation. The ui build must not precede the kernel's: a `$select`
  the kernel rejects fails every load.
- (a) and (c): no ui write.

## Steps
1. The owner's ruling — (a), (b) or (c). (a) ends the plan `Abandoned: — decided: …`.
2. (b) / (c): the request to the kernel's owners — ends `Abandoned: — decided: requested …`.
3. (b) only, once the kernel serves it: the one ui commit above; `npx vitest run`; `npm run lint`.

## Done when
- (a): the ruling stands in rule-editor.
- (b): a selection on `:8081` issues the `$select` request, the row comes back with exactly the five
  keys, and a rule loads and re-saves unchanged; vitest and lint green.
- (c): a `GET` row carries no `TranslatedRules`; a 201 save still stores it (`RuleSetSL.cs:120-129`).

Not in this plan: the `Main.GroupName` echo that a save would 400 on (rule-editor › Unread yet
echoed) and the history row that loads the newest `RuleSet` (`Payment.vue:768-774`, unverified).
