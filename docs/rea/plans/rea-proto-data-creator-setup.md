# rea — rea-proto-data-creator-setup

Writes: REA_PROTO_DATA_CREATOR (main)
Status: shipped
Signed: gotop1711 — 2026-09-22
Shipped: 2026-09-22 — REA_PROTO_DATA_CREATOR@0c6d271 (scaffold), @ef6f040 (schema), @8ba8cfe (302 rule), @321dc12 (build)
Amended: 2026-09-23 — the stack is Node.js, not Python; smallest architecture, no tests (the owner, in session)
Shipped: 2026-09-23 — REA_PROTO_DATA_CREATOR@9b89624 (the same pipeline in five JavaScript files)
Amended: 2026-09-23 — the owner's 資料採集規則 and 產出規則 ingested (sources/2026-09-23-data-creation-*); the rule kinds they define are written, committed by source table rather than one each
Shipped: 2026-09-23 — REA_PROTO_DATA_CREATOR@e4eba57 (101–104, 106, 201, 204), @dc509aa (203, 205, 206, 301), @369fbfc (README)
Amended: 2026-09-23 — the 採集規則 and 產出規則 re-issued and re-ingested: 101–104 name their group 1–4, matched with leading zeros stripped; 202's employmentType is 01
Shipped: 2026-09-23 — REA_PROTO_DATA_CREATOR@d407653 (202, the group codes), @c0ef280 (README)
Amended: 2026-09-23 — the output is one RuleSave_batch_payload per rule kind, each body one 醫令 carrying that kind alone; the combined one-body-per-醫令 file is dropped
Shipped: 2026-09-23 — REA_PROTO_DATA_CREATOR@d493386 (per-kind payloads)

## Goal
`REA_PROTO_DATA_CREATOR` turns 資料表檔 — Oracle SQL Developer `.csv` exports keyed by 醫令 — into
RuleSave_batch_payload files, one per rule kind: a JSON array whose every item is one
`POST /api/v1/Rule/Save` body for one 醫令 carrying that rule kind alone, that `REA_PROTO_BE` accepts
on `Rule/Save` and `Rule/SaveWork` and compiles to a workflow the generator keeps — so a validation
job on it ends `Completed`, not `Failed` on a hollow unit. Between the two sit the 資料採集規則: per rule kind, which
columns of which 資料表檔 select an 醫令 and how they fill `specificConfig` and the scope. They
exist nowhere on disk today; this project writes them down as versioned files the tool executes, so
the rule模組欄位資料檔 is a reproducible intermediate, not a hand-made one.

It rests on: the body is `SaveRuleRequest` = `form` + `ruleExpr` + `rules[]` (`REA_PROTO_BE@ba161ff
Services/ViewModels/RuleConfigurationDto.cs:9-60`, `:214-245`), which the owner's Swagger host
serves field for field
(`docs/rea/rea-proto-be/sources/2026-09-22-nhideclareverify-swagger-live.json.md@25ea24c3d433`
L1303); what each rule kind must carry to compile, and the three `referenceDate` keys, are in
declare-verify › The fifteen rule kinds; the 71-row `MHCT_PAYLIMIT` → 302 batch of 2026-09-22 (log
302-batch-prediction) is the worked example and the first 採集規則.

## Writes
`REA_PROTO_DATA_CREATOR (main)`: created empty by `clone` on 2026-09-22 (`@unborn`), no remote yet;
every commit is this plan's work. Nothing is written to `REA_PROTO_BE` (read-only) or to the Azure
host: the tool produces a file; posting it is the owner's, from Swagger or curl.

The stack, as amended on 2026-09-23: Node.js ≥ 18, no dependencies, no tests, the smallest
architecture that carries the pipeline — a body is a plain object, `JSON.parse` / `JSON.stringify` are
the schema. The 資料表檔 stay out of git (`data/in/`, `data/out/` ignored); each 採集規則 is one module
`rules/r<code>.js` whose exported `description` is the human-readable rule and whose `collect()`
applies it. The Python package signed on 2026-09-22 was replaced wholesale; git keeps it.

## Steps
1. `chore: scaffold` — README, `.gitignore`, `package.json`, `src/`, `rules/`, `schemas/<TABLE>.csv`
   from the owner's workbooks, `data/in/.gitkeep`; the README names the Swagger host as the schema's
   source and `REA_PROTO_BE@ba161ff` as the checked code.
2. `feat: schema` — a validator applies each rule kind's acceptance check before anything is
   written: a 302 without `referenceDate` fails here, loudly, not in the job; so do a hollow rule
   kind, a malformed `ruleExpr` and a code without a generator. Fields the back end stores but never
   reads are allowed, never required.
3. `feat: 302 rule` — `rules/r302.js` from `MHCT_PAYLIMIT`'s `LMT_AGE_*` columns as done by hand on
   2026-09-22, `referenceDate` = `executionDate` (the owner, at signing).
4. `feat: build` — `node src/cli.js build --in data/in --out data/out --start-date … [--split]`:
   read every 資料表檔, run every rule, write the rule模組欄位資料檔 (one `.csv` per rule kind),
   then per rule kind one body per 醫令 — `form.selectedItems` = [醫令], `ruleStartDate` from the
   flag (the back end refuses a start earlier than an item's active version), header lists empty,
   `ruleExpr` = the code — validate, write the kind's array; `--split` adds one file per 醫令.
5. Further rule kinds as the owner supplies their mapping: the rule's `description`, its
   `collect()`. Twelve landed on 2026-09-23 from the owner's documents; 303–307 and 401 (no rules
   yet) are carried in [rea-proto-data-creator-acceptance](rea-proto-data-creator-acceptance.md).
6. `Shipped:` per landed commit; the repository doc and the remote in `catalog/repos.yaml` are
   workspace work outside this write set.

## Done when
The owner runs the build on the real exports and gets a JSON array; posts one item to `Rule/Save`
and `Rule/SaveWork` on the Azure host and gets `success: true` on both; a `ValidationJob/Batch` for
a declaration batch of that 醫令 ends `Completed`, not `Failed`; and every payload file has a
`rules/r<code>.js` whose `description` a reviewer can read as its 採集規則.
