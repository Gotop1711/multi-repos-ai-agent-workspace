# 2026-09-17 | claude | rea | disabled-conditions

## Task
Owner: the RuleSchema response now carries `Disabled` on some 檢核範圍 conditions (their capture of the
live response and its schema attached); the ui should reflect it.

## Done
- Ingested the capture as `rea-kernel/sources/2026-09-17-ruleschema-live.json.md` (`ecc4c965567f`).
- Kernel: `ConditionDescriptor.Disabled` ("顯示於 UI 但不可選", `de35a2f`), set by 201 alone on nine
  conditions. Save runs the translator, which implements only code 201 and the four conditions 201
  leaves enabled; anything else throws and returns 500 → rea-kernel › Save translates.
- UI: the flag survives the interceptor and the spreads, then `buildScopeFieldConfig` and
  `ScopeSetting`'s `fieldOptions` drop it → rule-editor › Disabled conditions.
- Plan **disabled-conditions** (draft): carry the flag, grey the option, count only enabled ones,
  refuse a stored disabled field before the request; mock and tests. Awaits the owner's signature.
- Deployment caught up with `458e663`: 201 no longer serves `ReferenceFields` — rea-kernel, rule-editor
  › Field names and plan ui-map-orphans item 1 updated.

## Decisions & pitfalls
- No write to `REA_UI`: the request is child-repo work, so it became a plan, not a commit.
- `ingest` refused the capture (1.01 MB, 4-space indent): extracted text over the 1 MB cap. `jq
  --indent 1` brought it to about 0.5 MB; checked equal to the original with `jq -S -c` + `cmp`.
- "Should a stored disabled condition block save?" looked like a UX preference until the translator
  showed it 500s; the plan defaults to blocking, and the owner can overturn that before signing.
- The prototype's `disabled` is input-level (locking), not the kernel's condition-level flag — don't
  let plan field-locking absorb this one.

## TODO
- Owner: confirm the plan's four decisions (branch `debug-api`), then sign.
- Noted, not filed: 101's `CaseTypeOptions` has a `VisibleWhen` no other code has; the add-on board
  reads 101's list.
- Push: workspace `rea`; `REA_UI` `debug-api` `9f091c3` still unpushed from the last session.
