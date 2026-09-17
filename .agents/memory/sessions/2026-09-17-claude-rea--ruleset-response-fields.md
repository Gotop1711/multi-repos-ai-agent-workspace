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
- Owner asked why two rows differ in shape. Answered from the store, not the ui: nulls are omitted,
  and the writers differ — 1,695 rows are a 2026-08-21 load of prototype-era leaves (`Main.GroupName`,
  743 orphan `OtherNote`s: 303–306 were not in the registry until 09-03); `51018C` was written by the
  unpushed `9f091c3` build at 15:17 today. :8081 serves `392230e` (bundle markers). rea-kernel › The
  store, rea-ui › Branches / Deployment, rule-editor › OtherNote outlives Logic.
- Plan **ruleset-unread-fields** (draft): the ruling — leave / `$select` / drop `TranslatedRules`.
- Citation fix in rule-editor and rea-kernel: the undeclared-key rejection is
  `SchemaExistenceValidator.cs:76-82`, not `FieldRuleValidator.cs:78-95` (both `2ff26b0` and `458e663`).

## Decisions & pitfalls
- `Main` is a free dictionary, so `GroupName` inside it passes reads — first read as a node key
  the kernel had gained; mask the jq path before concluding.
- Live counts come from a GET into gitignored scratch, not ingested (1.77 MB > the cap; rule data).
- zsh reads `$ref:src/…` as a history modifier — brace it. Bundle markers (a zh literal, a map key)
  pin a deployed build; property names survive minification, function names do not.
- The `Form → Main` citation named the wrong validator since it was written; grep the message text.

## TODO
- Owner: rule on ruleset-unread-fields; `Main.GroupName` rows — ui strip or data cleanup?
- Unverified: a history row loads the newest `RuleSet` — `ruleStartDate` ignored (`Payment.vue:768`).
