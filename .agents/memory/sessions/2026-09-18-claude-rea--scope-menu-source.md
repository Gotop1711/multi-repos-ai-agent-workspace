# 2026-09-18 | claude | rea | scope-menu-source

## Task
Owner: find where the first-level 欄位 menu of 檢核範圍 (案件分類 … 僅機械手臂輔助手術), served in
`GET /api/v1/RuleSchema`, comes from — compared with `Options/PxxtCode/{SubSys}/{DataType}`, whose
path says its source. REA_PROTO excluded on the owner's word mid-session.

## Done
- rea-kernel › Where the 檢核範圍 menu comes from: `RuleCode.Conditions`, a literal in each
  `_<code>.cs`, thirteen identical across twenty files, one commit (`0ba3acc`, 2026-06-15), static
  singleton registry, no table or store behind it; the `OptionsApi` contrast traced to Oracle
  `PXXT_CODE` through controller → DTO → DAO with its filters and cache.
- rule-editor › Schema → form: one line for the ui path (store → dialog → `buildScopeFieldConfig` →
  `ScopeSetting.vue` select); the ui adds nothing.

## Decisions & pitfalls
- field-map already tabulates the thirteen; only their provenance was missing, so it went into the
  kernel repo doc rather than a new module.
- Checked identity by hashing each file's top-level `Value`/`Label` pairs and diffing 101's whole
  `Conditions` block against 102's (one `VisibleWhen` apart) — reading twenty files by eye would not
  have proven it.
- REA_UI is now `5721638` (`develop`, the merge of `debug-ui`); rule-editor still cites `411c809`
  elsewhere — the lines quoted here were read at `5721638`.

## TODO
- Push `rea` (owner's shell).
