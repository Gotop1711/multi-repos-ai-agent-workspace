# rea — rea-proto-data-creator-setup

Writes: REA_PROTO_DATA_CREATOR (main)
Status: shipped
Signed: gotop1711 — 2026-09-22
Shipped: 2026-09-22 — REA_PROTO_DATA_CREATOR@0c6d271 (scaffold), @ef6f040 (schema), @8ba8cfe (302 rule), @321dc12 (build)
Amended: 2026-09-23 — the stack is Node.js, not Python; smallest architecture, no tests (the owner, in session)
Shipped: 2026-09-23 — REA_PROTO_DATA_CREATOR@9b89624 (the same pipeline in five JavaScript files)

## Goal
`REA_PROTO_DATA_CREATOR` turns 資料表檔 — Oracle SQL Developer `.csv` exports keyed by 醫令 — into a
RuleSave_batch_payload: a JSON array whose every item is one `POST /api/v1/Rule/Save` body for one
醫令 with its rule kinds set, that `REA_PROTO_BE` accepts on `Rule/Save` and `Rule/SaveWork`, and
that compiles to a workflow every generator keeps — so a validation job on it ends `Completed`
instead of failing on a hollow unit. Between the two sit the 資料採集規則: per rule kind, which
columns of which 資料表檔 select an 醫令 and how they fill `specificConfig` and the scope. They
exist nowhere on disk today; this project writes them down as versioned files the tool executes, so
the rule模組欄位資料檔 is a reproducible intermediate, not a hand-made one.

It rests on: the body is `SaveRuleRequest` = `form` + `ruleExpr` + `rules[]` (`REA_PROTO_BE@ba161ff
Services/ViewModels/RuleConfigurationDto.cs:9-60`, `:214-245`), which the owner's Swagger host
serves field for field
(`docs/rea/rea-proto-be/sources/2026-09-22-nhideclareverify-swagger-live.json.md@25ea24c3d433`
L1303); what each rule kind must carry to compile, and the three `referenceDate` keys, are in
declare-verify › The fifteen rule kinds; the 71-row `MHCT_PAYLIMIT` → 302 batch of 2026-09-22 (log
302-batch-prediction) is the worked example and the first 採集規則 — its open `referenceDate`
question is answered here.

## Writes
`REA_PROTO_DATA_CREATOR (main)`: created empty by `clone` on 2026-09-22 (`@unborn`), no remote yet;
every commit is this plan's work. Nothing is written to `REA_PROTO_BE` (read-only) or to the Azure
host: the tool produces a file; posting it is the owner's, from Swagger or curl.

The stack, as amended on 2026-09-23: Node.js ≥ 18, no dependencies, no tests, the smallest
architecture that carries the pipeline — a body is a plain object, so `JSON.parse` / `JSON.stringify`
are the schema and there is no model layer. The 資料表檔 stay out of git (`data/in/` and `data/out/`
ignored — exports of NHIA tables); each 採集規則 is one module `rules/r<code>.js` whose exported
`description` is the human-readable rule (table, key column, selecting columns, column → field
mapping) and whose `collect()` applies it. The Python package signed on 2026-09-22 was replaced
wholesale; git keeps it.

## Steps
1. `chore: scaffold` — README (the owner's definitions, the pipeline, how to run), `.gitignore`,
   `package.json`, `src/`, `rules/`, `schemas/<TABLE>.csv` from the owner's schema workbooks,
   `data/in/.gitkeep`. The README names the Swagger host as the schema's source and
   `REA_PROTO_BE@ba161ff` as the checked code.
2. `feat: schema` — a validator applies each rule kind's acceptance check before anything is
   written: a 302 without `referenceDate` fails here, loudly, not in the job; so do a hollow rule
   kind, a malformed `ruleExpr` and a code without a generator. Fields the back end stores but never
   reads (`resultAction`, `expr`, `updatedAt`, `operatorMin`/`Max`, `referenceConditions`, the
   2026/07/03 ones) are allowed, never required.
3. `feat: 302 rule` — `rules/r302.js` from `MHCT_PAYLIMIT`'s `LMT_AGE_*` columns as done by hand on
   2026-09-22, `referenceDate` = `executionDate` (the owner, at signing).
4. `feat: build` — `node src/cli.js build --in data/in --out data/out --start-date … [--split]`:
   read every 資料表檔, run every rule, write the rule模組欄位資料檔 (one `.csv` per rule kind),
   group by 醫令 into one item each — `form.selectedItems` = [醫令], `ruleStartDate` from the flag
   (the back end refuses a start earlier than an item's active version), header lists as the rule
   says or empty, `ruleExpr` = the codes joined by 且 unless a rule says otherwise — validate, write
   the array; `--split` adds one file per item for a Swagger paste.
5. One commit per further rule kind as the owner supplies its 資料表檔 and mapping: the rule's
   `description`, its `collect()`. Rule kinds without a generator (105, 303–306) are refused. The
   ones still open are carried forward to
   [rea-proto-data-creator-acceptance](rea-proto-data-creator-acceptance.md), with the owner's
   acceptance run.
6. `Shipped:` per landed commit. A repository doc (`doc add rea rea-proto-data-creator`) and the
   remote URL in `catalog/repos.yaml` are workspace work outside this write set, once the project
   runs.

## Done when
The owner runs the build on the real exports and gets a JSON array; posts one item to `Rule/Save`
and `Rule/SaveWork` on the Azure host and gets `success: true` on both; a `ValidationJob/Batch` for
a declaration batch of that 醫令 ends `Completed`, not `Failed`; and every rule kind in the payload
has a `rules/r<code>.js` whose `description` a reviewer can read as its 採集規則.
