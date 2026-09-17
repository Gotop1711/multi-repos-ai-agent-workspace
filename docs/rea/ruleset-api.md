# rea / ruleset-api

The `RuleSet` round trip: the row `GET /api/v1/RuleSet` returns, what `REA_UI` reads of it, and what the dev store holds. Kernel cited at `REA_kernel@458e663` (`develop`), ui at `REA_UI@392230e` (`debug-ui`); the store as read by GET on 2026-09-17 — 1,731 rows / 1.77 MB into gitignored scratch, not captured. `:8080` (the kernel) and `:8081` (the ui's nginx, proxying `/api`) answer from one store: same rows, same `UpdatedAt`.

## The row
- `Get()` is `IQueryable<RuleSet>` with OData Filter | OrderBy | Top | Skip only (`API/NHI.API.ClaimValidator/Controllers/V1/RuleSetApiController.cs:23-25`); `$select` is refused — the deployment answers "Query option 'Select' is not allowed" — so a client cannot trim a row. The model: `POCO/V1/Rules/RuleSet.cs:10-64`; `Logic` is a `RuleNode` tree (`:69-117`) of `Condition` (`:122-150`) and `ReferenceItem` (`:155-167`). The swagger of 2026-09-17 matches the source key for key. Nulls are not serialized (`Program.cs:11`), so two rows differ in key set: `TranslatedRules`, `TranslatorVersion`, `RuleEndDate` appear only where set.
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
| `Reference[].Params` / `.Condition` | yes | `:481-515` |
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
- **`Name` is unread and overwritten.** The arrangement names a rule from the schema's code table (`:402`, `:411`); the group name is read from `groupName`, which no kernel model carries (rule-editor › The leaf envelope); a save stamps `name` with the code's display name.
- **Unread yet echoed.** A rule not opened in its dialog goes back as loaded (`ruleEditor.js:45`, `ruleNodeUtils.js:324-334`). 242 rows hold a `GroupName` key inside `Main` (a free dictionary on read) that no code declares and the ui never reads — the 2026-08-21 loader's mark (The store); `SchemaExistenceValidator` rejects an undeclared `Main` key (`Validation/SchemaExistenceValidator.cs:76-82`), so saving such an order code without re-saving that rule through its dialog (whose whitelist drops the key, rule-editor › Form → `Main`) should 400. Inferred from source; no save executed.
- **`OtherNote` outlives `Logic`.** `loadFromRuleSet` keeps a note only for a code that has a leaf (`ruleEditor.js:99-105`) and `buildRuleSet` rebuilds the string from `ruleData` alone (`:108-115`), so a note whose code has no leaf is invisible on load and gone on the next save — 743 stored rows carry such notes (The store).

## The store
- 1,695 of the 1,731 rows were created 2026-08-21 15:17–15:19 (+08:00) in one load whose leaves are dated 2026-06-05 … 06-12 — prototype-era rules converted by a loader outside both repositories (no fixture in either; the kernel's `docs/ruleSetExample/*.json` at `0638bb3` carry no `GroupName`). Its marks: `Main.GroupName` in 242 rows, and in 743 rows an `OtherNote` naming codes the `Logic` lacks — 305 (544 rows), 306 (345), 303 (120), 101 (95), 304 (63): 303–306 entered the registry on 2026-09-03 (`e409495`, `d412d35`), after the load, so those leaves were dropped by the loader or refused by `SchemaExistenceValidator` (since `1d449cc`, 2026-07-07).
- The translator landed 2026-09-15 (`745ebc2`); 3 rows carry `TranslatedRules`, all 201, each 5–10× its row's `Logic` — the field's share grows as the translator covers more codes (rea-kernel › Save translates). `51018C` was written 2026-09-17 15:17 by the unpushed `REA_UI` build `9f091c3`, whose leaves carry the group name in `Name` (rea-ui › Branches).
