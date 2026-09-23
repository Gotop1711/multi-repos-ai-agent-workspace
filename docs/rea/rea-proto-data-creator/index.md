# rea / rea-proto-data-creator

Repository `REA_PROTO_DATA_CREATOR` (`projects/rea_proto_data_creator`, access write, `remote: none`):
a new project created empty by `clone` on 2026-09-22 and filled by
[rea-proto-data-creator-setup](../plans/rea-proto-data-creator-setup.md); this disk holds its only
copy until the owner gives it a remote. Every citation below is `REA_PROTO_DATA_CREATOR@d493386`
unless another repo is named. The owner's three documents of 2026-09-23, under `sources/`:
`2026-09-23-data-creation-definitions.txt.md@2514808960d5` (the terms),
`2026-09-23-data-creation-collection-rules.txt.md@043e43c4e9a2` (資料採集規則: which rows) and
`2026-09-23-data-creation-payload-item-rules.txt.md@995741542eda` (產出規則: which fields).

## What it is, in three lines

- Reads 資料表檔 — Oracle SQL Developer csv exports of NHIA 支付標準 tables — from `data/in/`.
- Runs every 資料採集規則: `rules/r<code>.js`, whose exported `description` is the rule a reviewer
  reads and whose `collect()` applies it; `src/collect.js` is what they share — the common
  `referenceDate` (`:8`), `MHCT_PAYLTYPE` by type and group, one condition per 醫令 (`:21`),
  `MHCT_PAYLIMIT` row by row (`:61`).
- Writes one RuleSave_batch_payload per rule kind — a `Rule/Save` body per 醫令 carrying that kind
  alone (the owner's ruling of 2026-09-23) — after validating each body against what `REA_PROTO_BE`'s
  generators accept (`README.md:3-13`).

## Run

- Node.js ≥ 18, no dependencies, nothing to install, no tests (`package.json:7-9`).
- `node src/cli.js build --in data/in --out data/out --start-date YYYY-MM-DD [--split]`;
  `validate <file>…` runs the same checks on hand-made bodies; `rules` prints every 採集規則
  (`src/cli.js:102`).
- The exports stay out of git — `data/in/*` and `data/out/` are ignored (`.gitignore:2-5`); the owner's
  two 資料表檔, copied into `data/in/`, are the only input.
- No server, no credentials: posting the bodies is the owner's, one to `Rule/Save` and the same to
  `Rule/SaveWork`, from Swagger or curl (`README.md:67-68`).

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

Every `specificConfig` carries `referenceDate` = `["executionDate"]` (the 產出規則's common rule); a group
code is matched with its leading zeros stripped, as the owner ruled (`src/collect.js:26`). Each
module's `description` (`rules/r<code>.js:9`) is the rule as written, with its columns numbered
against `schemas/<TABLE>.csv`. Rejected rows are errors, never guesses (`README.md:96-115`).

## Storage

- **In**: `data/in/<TABLE>_Data.csv`, the table name from the file name. The row in force has
  `LMT_E_DATE` = `2910-12-31` — the owner's common 採集規則, and the tables never hold NULL there
  (`src/csv.js:9`, `:89`).
- **Out**: `data/out/rule_fields/r<code>.csv` — the rule模組欄位資料檔, 醫令 + cells read + fields
  filled; `data/out/RuleSave_batch_payload/r<code>.json`, one per rule kind, `ruleExpr` the code and
  `rules[]` one entry (`src/build.js:10`, `:37`); `data/out/items/r<code>/<醫令>.json` with `--split`.
  A kind's file is written only when every body of it passes; the other kinds are unaffected (`:122`).
- On the 2026-09-22 exports: 13 files, 12 026 bodies, every file `validate` clean; `r302.json` is the
  hand-made batch of 2026-09-22 (log 302-batch-prediction), reproduced.

## Integration

- **Its output is `REA_PROTO_BE`'s `SaveRuleRequest`, field for field** (`README.md:169-172`;
  `REA_PROTO_BE@ba161ff Services/ViewModels/RuleDto.cs:6-22`, `RuleConfigurationDto.cs:9-245`) — also the
  Azure Swagger host's ([rea-proto-be](../rea-proto-be/index.md) › Integration); the validator mirrors
  each generator's acceptance check ([declare-verify](../declare-verify.md) › Part 2).
- **One thing the rules do that the back end reads differently — recorded, not handled, on the
  owner's word of 2026-09-23** ([acceptance plan](../plans/rea-proto-data-creator-acceptance.md)
  step 6): 205 and 206 go on every 醫令, and their generators never read `mainSetting`; with
  `doctorTypes` 02 / 01 and `employmentType` 01 they compile the 專任 check for all 5 275
  (`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`, `FullTimeDoctorExecutionRuleGenerator.cs:24-38`);
  only 64 / 41 rows carry the flag the 產出規則 maps to `mainSetting`, which the prototype form
  labels 1 無限制 / 2 除山地離島地區之外基層院所 (`REA_PROTO@3fdf47c tests/mock/api/rulesSpecificSetting.json:4711`).
- 202's `employmentType` 01 and 101–104's group codes were the owner's rulings of the same day, on
  the re-issued documents; 202 stands with 專任 (`Services/Rules/SpecialistRuleGenerator.cs:63-90`).
  303–307 and 401 have no rules in the owner's documents yet.
- **The files are for one rule kind at a time.** The back end keeps one rule document per 醫令 per
  start date, and a `Save` with the same start date replaces its `rules[]` outright
  (`Services/RuleService.cs:283-298`; [declare-verify](../declare-verify.md) › Saving a rule): posting
  two kinds' bodies for one 醫令 leaves the later one alone. `validate` warns when one 醫令 is in two
  files (`README.md:70-74`).
- Nothing links it to `REA_UI` or `REA_kernel`: it targets the prototype back end only.
