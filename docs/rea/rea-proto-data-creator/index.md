# rea / rea-proto-data-creator

Repository `REA_PROTO_DATA_CREATOR` (`projects/rea_proto_data_creator`, access write, `remote: none`):
a new project created empty by `clone` on 2026-09-22 and filled by
[rea-proto-data-creator-setup](../plans/rea-proto-data-creator-setup.md); this disk holds its only
copy until the owner gives it a remote. Every citation below is `REA_PROTO_DATA_CREATOR@d52f321`
unless another repo is named. The owner's documents of 2026-09-23, under `sources/`:
`2026-09-23-data-creation-definitions.txt.md@2514808960d5` (the terms),
`2026-09-23-data-creation-collection-rules.txt.md@043e43c4e9a2` (資料採集規則: which rows),
`2026-09-23-data-creation-payload-item-rules.txt.md@4454172deb2d` (產出規則: which fields, and what
every body carries) and `2026-09-23-post-rulesave-request-body-schema.json.md@e0dcec1e2d33` (the
body's fields as the Swagger host shows them).

## What it is, in three lines

- Reads 資料表檔 — Oracle SQL Developer csv exports of NHIA 支付標準 tables — from `data/in/`.
- Runs every 資料採集規則: `rules/r<code>.js` — `description` is the rule, `collect()` applies it.
- Writes one RuleSave_batch_payload per rule kind — a `Rule/Save` body per 醫令 carrying that kind
  alone — after validating each against what `REA_PROTO_BE`'s generators accept (`README.md:3-13`).

## Run

- Node.js ≥ 18, no dependencies, no tests (`package.json:7-9`). `node src/cli.js build --in data/in
  --out data/out [--split]`; `validate <file>…` checks hand-made bodies; `rules` prints every 採集規則
  (`src/cli.js:95`).
- `data/in/*` and `data/out/` are gitignored (`.gitignore:2-5`); the owner's two 資料表檔 in
  `data/in/` are the only input. No server, no credentials: posting is the owner's, `Rule/Save` then
  `Rule/SaveWork` (`README.md:71-72`).

## The rules

| Code | 資料表檔 | Selects (rows in force) | Fills | 醫令 |
|---|---|---|---|---|
| 101–104 | `MHCT_PAYLTYPE` | `LMT_TYPE_CODE` 13, group 1–4 | `mainSetting` = the 醫令's `LMT_ITEM`s | 185 / 145 / 199 / 8 |
| 106, 201, 204 | `MHCT_PAYLTYPE` | type 1, 3, 14 | same | 194 / 1 / 192 |
| 202 | `MHCT_PAYLTYPE` | type 7 | same, plus `doctorTypes` = ["0" + `ENAME`], `employmentType` 01 | 383 |
| 203 | `MHCT_PAYLIMIT` | `PRSN_TYPE` not empty | `mainSetting` = it split on `,` | 79 |
| 205, 206 | `MHCT_PAYLIMIT` | every 醫令 | `mainSetting` 2 if `FULL_TIME_DOC` / `_EXEC` else 1; `doctorTypes` 02 / 01; `employmentType` 01 | 5 275 |
| 301 | `MHCT_PAYLIMIT` | `LMT_SEX` not empty | `mainSetting` = [`LMT_SEX`] | 19 |
| 302 | `MHCT_PAYLIMIT` | an `LMT_AGE_*` range | `unit`, `min`, `max` | 71 |

Common to every body, the 產出規則's rule (`src/collect.js:10-12`; `src/build.js:14`, `:44`):
`form.ruleStartDate` `2026-01-01`, `form.ruleEndDate` `2910-12-31`, `specificConfig.referenceDate`
`["executionDate"]`, and every other `specificConfig` field the owner's schema lists written as `null`
(`schemas/POST_RuleSave_request-body_Schema.json`). A group code is matched with its leading zeros
stripped (`src/collect.js:30`). Each module's `description` (`rules/r<code>.js:9`) is the rule as
written, its columns numbered against `schemas/<TABLE>.csv`; a rejected row is an error, never a guess
(`README.md:100-119`).

## Storage

- **In**: `data/in/<TABLE>_Data.csv`; the row in force has `LMT_E_DATE` = `2910-12-31`, the owner's
  common 採集規則 (`src/csv.js:9`, `:89`).
- **Out**: `data/out/rule_fields/r<code>.csv` — the rule模組欄位資料檔; `data/out/RuleSave_batch_payload/`
  `r<code>.json`, one per rule kind, `ruleExpr` the code and `rules[]` one entry (`src/build.js:17`,
  `:44`); `data/out/items/r<code>/<醫令>.json` with `--split`. A kind's file is written only when every
  body of it passes; the other kinds are unaffected (`:131`).
- On the 2026-09-22 exports: 13 files, 12 026 bodies, every file `validate` clean; `r302.json` is the
  hand-made batch of 2026-09-22 (log 302-batch-prediction), reproduced.

## Integration

- **Its output is `REA_PROTO_BE`'s `SaveRuleRequest`, field for field** (`README.md:178-181`;
  `REA_PROTO_BE@ba161ff Services/ViewModels/RuleDto.cs:6-22`, `RuleConfigurationDto.cs:9-245`) — also the
  Azure Swagger host's ([rea-proto-be](../rea-proto-be/index.md) › Integration); the validator mirrors
  each generator's acceptance check ([declare-verify](../declare-verify.md) › Part 2).
- **The body's dates and the back end.** A start date earlier than the 醫令's latest stored version is
  refused (`Services/RuleService.cs:261-274`, `:424-437`); the end date is stored as `9999-12-31`
  whatever the body says, on `Save` and on `SaveWork` (`:339`, `:413`) — which is what lets checking
  find the rule, since it reads the `9999-12-31` version (`Services/ValidationJobService.cs:572-578`).
- **The files are for one rule kind at a time.** One rule document per 醫令 per start date, and a
  `Save` with the same start date replaces its `rules[]` outright (`:283-298`;
  [declare-verify](../declare-verify.md) › Saving a rule): two kinds' bodies for one 醫令 leave the
  later one alone. `validate` warns when one 醫令 is in two files (`README.md:74-78`).
- **Recorded, not handled, on the owner's word** ([acceptance plan](../plans/rea-proto-data-creator-acceptance.md)
  step 6): 205 and 206 go on every 醫令, and their generators never read `mainSetting` — with
  `doctorTypes` 02 / 01 and `employmentType` 01 they compile the 專任 check for all 5 275
  (`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`, `FullTimeDoctorExecutionRuleGenerator.cs:24-38`),
  though only 64 / 41 rows carry the flag; the form labels `mainSetting` 1 無限制 / 2 除山地離島地區之外
  基層院所 (`REA_PROTO@3fdf47c tests/mock/api/rulesSpecificSetting.json:4711`).
- 202's `employmentType` 01 (專任, `Services/Rules/SpecialistRuleGenerator.cs:63-90`) and 101–104's
  group codes were the owner's rulings; 303–307 and 401 have no rules yet.
