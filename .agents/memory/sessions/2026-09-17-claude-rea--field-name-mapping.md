# 2026-09-17 | claude | rea | field-name-mapping

## Task
Owner: how do `REA_UI` and `REA_kernel` name the same field in each rule dialog — is there a
difference, and what is the correspondence?

## Done
- Answered in session; **nothing filed** — another session held `docs/rea/` (below).
- The rule: the kernel's `Value` with the first ASCII letter flipped, nothing else, in two reversible
  layers (`ucFirst(lcFirst(x)) === x`) — the axios interceptor deep-transforms every key on kernel
  paths (`REA_UI@411c809 src/api/caseTransform.js:16-36`, `src/api/interceptors.js:18-33`), then
  `normalizeFieldIds` lowers the identifier *values* (`src/api/modules/rules/index.ts:72-95`).
  `options[].value` is data, untouched both ways; only `condition.field` follows the identifiers. A
  saved `Main` key is therefore the kernel's PascalCase again.
- Kernel `2ff26b0` and the 2026-09-11 live schema agree field for field on all twenty codes.
- **The ui speaks two vocabularies.** Field ids follow the kernel; `subGroups` group ids are the
  **prototype's** sub-block ids (`REA_PROTO@3fdf47c rulesSpecificSetting.json`: 304/305 1:1, 303
  minus `Block`, 306's `code`/`prefix`/`range` given a `diagnosis` prefix). The prototype names the
  *fields* differently again — the kernel's `BodyPartPrefixLen` is its `bodyPartPrefixRange`.
- Eight ui-map keys name no served field, in five places: 105 `mainSetting` (`Note`), 205/206
  `doctorRole` + `employmentType`, 307 `prefixLength` + `monthUnit`, and `prefixLen` / `prefixRange`
  in four scope conditions (`ruleUIConfig.ts:466-467,484-485,503-504,555-556`) — the last two are
  untracked, the rest carried by plans 205-main-fields / field-locking and rule-codes.

## Decisions & pitfalls
- A ui-map key matching nothing is **inert, not an error**: `applyUIMapToBlock` looks the map up *by
  the served field id* and `.filter(Boolean)`s what it misses (`ruleSchemaUtils.js:111,155`). The
  cost is a silently absent input — the scope 前N碼 box has never rendered in four conditions.
- `debug-ui` was rebased upstream: `bdba317` and `8281dbb` no longer reach from `origin/debug-ui`,
  though their trees equal `f4d9e38` and `411c809`. Docs citing them will not `restore` from a clone.
- Regex over the kernel's C# worked only because option entries are inline while a field's `Value`
  sits on its own line — brittle. Every result was cross-checked against the ingested live JSON
  derivative, which agreed exactly; trust that one.

## TODO
- Filing deferred by the owner while another session edits `docs/rea/`: the naming rule into
  rule-editor › Schema → form; `plan new` for the 307 and scope orphans; refresh the `bdba317` /
  `8281dbb` citations; then the closeout commit.
