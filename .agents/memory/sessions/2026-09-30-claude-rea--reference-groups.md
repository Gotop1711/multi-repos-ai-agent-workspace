# 2026-09-30 | claude | rea | reference-groups

## Task
Owner reports the `Logic.Reference` schema change on `POST /api/v1/RuleSet` (a swagger example in
`ui_misc/api-records`, outside the workspace), asks whether GET's shape changes too, and names the
live swagger on `210.59.250.145:8080` as the latest API document.

## Done
- Traced the change to `REA_kernel@851bbb3` (2026-09-29, the 203 translator): `ReferenceItem[]`
  → `Dictionary<string, List<ReferenceGroup>>`; validators, translator and semantics read from
  source at `6540a4c`. Answer: GET returns the identical shape (one `RuleNode` type behind
  `RuleSetParameter.Logic` and `RuleSet.Logic`) plus three save-filled top-level keys
  (`LogicExpression`, `Codes`, `Conditions`).
- Ingested the live swagger JSON; read the deployment's `RuleSet` store read-only: `[]` — emptied.
- Diffed the owner's 2026-09-30 `RuleSchema` GET against the 2026-09-17 capture: 203 alone
  differs (`FuncDate` first; five options `Disabled`). Not ingested — source accounts for it.
- ruleset-api: header, the row (new keys), the `Reference` section, the store's emptying;
  rule-editor: `GroupName` landed in the kernel (`a63ad16`, `6633198`) — the ruling is delivered;
  rea-kernel: translator `1.1` (201 + 203), `NotSupportedException` now stored not 500,
  `GroupName`, the 2026-09-30 deployment; rule-schema-api: the five `Disabled` options.
- Plan reference-groups signed and shipped the same day: `REA_UI@82908a2` (the dictionary, default
  group last, round-trip test) and `@7bfff25` (`disabled` on all three option lists — the real
  control is `SortOptionsInput`, not `el-select`); 1097 tests and lint green; `GroupName` needs
  no ui change (confirmed). Not pushed, not yet tried against the deployment.

## Decisions & pitfalls
- The GET of the store was a read of the dev host the owner named; no POST was sent, so "a save
  cannot bind → 400" is inferred from the types, and the plan's Done-when is where it gets tested.
- `toArray` (`src/utils/common.js:1`) returns `[]` for an object, so the ui does not crash on the
  new shape — it silently shows defaults and would overwrite the stored groups on save. Worse than
  a crash; said so in ruleset-api.
- The ui emits the default row first; the kernel wants it last, and order is now semantic (first
  match wins). No guard for a flagged stored value: the old store is gone (owner's word).
- Stale, out of scope: rea-kernel › Nothing consumes either carrier cites the `V1.0` translator;
  `RuleResultAttributionParser.V1_1.cs` exists now (plan translated-rule-names).

## TODO
- Owner: push `develop`, save a 203 rule with two groups against `:8080`, then `Verified:`.
- Owner: 306-main-setting and rea-proto-data-creator-setup still await `Verified:`.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea`.
