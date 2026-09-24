# rea / rea-proto-data-creator

Repository `REA_PROTO_DATA_CREATOR` (`projects/rea_proto_data_creator`, access write, `remote: none`):
a new project created empty by `clone` on 2026-09-22 and filled by
[rea-proto-data-creator-setup](../plans/rea-proto-data-creator-setup.md); this disk holds its only
copy until the owner gives it a remote. Every citation below is `REA_PROTO_DATA_CREATOR@63005f8`
unless another repo is named. The owner's documents of 2026-09-23, under `sources/`:
`2026-09-23-data-creation-definitions.txt.md@2514808960d5` (the terms),
`2026-09-24-data-creation-collection-rules.txt.md@fc90c4190bdf` (資料採集規則: which rows),
`2026-09-24-data-creation-payload-item-rules.txt.md@db072c96a4f5` (產出規則: which fields, and what
every body carries) and `2026-09-23-post-rulesave-request-body-schema.json.md@e0dcec1e2d33` (the
body's fields as the Swagger host shows them).

## What it is, in three lines

- Reads 資料表檔 — Oracle SQL Developer csv exports of NHIA 支付標準 tables — from `data/in/`.
- Runs every 資料採集規則: `rules/r<code>.js` — `description` is the rule, `collect()` applies it.
- Writes one RuleSave_batch_payload per rule kind, a `Rule/Save` body per 醫令 carrying that kind
  alone, after validating each against what `REA_PROTO_BE` accepts (`README.md:3-13`).

## Run

- Node.js ≥ 18, no dependencies, no tests (`package.json:7-9`). `node src/cli.js build --in data/in
  --out data/out [--split]`; `validate <file>…` checks hand-made bodies; `rules` prints the 採集規則
  (`src/cli.js:95`).
- `data/in/*` and `data/out/` are gitignored (`.gitignore:2-5`); the owner's two 資料表檔 in
  `data/in/` are the only input. No server, no credentials: posting is the owner's, `Rule/Save` then
  `Rule/SaveWork` (`README.md:73-74`).

## The rules

Sixteen 採集規則, one module each, from the owner's documents: 101–104, 106, 201–206, 301, 302, 307,
401. Which rows each selects and which fields it fills is the table in `README.md:126-152`, and each
module's own `description` (`rules/r<code>.js:9`) is the rule as written, its columns numbered against
`schemas/<TABLE>.csv`. Common to every body, the 產出規則's rule (`src/collect.js:10-12`;
`src/build.js:14`, `:44`): `form.ruleStartDate` `2026-01-01`, `form.ruleEndDate` `9999-12-31`,
`specificConfig.referenceDate` `["executionDate"]`, and every other `specificConfig` field of the
owner's schema written as `null`. A group code is matched with its leading zeros stripped
(`src/collect.js:30`); a rejected row is an error, never a guess (`README.md:105-124`).

## Storage

- **In**: `data/in/<TABLE>_Data.csv`; the row in force has `LMT_E_DATE` = `2910-12-31`, the owner's
  common 採集規則 (`src/csv.js:9`, `:89`).
- **Out**: `data/out/rule_fields/r<code>.csv` — the rule模組欄位資料檔; `data/out/RuleSave_batch_payload/`
  `r<code>.json`, one per rule kind, `ruleExpr` the code and `rules[]` one entry (`src/build.js:17`,
  `:44`); `data/out/items/r<code>/<醫令>.json` with `--split`. A kind's file is written only when every
  body of it passes; the other kinds are unaffected (`:131`).
- On the 2026-09-22 exports: 12 files, 12 140 bodies, every written file `validate` clean; `r302.json`
  is the hand-made batch of that day (log 302-batch-prediction), reproduced. `r401.json` is refused.

## Integration

- **Its output is `REA_PROTO_BE`'s `SaveRuleRequest`, field for field** (`README.md:192-195`;
  `REA_PROTO_BE@ba161ff Services/ViewModels/RuleDto.cs:6-22`, `RuleConfigurationDto.cs:9-245`), which is
  the Azure Swagger host's; the validator mirrors each generator's acceptance check
  ([declare-verify](../declare-verify.md) › Part 2).
- **The body's dates and the back end.** A start date earlier than the 醫令's latest stored version is
  refused (`Services/RuleService.cs:261-274`, `:424-437`); the end date is stored as `9999-12-31`
  whatever the body says (`:339`, `:413`) — the value the body carries since 2026-09-24, and the one
  checking looks for (`ValidationJobService.cs:572-578`). Not the `2910-12-31` of a row in force.
- **The files are for one rule kind at a time.** A `Save` with the same start date replaces the
  醫令's `rules[]` outright (`:283-298`), so two kinds' bodies leave only the later; `validate` warns
  when one 醫令 is in two files (`README.md:76-80`).
- **One body has been through the host.** On 2026-09-23 the owner posted `01023C`, built with the
  then start date 2026-10-01: `Rule/Save` answered「儲存成功！」and `Rule/SaveWork` `success: true`.
  That settles the body's shape and both start-date checks, not that the stored workflow runs — only a
  validation job shows that, and it checks nothing unless Oracle returns rows for the 醫令
  ([declare-verify](../declare-verify.md) › Part 3). With the start date now 2026-01-01, a body for
  that 醫令 is refused as too early.
- **Recorded, not handled, on the owner's word**: 205 and 206 go on every 醫令 and their generators
  never read `mainSetting`; `doctorTypes` 02 / 01 with `employmentType` 01 compile the 專任 check
  for all 5 275 (`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`, `…ExecutionRuleGenerator.cs:24-38`),
  though only 64 / 41 rows carry the flag the 產出規則 maps to `mainSetting`.
- **401 is written but refused.** The 產出規則 splits `IOPD_LMT` into single digits; the generator
  reads `mainSetting` as `01` 門診, `02` 住診, `03` 限急診, `04` 牙醫門診 and compiles nothing from
  anything else (`OutpatientInpatientRuleGenerator.cs:20-85`), so all 623 bodies would be hollow units.
  The validator refuses them by the values each generator reads, and `r401.json` is not written
  ([acceptance plan](../plans/rea-proto-data-creator-acceptance.md) step 5).
- 202's `employmentType` 01 (專任, `SpecialistRuleGenerator.cs:63-90`) and 101–104's group codes were
  the owner's rulings; `MHCT_PAYLTYPE`'s other 13 limit types and 303–306 have no rules yet, and 307
  carries three data questions (plan steps 6–8).
