# rea / rea-proto-data-creator

Repository `REA_PROTO_DATA_CREATOR` (`projects/rea_proto_data_creator`, access write, `remote: none`):
a new project created empty by `clone` on 2026-09-22 and filled by
[rea-proto-data-creator-setup](../plans/rea-proto-data-creator-setup.md); this disk holds its only
copy until the owner gives it a remote. Every citation below is `REA_PROTO_DATA_CREATOR@369fbfc`
unless another repo is named. The owner's three documents of 2026-09-23 are
`sources/2026-09-23-data-creation-definitions.txt.md@2514808960d5` (the terms),
`…-collection-rules.txt.md@60abaf844baf` (資料採集規則: which rows) and
`…-payload-item-rules.txt.md@99350725cdd8` (產出規則: which fields).

## What it is, in three lines

- Reads 資料表檔 — Oracle SQL Developer csv exports of NHIA 支付標準 tables — from `data/in/`.
- Runs every 資料採集規則: `rules/r<code>.js`, whose exported `description` is the rule a reviewer
  reads and whose `collect()` applies it; `src/collect.js` is what they share — the common
  `referenceDate` (`:8`), `MHCT_PAYLTYPE` by type and group, one condition per 醫令 (`:18`),
  `MHCT_PAYLIMIT` row by row (`:51`).
- Writes a RuleSave_batch_payload — one `Rule/Save` body per 醫令 — after validating each body against
  what `REA_PROTO_BE`'s generators accept (`README.md:3-12`).

## Run

- Node.js ≥ 18, no dependencies, nothing to install, no tests (`package.json:7-9`).
- `node src/cli.js build --in data/in --out data/out --start-date YYYY-MM-DD [--split]`;
  `validate <file>…` runs the same checks on hand-made bodies; `rules` prints every 採集規則
  (`src/cli.js:102`). The 2026-09-22 exports build in two seconds.
- The exports stay out of git — `data/in/*` and `data/out/` are ignored (`.gitignore:2-5`); the owner's
  exports are the only input, at `~/Web/Case_資拓_健保署/202606_資料轉換_v3/`, copied into `data/in/`.
- No server, no credentials: posting the bodies is the owner's, one to `Rule/Save` and the same to
  `Rule/SaveWork`, from Swagger or curl (`README.md:66-67`).

## The rules

| Code | 資料表檔 | Selects (rows in force) | Fills | 醫令 |
|---|---|---|---|---|
| 101–104 | `MHCT_PAYLTYPE` | `LMT_TYPE_CODE` 13, group 001–004 | `mainSetting` = the 醫令's `LMT_ITEM`s | 185 / 145 / 199 / 8 |
| 106, 201, 204 | `MHCT_PAYLTYPE` | type 1, 3, 14 | same | 194 / 1 / 192 |
| 203 | `MHCT_PAYLIMIT` | `PRSN_TYPE` not empty | `mainSetting` = it split on `,` | 79 |
| 205, 206 | `MHCT_PAYLIMIT` | every 醫令 | `mainSetting` 2 if `FULL_TIME_DOC` / `_EXEC` else 1; `doctorTypes` 02 / 01; `employmentType` 01 | 5 275 |
| 301 | `MHCT_PAYLIMIT` | `LMT_SEX` not empty | `mainSetting` = [`LMT_SEX`] | 19 |
| 302 | `MHCT_PAYLIMIT` | an `LMT_AGE_*` range | `unit`, `min`, `max` | 71 |

Every `specificConfig` carries `referenceDate` = `["executionDate"]` (the 產出規則's common rule). Each
module's `description` (`rules/r<code>.js:9`) is the rule as written, with its columns numbered
against `schemas/<TABLE>.csv`. Rejected rows are errors, never guesses (`README.md:89-109`).

## Storage

- **In**: `data/in/<TABLE>_Data.csv`, the table name from the file name. The row in force has
  `LMT_E_DATE` = `2910-12-31` — the owner's common 採集規則, and the tables never hold NULL there
  (`src/csv.js:9`, `:89`).
- **Out**: `data/out/rule_fields/r<code>.csv` — the rule模組欄位資料檔, 醫令 + cells read + fields
  filled; `data/out/RuleSave_batch_payload.json`; `data/out/items/<醫令>.json` with `--split`
  (`src/build.js:10-12`). Any error and nothing but the intermediates is written.
- On the 2026-09-22 exports: 5 275 bodies (7.8 MB), 12 rule kinds, `validate` clean; 4 372 bodies
  carry only `205且206`. The 302 subset is the hand-made batch of 2026-09-22 (log
  302-batch-prediction), reproduced.

## Integration

- **Its output is `REA_PROTO_BE`'s `SaveRuleRequest`, field for field** (`README.md:166-169`;
  `REA_PROTO_BE@ba161ff Services/ViewModels/RuleDto.cs:6-22`, `RuleConfigurationDto.cs:9-245`) — also the
  Azure Swagger host's ([rea-proto-be](../rea-proto-be/index.md) › Integration). The validator mirrors
  each generator's `IsValidSpecificConfig` and the two expression parsers
  ([declare-verify](../declare-verify.md) › Part 2).
- **Where the rules and the back end disagree, the rules were followed and the owner asked**
  ([acceptance plan](../plans/rea-proto-data-creator-acceptance.md) steps 6–8):
  - 202 has no module. Its 產出規則 fills `mainSetting` and `doctorTypes` but not `employmentType`,
    which the generator requires (`Services/Rules/SpecialistRuleGenerator.cs:47-52`) and which decides
    whether the specialist must be 專任: the prototype form offers `01` 專任 / `02` 不限專任, default
    `01` (`REA_PROTO@3fdf47c tests/mock/api/rulesSpecificSetting.json:3187`, block 202).
  - 205 and 206 go on every 醫令, and their generators never read `mainSetting`: with `doctorTypes`
    02 / 01 and `employmentType` 01 they compile the 專任 check for all 5 275
    (`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`, `FullTimeDoctorExecutionRuleGenerator.cs:24-38`);
    only 64 / 41 rows carry the flag the 產出規則 maps to `mainSetting`. The form's `mainSetting` means
    1 無限制 / 2 除山地離島地區之外基層院所 (`rulesSpecificSetting.json:4711`, block 205).
  - 101–104 name groups 001–004; the export writes type 13's as 01–04, in force and closed alike, and
    type 1 in both spellings. Group codes are compared by number (`src/collect.js:23`).
- 303–307 and 401 have no rules in the owner's documents yet.
- Nothing links it to `REA_UI` or `REA_kernel`: it targets the prototype back end only.
