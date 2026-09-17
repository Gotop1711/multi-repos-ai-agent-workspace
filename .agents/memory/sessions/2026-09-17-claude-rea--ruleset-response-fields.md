# 2026-09-17 | claude | rea | ruleset-response-fields

## Task
Owner: which `GET /api/v1/RuleSet` response fields does `REA_UI` not use? (swagger and the local ui given)

## Done
- rule-editor gains **RuleSet → editor**: unread are `SchemaVersion`, `TranslatedRules`,
  `TranslatorVersion`, `CreatedAt`, top-level `UpdatedAt`, and the leaf `Name` (overwritten on
  save). Everything else in `Logic` is read. Kernel source, swagger and live rows agree on the model.
- Live (read-only GET of all 1,731 rows): the five unread fields are 12% of 1.77 MB; `TranslatedRules`
  on 3 rows, all 201, 5–10× their `Logic`; `$select` refused by the endpoint.
- Found on the way: 242 rows hold `Main.GroupName`; an unopened rule is echoed back verbatim, and
  `SchemaExistenceValidator` rejects the key — such a save should 400. Inferred, not executed.
- Citation fix in rule-editor and rea-kernel: the undeclared-key rejection is
  `SchemaExistenceValidator.cs:76-82`, not `FieldRuleValidator.cs:78-95` (both `2ff26b0` and `458e663`).

## Decisions & pitfalls
- `Main` is a free dictionary, so `GroupName` inside it passes reads — first read as a node key
  the kernel had gained; mask the jq path before concluding.
- Live counts come from a GET into gitignored scratch, not ingested (1.77 MB > the cap; rule data).
- No plan filed: whether `Main.GroupName` wants a ui strip or a data cleanup is the owner's call.
- The `Form → Main` citation named the wrong validator since it was written; grep the message text.

## TODO
- Owner: `Main.GroupName` rows — ui fix (plan) or kernel-side data cleanup? Kernel request to drop
  or `$select`-enable unread fields, if payload matters.
- Noted, unverified: `fetchOrderCodeDetail` ignores its `ruleStartDate` option — a history row
  loads the newest `RuleSet` (`Payment.vue:768-774`).
