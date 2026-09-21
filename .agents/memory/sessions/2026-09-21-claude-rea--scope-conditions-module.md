# 2026-09-21 | claude | rea | scope-conditions-module

## Task
Owner: write the two conversations' analysis — for each first-level 檢核範圍 item, how its helper
menus relate to its end level, and each layer's source — into a formal, clearly structured document.

## Done
- `doc add rea scope-conditions`: a three-layer model, the helper layer's two roles (修飾 / 切換) and
  its two switching mechanisms (`{Category}` substitution, `VisibleWhen` + the ui's `linkedOptions`),
  a thirteen-row overview, four types A–D by end-level source, and a "what to change where" table.
- field-map › 末層選項的來源 removed in favour of one pointer line, so the facts live once.

## Decisions & pitfalls
- A new module rather than growing field-map: field-map's subject is names; this is structure and
  provenance, and it would have pushed field-map toward its cap.
- Two line citations derived by counting from the field's `Value` line were one off (`:76`, `:146`);
  caught by grepping `OptionsApi` — cite from a grep, not from arithmetic.
- Only 101's `CaseTypeOptions` carries the `{Category}` `VisibleWhen`; the ui switches by
  `linkedOptions` either way, so the module says the ui does not depend on it.

## TODO
- Push `rea` (owner's shell).
