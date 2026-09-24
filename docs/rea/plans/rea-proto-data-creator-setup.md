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
Amended: 2026-09-23 — the 產出規則 re-issued again: ruleStartDate 2026-01-01 and ruleEndDate 2910-12-31 on every body, every specificConfig field of the owner's body schema written (null unless filled); the schema ingested; --start-date dropped
Shipped: 2026-09-23 — REA_PROTO_DATA_CREATOR@8c47ffe (the common values), @d52f321 (two citations fixed)
Amended: 2026-09-24 — the 產出規則's form.ruleEndDate is 9999-12-31, the value the back end stores anyway and the one checking looks for
Shipped: 2026-09-24 — REA_PROTO_DATA_CREATOR@949e7c4 (the end date)
Amended: 2026-09-24 — the 採集規則 and 產出規則 re-issued with 307 (MHCT_PAYLTYPE type 16 group 1) and 401 (IOPD_LMT); the validator also checks the values each generator reads
Shipped: 2026-09-24 — REA_PROTO_DATA_CREATOR@647ceaa (307), @eb198cc (401, refused), @63005f8 (README)

## Goal
`REA_PROTO_DATA_CREATOR` turns 資料表檔 — Oracle SQL Developer `.csv` exports keyed by 醫令 — into
RuleSave_batch_payload files, one per rule kind: a JSON array whose every item is one
`POST /api/v1/Rule/Save` body for one 醫令 carrying that rule kind alone, that `REA_PROTO_BE` accepts
on both `Rule/Save` and `Rule/SaveWork` and compiles to a workflow the generator keeps — so a
validation job on it ends `Completed`, not `Failed` on a hollow unit. Between the two sit the
資料採集規則: which columns select an 醫令 and how they fill `specificConfig`; this project writes them
down as versioned files the tool executes.

It rests on: the body is `SaveRuleRequest` = `form` + `ruleExpr` + `rules[]` (`REA_PROTO_BE@ba161ff
Services/ViewModels/RuleConfigurationDto.cs:9-60`, `:214-245`); what each rule kind must carry to
compile is in declare-verify › The fifteen rule kinds.

## Writes
`REA_PROTO_DATA_CREATOR (main)`: created empty by `clone` on 2026-09-22, no remote yet; every commit
is this plan's work. Nothing is written to `REA_PROTO_BE` or the Azure host: posting is the owner's.
The stack, as amended on 2026-09-23: Node.js ≥ 18, no dependencies, no tests; a body is a plain
object, `JSON.parse` / `JSON.stringify` are the schema. The 資料表檔 stay out of git; each 採集規則 is
one module `rules/r<code>.js` — `description` the rule, `collect()` applies it. The Python package
signed on 2026-09-22 was replaced wholesale; git keeps it.

## Steps
1. `chore: scaffold` — README, `.gitignore`, `package.json`, `src/`, `rules/`, `schemas/`,
   `data/in/.gitkeep`; the README names the Swagger host and `REA_PROTO_BE@ba161ff` as its sources.
2. `feat: schema` — a validator applies each rule kind's acceptance check, and the values each
   generator reads, before anything is written: they fail here, loudly, not in the job.
3. `feat: 302 rule` — `rules/r302.js` from `MHCT_PAYLIMIT`'s `LMT_AGE_*` columns, the worked example.
4. `feat: build` — `node src/cli.js build --in data/in --out data/out [--split]`: read every 資料表檔,
   run every rule, write the rule模組欄位資料檔 (one `.csv` per rule kind), then per rule kind one body
   per 醫令 — `selectedItems` = [醫令], the dates and every `specificConfig` field as the 產出規則's
   common rule says, `ruleExpr` = the code — validate, write the kind's array; `--split` splits it.
5. Further rule kinds as the owner supplies their mapping. Fourteen have landed; 303–306, and 401
   until its values are settled, are carried in
   [rea-proto-data-creator-acceptance](rea-proto-data-creator-acceptance.md).
6. `Shipped:` per landed commit; the repository doc and the remote are workspace work.

## Done when
The owner runs the build; posts one body to `Rule/Save` and `Rule/SaveWork` on the Azure host and
gets `success: true` on both; a `ValidationJob/Batch` for that 醫令 ends `Completed`, not `Failed`;
and every payload file has a `rules/r<code>.js` whose `description` reads as its 採集規則.
