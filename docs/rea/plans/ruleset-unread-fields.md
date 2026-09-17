# rea — ruleset-unread-fields: the RuleSet response carries fields the ui never reads

Status: draft

## Goal
`REA_UI@392230e` never reads five of the ten top-level fields of a `GET /api/v1/RuleSet` row, nor
the leaf `Name` inside `Logic`, and the endpoint refuses `$select`, so the ui cannot trim the
request — the per-field table, citations and store shares are in ruleset-api › What the ui reads.

| | Fields | Share of the dev store's bytes |
|---|---|---|
| read | `OrderCode` `RuleStartDate` `RuleEndDate` `Logic` `OtherNote` | 88% |
| never read | `SchemaVersion` `TranslatedRules` `TranslatorVersion` `CreatedAt` `UpdatedAt` | 12% |
| never read, in `Logic` | the leaf `Name` — a save overwrites it with the code's display name | — |

`TranslatedRules` is the field to watch: no reader in the ui or the kernel (rea-kernel › Nothing
consumes), set on 3 rows today (all 201) at 5–10× their `Logic`, growing as the translator covers
more codes. One row per selection (`$top=1`) keeps the cost small; a list view over `RuleSet` would
not. This plan is the ruling, one of:
- **(a) leave them** — no change; the ruling goes into ruleset-api › What the ui reads.
- **(b) `$select`** — the kernel allows it, the ui asks for the five keys it reads.
- **(c) drop `TranslatedRules` / `TranslatorVersion` from the GET** — engine-internal, no reader
  anywhere; the kernel keeps them in the store.

## Found alongside
Not this plan's writes — each is its own ruling; the facts live in ruleset-api.
- **The leaf `UpdatedAt` is read for single-group codes only.** A multi-group code's `Or` branch
  carries none, so 上次更新時間 shows `-` for every multi-group rule (verified on the store's `51018C`).
  The fix is one line — read the timestamp off a leaf, all of one code's leaves being equal.
- **`Main.GroupName`** on 242 loader-written rows is echoed back by an unopened rule; the kernel
  would 400 the save (inferred, not executed). A ui strip or a store cleanup — the owner's call.
- **`OtherNote` outlives `Logic`**: a note for a code with no leaf is dropped on the next save — 743
  rows today.
- **A history row loads the newest `RuleSet`**: `fetchOrderCodeDetail` ignores `ruleStartDate`
  (`Payment.vue:768-774`; not tried in the browser).

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
  `tests/unit/api/modules/rules.test.js` gains the `$select` expectation. The ui build must not
  precede the kernel's: a `$select` the kernel rejects fails every load.
- (a) and (c): no ui write.

## Steps
1. The owner's ruling — (a), (b) or (c). (a) ends the plan `Abandoned: — decided: …`.
2. (b) / (c): the request to the kernel's owners — ends `Abandoned: — decided: requested …`.
3. (b) only, once the kernel serves it: the one ui commit above; `npx vitest run`; `npm run lint`.

## Done when
- (a): the ruling stands in ruleset-api.
- (b): a selection on `:8081` issues the `$select` request, the row comes back with exactly the five
  keys, and a rule loads and re-saves unchanged; vitest and lint green.
- (c): a `GET` row carries no `TranslatedRules`; a 201 save still stores it (`RuleSetSL.cs:120-129`).
