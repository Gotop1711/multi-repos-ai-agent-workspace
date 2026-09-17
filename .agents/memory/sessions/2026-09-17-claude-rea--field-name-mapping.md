# 2026-09-17 | claude | rea | field-name-mapping

## Task
Owner: how do `REA_UI` and `REA_kernel` name the same field in each rule dialog, and how do the two
correspond? Then: put the correspondence in its own document, listing every field and every gap.

## Done
- **field-map** (new module): all 58 MainFields, the 5 reference fields, 307's 4 sub-fields and the
  13 conditions, kernel name against ui name, plus the names with no counterpart. Counts checked
  against the parsed source, not transcribed.
- rule-editor gains **Field names**: the correspondence is the kernel's `Value` with the first ASCII
  letter flipped and nothing else, in two reversible layers; `options[].value` never converts; group
  ids are the prototype's; a key naming no served field is inert. Replaces a `Schema → form` line.
- rea-kernel: 201 lost its whole `ReferenceFields` between `2ff26b0` and `458e663` — the only
  field-name change between those shas; the 2026-09-11 deployment still served it.
- rea-ui: `debug-ui` is rebased upstream; `bdba317` ≡ `f4d9e38` and `8281dbb` ≡ `411c809` by tree,
  reaching from no ref. Look-here shas now say `411c809`; `Shipped:` shas left as written.
- Plan **ui-map-orphans** (draft): 201 `referenceDates`, 307 `prefixLength` + `monthUnit`, and
  `prefixLen` / `prefixRange` in four scope conditions — why 檢核範圍's 前 N 碼 never rendered.
- On the owner's word, `main`: module cap 150 → 300 (`82d8461`), `rea` rebased onto it.

## Decisions & pitfalls
- **`--contains` does not see a squash.** `git for-each-ref --contains 876cd3d refs/remotes` came
  back empty and I called the commit orphaned; it had merged as `f49ea00`. Compare trees first.
- A ui-map key matching nothing is inert, not an error: `applyUIMapToBlock` looks the map up *by* the
  served field id and drops what it cannot find. "The ui supports X" needs the served schema beside
  it — the map alone proves nothing.
- The cap fought the document: enumerating 80 rows does not fit in 150, and splitting would have put
  one subsystem's facts in two files. Raising the cap was the owner's call, not a workaround.
- A second session held `docs/rea/` for much of this one and committed with `git add -A`, sweeping
  this log and an empty plan skeleton into its commit; the owner then had me reword it (`b63ca3b`).
  Two agents in one workspace need small edits and prompt commits, not long holds.

## TODO
- Owner: the ui-map-orphans rulings — 201's 參考日期 and 檢核範圍's 前 N 碼 look like kernel gaps, the
  307 widths like dead copy. `main` and `rea` are both unpushed; `v1` / `rea-v1` keep the old cap
  until rebased.
