# rea / rea-proto-data-creator

Repository `REA_PROTO_DATA_CREATOR` (`projects/rea_proto_data_creator`, access write, `remote: none`):
a new project created empty by `clone` on 2026-09-22, filled by
[rea-proto-data-creator-setup](../plans/rea-proto-data-creator-setup.md) and given its kernel target by
[rea-proto-data-creator-kernel](../plans/rea-proto-data-creator-kernel.md) (2026-10-08); this disk
holds its only copy until the owner gives it a remote. Every citation below is
`REA_PROTO_DATA_CREATOR@b059b56` unless another repo is named. The owner's documents of 2026-09-23, under
`sources/`: `2026-09-23-data-creation-definitions.txt.md@2514808960d5` (the terms),
`2026-09-24-data-creation-collection-rules.txt.md@fc90c4190bdf` (資料採集規則: which rows),
`2026-09-24-data-creation-payload-item-rules.txt.md@1c4a1ea1f9e7` (產出規則: which fields, and what
every body carries) and `2026-09-23-post-rulesave-request-body-schema.json.md@e0dcec1e2d33` (the
proto body's fields as the Swagger host shows them).

## What it is, in three lines

- Reads 資料表檔 — Oracle SQL Developer csv exports of NHIA 支付標準 tables — from `data/in/`.
- Runs every 資料採集規則: `rules/r<code>.js` — `description` is the rule, `collect()` applies it.
- Writes one file per rule kind for one of two back ends — `--target kernel`: a `POST /api/v1/RuleSet`
  array for `REA_kernel`; `--target proto` (default): RuleSave_batch_payload for `REA_PROTO_BE` — one
  醫令 per item carrying that kind alone, validated as that back end validates (`README.md:3-16`).

## Run

- Node.js ≥ 18, no dependencies, no tests (`package.json:7-9`). `node src/cli.js build --in data/in
  --out data/out [--target proto|kernel] [--batch-size N] [--split]`; `validate [--target kernel]
  <file>…` checks hand-made bodies; `rules` prints the 採集規則 (`src/cli.js:14-20`).
- `data/in/*` and `data/out/` are gitignored (`.gitignore:2-5`); the owner's two 資料表檔 are the only
  input. No server, no credentials: posting is the owner's (`README.md:80-81`).

## The rules

Fifteen 採集規則, one module each, from the owner's documents: 101–104, 106, 201–206, 301, 302, 307,
401 — which rows each selects and which fields it fills: the table in `README.md:206-222` and each
module's own `description` (`rules/r<code>.js:9`), its columns numbered against `schemas/<TABLE>.csv`.
Common to every proto body (`src/collect.js:10-12`): `ruleStartDate` `2026-01-01`, `ruleEndDate`
`9999-12-31`, `referenceDate` `["executionDate"]`, other `specificConfig` fields `null`. A group code
matches with leading zeros stripped (`:30`); a rejected row is an error, never a guess. 303–306: none yet.

## Storage

- **In**: `data/in/<TABLE>_Data.csv`; the row in force has `LMT_E_DATE` = `2910-12-31` (`src/csv.js:9`).
- **Out**: `data/out/rule_fields/r<code>.csv` — the rule模組欄位資料檔; proto: `data/out/RuleSave_batch_
  payload/r<code>.json` (`src/build.js:64-93`); kernel: `data/out/kernel/r<code>.json`, or `r<code>.<n>.json`
  of `--batch-size` items each (`:157-170`); `--split` writes items (`:172`). A kind's file is written
  only when every body of it passes; the other kinds are unaffected (`:157`).
- The 2026-09-22 exports: 15 kinds, 12 763 items per target, every file `validate` clean.

## Integration

- **The kernel target** (`src/kernel.js`; README › The kernel target). A `RuleSetParameter` per 醫令:
  leaf `{Code, Name, GroupName, Main, Reference, UpdatedAt}`, `Main` keyed by the served schema
  (`schemas/RuleSchema_1.0.json`, the host's GET of 2026-10-08), every served `Reference` key at its
  `Default` except 202's `DoctorTypes` from `ENAME`, `OtherNote` in the ui's text form; the validator
  mirrors the kernel's four stages and the one-`OrderCode`-per-batch rule (ruleset-api › Save).
  Precedence, the owner's: kernel schema > the ui's recorded saves (`fixtures/kernel/*.json`, 18, all
  validate clean) > the proto output. Rulings of 2026-10-08: 307 blanks → `RangeEnd1 = RangeStart1`,
  months `0`–`9999`; 202 `DoctorRole "FullTime"`; `RuleStartDate` `2026-01-01`. Not yet posted.
- **The proto output is `REA_PROTO_BE`'s `SaveRuleRequest`, field for field** (`README.md:265-267`;
  `REA_PROTO_BE@ba161ff Services/ViewModels/RuleDto.cs:6-22`, `RuleConfigurationDto.cs:9-245`); the
  validator mirrors each generator's acceptance check ([declare-verify](../declare-verify.md) › Part 2).
  That back end refuses a start date earlier than the 醫令's latest stored version
  (`Services/RuleService.cs:261-274`, `:424-437`) and stores `9999-12-31` as the end date whatever the
  body says (`:339`, `:413`) — the value checking looks for (`ValidationJobService.cs:572-578`). A
  `Save` with the same start date replaces the 醫令's `rules[]` outright (`:283-298`), so two kinds'
  bodies leave only the later; `validate` warns when one 醫令 is in two files.
- **One proto body has been through the Azure host** (2026-09-23, `01023C`, start date 2026-10-01):
  `Rule/Save`「儲存成功！」, `Rule/SaveWork` `success: true` — the shape and both start-date checks, not
  that the workflow runs (declare-verify › Part 3); at 2026-01-01 that 醫令 is now refused as too early.
- **Recorded, not handled, on the owner's word**: 205 and 206 go on every 醫令 and their generators
  never read `mainSetting` — `doctorTypes` 02 / 01 with `employmentType` 01 compile the 專任 check
  for all 5 275 (`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`, `…ExecutionRuleGenerator.cs:24-38`),
  though only 64 / 41 rows carry the flag the 產出規則 maps to `mainSetting`.
- **401 was refused, then re-issued** with its digits prefixed `0` — the four values the generator
  reads (`OutpatientInpatientRuleGenerator.cs:20-85`); 307's three data oddities (an empty `ENAME`,
  dotted codes, `P8211B`'s range with no leading `I`) the owner keeps as the table has them. 202's
  `employmentType` 01 (`SpecialistRuleGenerator.cs:63-90`) and 101–104's group codes were the owner's
  rulings; `MHCT_PAYLTYPE`'s other 13 limit types have no rules yet (acceptance plan › 6).
