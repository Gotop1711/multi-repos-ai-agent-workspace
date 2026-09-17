# rea — ruleset-unread-fields: the RuleSet response carries fields the ui never reads

Status: draft

## Goal
Of the ten top-level fields in a `GET /api/v1/RuleSet` row (`REA_kernel@458e663
POCO/V1/Rules/RuleSet.cs:10-64`), `REA_UI@392230e` reads five — `OrderCode`, `RuleStartDate`,
`RuleEndDate`, `Logic`, `OtherNote` — and never `SchemaVersion` (a save sends the loaded schema's
own version), `TranslatedRules`, `TranslatorVersion`, `CreatedAt` or the top-level `UpdatedAt`
(rule-editor › RuleSet → editor; the five are named only by `src/api/modules/rules/types.ts:28-40`
and `mock/rulesData.js:1629-1632`). Inside `Logic` one key goes unread, the leaf `Name`: a save
overwrites it with the code's display name (`ruleNodeUtils.js:288-303`). Every other key —
`Condition`, `Reference`, `Main`, the leaf `UpdatedAt` — is used.

The ui cannot trim the request: the endpoint allows Filter | OrderBy | Top | Skip only
(`Controllers/V1/RuleSetApiController.cs:24`; the deployment answers `$select` with "Query option
'Select' is not allowed"). On the dev store the five unread fields are 12% of 1.77 MB over 1,731
rows, mostly the two timestamps; `TranslatedRules` — set on 3 rows, all 201 — is 5–10× its own
row's `Logic`, and the kernel never reads it back either (rea-kernel › Nothing consumes), so its
share grows as the translator covers more codes. Today one row per selection (`$top=1`) keeps the
cost small; a list view over `RuleSet` would not.

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
2. (b) / (c): the request above to the kernel's owners; that part ends `Abandoned: — decided:
   requested …`, and rea-kernel is re-cited when it lands.
3. (b) only, once the kernel serves it: the one ui commit above; `npx vitest run`; `npm run lint`.

## Done when
- (a): the ruling stands in rule-editor.
- (b): a selection on `:8081` issues the `$select` request, the row comes back with exactly the five
  keys, and a rule loads and re-saves unchanged; vitest and lint green.
- (c): a `GET` row carries no `TranslatedRules`; a 201 save still stores it (`RuleSetSL.cs:120-129`).

Not in this plan, found alongside: `Main.GroupName` on 242 loader-written rows is echoed back by
an unopened rule and rejected by `SchemaExistenceValidator` (rule-editor › Unread yet echoed); a
history row loads the newest `RuleSet` because `fetchOrderCodeDetail` ignores `ruleStartDate`
(`Payment.vue:768-774`, unverified). Each is its own ruling.
