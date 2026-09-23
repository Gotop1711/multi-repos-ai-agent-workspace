# 2026-09-23 | claude | rea | data-creator-node-refactor

## Task
Owner: the stack ruling was missed — `REA_PROTO_DATA_CREATOR` must be Node.js. Refactor the whole
child: smallest architecture, no tests, ordinary JavaScript, DRY / YAGNI / single responsibility.
Then record, as a plan, the TODO list that is the owner's to act on.

## Done
- `REA_PROTO_DATA_CREATOR@9b89624`: one commit replacing the Python package with five files —
  `src/csv.js`, `src/validate.js`, `src/build.js`, `src/cli.js`, `rules/r302.js`. Node ≥ 18, no
  dependencies. 803 lines against 1 725. Same output on the real export: 71 bodies, 38 Y / 32 M /
  1 D, `validate` clean. Error paths tried by hand in scratch, not by tests.
- Plan setup: `Amended:` for the stack, a second `Shipped:`, body rewritten to Node. Repository doc
  and both index lines likewise.
- `plan new rea rea-proto-data-creator-acceptance` (draft): what only the owner can do — the three
  acceptance calls on the Azure host ending in the setup plan's `Verified:`, then the remote, the
  301 and `MHCT_PAYLTYPE` mappings, the README's 名詞 wording.

## Decisions & pitfalls
- A body is a plain object in JS, so the dataclasses, `to_json`/`from_json` and the camelCase mapping
  all went: `JSON.parse` / `JSON.stringify` are the schema. That is most of the deletion.
- The per-kind acceptance checks became one `REQUIRED_FIELDS` table plus three special cases; the
  Python had fifteen branches saying the same thing. `checkExpression` is shared by `ruleExpr` and
  `scopeRuleExpr`, and its messages name no field — the first version said "ruleExpr: ruleExpr: …".
- Dropping the tests dropped the fixture too: the owner's export is the only input now.
- `Amended:` is the right gate for a stack change inside the write set — no new plan, `Signed:`
  stands. But the *remaining* work needed one: the setup plan goes away at `plan done`, so its step 5
  points at the acceptance plan rather than both owning it.
- The acceptance plan's steps 1–4 need no signature (they are the owner's own calls); 5–8 do.
- That plan is written in Chinese on the owner's word; every other document stays English, and so
  does its line in the index. Do not "fix" it back.

## TODO
- Owner: the acceptance plan, steps 1–8; its `Signed:` before any of steps 5–8 is written.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).
