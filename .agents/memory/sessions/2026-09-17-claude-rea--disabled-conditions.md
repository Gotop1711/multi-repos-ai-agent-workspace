# 2026-09-17 | claude | rea | disabled-conditions

## Task
Owner: the RuleSchema response now carries `Disabled` on some 檢核範圍 conditions (capture attached);
the ui should reflect it.

## Done
- Ingested the capture as `rea-kernel/sources/2026-09-17-ruleschema-live.json.md` (`ecc4c965567f`).
- Kernel: `ConditionDescriptor.Disabled` (`de35a2f`), set by 201 alone on nine conditions; the
  translator implements only 201's other four, anything else 500s at save → rea-kernel.
- Plan **disabled-conditions** drafted, moved to `debug-ui` on the owner's word, signed.
- Shipped `REA_UI@392230e` (debug-ui, unpushed): the six steps as written. vitest 1091 pass (6 new,
  5 of them fail against `411c809`), lint clean. rule-editor › Disabled conditions re-cited there.
- Deployment caught up with `458e663`: 201 no longer serves `ReferenceFields` — rea-kernel,
  rule-editor › Field names and plan ui-map-orphans item 1 updated.

## Decisions & pitfalls
- The request was child-repo work, so it became a plan first; no `REA_UI` write before `Signed:`.
- The branch was first drafted as a guess; the owner wants `debug-ui`. Ask, don't infer it from the
  last plan — and re-cite after a branch change: the same code sat 4–11 lines apart.
- `ingest` refused the capture: extracted text over the 1 MB cap. `jq --indent 1` → ~0.5 MB, checked
  equal to the original with `jq -S -c` + `cmp`.
- Blocking save on a stored disabled condition looked like a UX preference until the translator
  showed it 500s.
- A form rule alone flags a stored disabled row only after 儲存; `el-form-item`'s `error` prop shows
  it on open, as Done-when asks — both are used.
- The mock spelled `AssociatedItems`: its UI map never applied offline, and 201's nine would have
  been eight. Fixed in the same commit (the file is in the write set).
- The prototype's `disabled` is input-level (locking), not this condition-level flag.

## TODO
- Owner: the browser check in Done-when, then `Verified:`. The `Signed:` line still reads `<name>`.
- Noted, not filed: 101's `CaseTypeOptions` has a `VisibleWhen` no other code has; the add-on board
  reads 101's list.
- Push: workspace `rea`; `REA_UI` `debug-ui` `392230e`.
