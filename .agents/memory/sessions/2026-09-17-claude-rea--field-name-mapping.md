# 2026-09-17 | claude | rea | field-name-mapping

## Task
Owner: how do `REA_UI` and `REA_kernel` name the same field in each rule dialog, and how do the two
correspond?

## Done
- rule-editor gains **Field names**: the correspondence is the kernel's `Value` with the first ASCII
  letter flipped and nothing else, in two reversible layers; `options[].value` never converts; group
  ids are the prototype's; a key naming no served field is inert. Replaces a `Schema → form` line.
- rea-kernel: 201 lost its whole `ReferenceFields` between `2ff26b0` and `458e663` — the only
  field-name change between those shas, and the deployment of 2026-09-11 still served it.
- rea-ui: `debug-ui` is rebased upstream; `bdba317` ≡ `f4d9e38` and `8281dbb` ≡ `411c809` by tree,
  reaching from no ref. Look-here shas now say `411c809`; historical `Shipped:` shas left as
  written. Test line refreshed: 47 files / 1085 tests, run.
- Plan **ui-map-orphans** (draft): the four untracked keys that name nothing — 201 `referenceDates`,
  307 `prefixLength` + `monthUnit`, and `prefixLen` / `prefixRange` in four scope conditions, which
  is why 檢核範圍's 「前 N 碼」 box has never rendered.

## Decisions & pitfalls
- **`--contains` does not see a squash.** I read `git for-each-ref --contains 876cd3d refs/remotes`
  coming back empty as "deleted without merging" and told the owner so; it had merged as `f49ea00`,
  content-identical. Compare trees, or look for the message, before calling a commit orphaned.
- A ui-map key matching nothing is inert, not an error: `applyUIMapToBlock` looks the map up *by* the
  served field id and drops what it cannot find (`ruleSchemaUtils.js:111`, `:155`). Every "the ui
  supports X" claim therefore needs the served schema beside it — the map alone proves nothing.
- Regex over the kernel's C# worked only because option entries are inline while a field's `Value`
  sits on its own line — brittle. Cross-check against the ingested live JSON derivative instead.
- A second session held `docs/rea/` for most of this one. The owner said to wait; it committed, I
  filed, and it then committed again with `git add -A`, sweeping this log and an empty plan skeleton
  into `7cbd3c2`. Two agents in one workspace need small edits and prompt commits, not long holds.

## TODO
- Owner: the ui-map-orphans rulings — 201's 參考日期 and 檢核範圍's 前 N 碼 look like kernel gaps, the
  307 widths like dead copy.
- [workspace] A closeout commit staging everything sweeps a concurrent session's work, unnoticed by
  `check`. Worth a rule, or staging only the session's own paths.
