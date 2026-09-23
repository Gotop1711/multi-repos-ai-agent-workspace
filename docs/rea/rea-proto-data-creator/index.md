# rea / rea-proto-data-creator

Repository `REA_PROTO_DATA_CREATOR` (`projects/rea_proto_data_creator`, access write, `remote: none`):
a new project created empty by `clone` on 2026-09-22 and filled by
[rea-proto-data-creator-setup](../plans/rea-proto-data-creator-setup.md); this disk holds its only
copy until the owner gives it a remote. Every citation below is `REA_PROTO_DATA_CREATOR@9b89624`
unless another repo is named.

## What it is, in three lines

- Reads 資料表檔 — Oracle SQL Developer csv exports of NHIA 支付標準 tables — from `data/in/`.
- Runs every 資料採集規則: `rules/r<code>.js`, a versioned file whose exported `description` is the
  rule a reviewer reads and whose `collect()` applies it.
- Writes a RuleSave_batch_payload — one `Rule/Save` body per 醫令 — after validating each body against
  what `REA_PROTO_BE`'s generators accept (`README.md:3-12`).

## Run

- Node.js ≥ 18, no dependencies, nothing to install, no tests (`package.json:7-9`; the owner's ruling
  of 2026-09-23, plan `Amended:`).
- `node src/cli.js build --in data/in --out data/out --start-date YYYY-MM-DD [--split]`;
  `validate <file>…` runs the same checks on hand-made bodies; `rules` prints every 採集規則
  (`src/cli.js:102`).
- The exports stay out of git — `data/in/*` and `data/out/` are ignored (`.gitignore:2-6`). There is no
  fixture: the owner's exports are the only input, at
  `~/Web/Case_資拓_健保署/202606_資料轉換_v3/` and copied into `data/in/`.
- No server, no credentials: posting the bodies is the owner's, one to `Rule/Save` and the same to
  `Rule/SaveWork`, from Swagger or curl (`README.md:60-61`).

## Entry points

| Read this first | For |
|---|---|
| `README.md` | terms, pipeline, the validator (`:63`), how to write a rule (`:83`), known tables (`:118`) |
| `rules/r302.js` | the one 採集規則: 適用年齡 from `LMT_AGE_*` — `description` `:9`, selects `:11`, rejects `:22`, worked `:27`; `collect()` `:42` |
| `src/validate.js` | every acceptance check, each citing its `REA_PROTO_BE@ba161ff` line: the 15 kinds `:11`, the 5 without a generator `:31`, required fields per kind `:46`, expressions `:129`, `specificConfig` `:148`, scope `:175`, the body `:215`, the batch `:277` |
| `src/build.js` | the pipeline `:88`; loading rules `:15`, grouping by 醫令 `:36`, the intermediate csv `:65` |
| `src/csv.js` | reading an export `:67`, the rows in force `:89`; `OPEN_END_DATE` `:9` |
| `schemas/<TABLE>.csv` | the two tables' columns, from the owner's `<TABLE>_Schema.xlsx` of 2026-09-22 |

There is no model layer: a body is a plain object, `JSON.parse` / `JSON.stringify` are the schema.

## Storage

- **In**: `data/in/<TABLE>_Data.csv`, the table name taken from the file name. The row in force has
  `LMT_E_DATE` = `2910-12-31` — the tables never hold NULL there (`src/csv.js:9`, `:89`); 5 275 of
  17 276 `MHCT_PAYLIMIT` rows in the 2026-09-22 export, one per 醫令.
- **Out**: `data/out/rule_fields/r<code>.csv` — the rule模組欄位資料檔, 醫令 + cells read + fields
  filled; `data/out/RuleSave_batch_payload.json`; `data/out/items/<醫令>.json` with `--split`
  (`src/build.js:10-12`). Any error and nothing but the intermediates is written.
- On the 2026-09-22 export: 71 bodies — 38 in years, 32 in months, 1 in days — the hand-made 302 batch
  of that day, now reproduced (`rules/r302.js:27-30`; log 302-batch-prediction).

## Integration

- **Its output is `REA_PROTO_BE`'s `SaveRuleRequest`, field for field** (`README.md:127-132`;
  `REA_PROTO_BE@ba161ff Services/ViewModels/RuleDto.cs:6-22`, `RuleConfigurationDto.cs:9-245`) — also the
  Azure Swagger host's ([rea-proto-be](../rea-proto-be/index.md) › Integration). The validator mirrors
  each generator's `IsValidSpecificConfig` and the two expression parsers
  ([declare-verify](../declare-verify.md) › Part 2): a 302 without `referenceDate` fails here, not in
  the job.
- **302's `referenceDate` is `["executionDate"]`** on the owner's ruling of 2026-09-22
  (`rules/r302.js:19`); `MHCT_PAYLIMIT.LMT_AGE_DATE_REF_TYPE` is empty on every exported row, so the
  table itself cannot say. Per-declaration results still need Oracle: not predictable from here.
- **The server takes its output.** On 2026-09-23 the owner posted `data/out/items/01023C.json`
  (`--start-date 2026-10-01`) to the Azure host: `Rule/Save` answered `success: true`「儲存成功！」and
  `Rule/SaveWork` `success: true` (the owner's run, reported in session). That settles the shape and
  both start-date checks, not that the stored workflow runs: only a validation job shows that, and it
  checks nothing unless Oracle returns declaration rows for the 醫令
  ([declare-verify](../declare-verify.md) › Part 3, step 4).
- **Not yet a rule**: `MHCT_PAYLIMIT.LMT_SEX` (19 rows in force, values `1`/`2` — what 301 takes) and
  `MHCT_PAYLTYPE` (19 `LMT_TYPE_CODE` values, no mapping to a rule kind on disk) (`README.md:118-124`).
  Each waits for the owner's mapping —
  [rea-proto-data-creator-acceptance](../plans/rea-proto-data-creator-acceptance.md) steps 5 and 6,
  one commit per rule kind.
- Nothing links it to `REA_UI` or `REA_kernel`: it targets the prototype back end only.
