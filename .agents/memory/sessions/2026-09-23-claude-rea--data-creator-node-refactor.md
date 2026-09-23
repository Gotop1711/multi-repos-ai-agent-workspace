# 2026-09-23 | claude | rea | data-creator-node-refactor

## Task
Owner: the stack ruling was missed — `REA_PROTO_DATA_CREATOR` must be Node.js. Refactor the whole
child: smallest architecture, no tests, ordinary JavaScript, DRY / YAGNI / single responsibility.
Update the plan and the workspace documents with it.

## Done
- `REA_PROTO_DATA_CREATOR@9b89624`: one commit replacing the Python package with five files —
  `src/csv.js` (read a 資料表檔, write the rule模組欄位資料檔), `src/validate.js`, `src/build.js`,
  `src/cli.js`, `rules/r302.js`. Node ≥ 18, no dependencies. 803 lines against 1 725.
- Same output on the real export: 71 bodies, 38 Y / 32 M / 1 D, `validate` clean. Error paths tried by
  hand in scratch: a 302 without `referenceDate`, a 305, a malformed `ruleExpr`, an unknown scope id,
  an inverted row (nothing written, exit 1), a bad `--start-date`, a missing table.
- Plan: `Amended:` for the stack, a second `Shipped:`, and the body rewritten to Node — a plan is
  maintained state, so the steps now describe the project as it is. Repository doc and the two index
  lines likewise.

## Decisions & pitfalls
- A body is a plain object in JS, so the dataclasses, `to_json`/`from_json` and the camelCase mapping
  all went: `JSON.parse` / `JSON.stringify` are the schema. That is most of the deletion.
- The per-kind acceptance checks became one `REQUIRED_FIELDS` table plus three special cases (301's
  mainSetting value, 302's unit and min ≤ max, the referenceDate keys) — the Python had fifteen
  branches saying the same thing.
- `checkExpression` is shared by `ruleExpr` and `scopeRuleExpr`; its messages name no field, the caller
  does — the first version said "ruleExpr: ruleExpr: …".
- Dropping the tests also dropped the fixture: the owner's export is the only input now. A rule's
  worked example lives in its `description` instead.
- `Amended:` is the right gate for a stack change inside the write set — no new plan, and the
  `Signed:` line stands.

## TODO
- Owner: post one body to `Rule/Save` and `Rule/SaveWork`, run a `ValidationJob`, then `Verified:`.
- Owner: a remote for the child; the `LMT_SEX` → 301 and `LMT_TYPE_CODE` → rule kind mappings.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).
