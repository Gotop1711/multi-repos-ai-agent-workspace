# rea / rea-proto-data-creator

Repository `REA_PROTO_DATA_CREATOR` (`projects/rea_proto_data_creator`, access write, `remote: none`):
a new project created empty by `clone` on 2026-09-22 and filled by
[rea-proto-data-creator-setup](../plans/rea-proto-data-creator-setup.md); this disk holds its only
copy until the owner gives it a remote. Every citation below is `REA_PROTO_DATA_CREATOR@321dc12`
unless another repo is named.

## What it is, in three lines

- Reads 資料表檔 — Oracle SQL Developer csv exports of NHIA 支付標準 tables — from `data/in/`.
- Runs every 資料採集規則: `rules/r<code>.py`, a versioned file whose docstring is the rule a reviewer
  reads and whose `collect()` applies it.
- Writes a RuleSave_batch_payload — one `Rule/Save` body per 醫令 — after validating each body against
  what `REA_PROTO_BE`'s generators accept (`README.md:3-7`).

## Run

- Python ≥ 3.11, standard library only; `pytest`, 60 tests (`pyproject.toml:9`, `:15`).
- `PYTHONPATH=src python3 -m data_creator build --in data/in --out data/out --start-date YYYY-MM-DD
  [--split]`; `validate <file>…` runs the same checks on hand-made bodies; `rules` prints every
  採集規則 (`src/data_creator/__main__.py:91-105`).
- The exports stay out of git — `data/in/*` and `data/out/` are ignored (`.gitignore:2-5`); an 11-row
  column-faithful sample is the fixture (`tests/fixtures/MHCT_PAYLIMIT_Data.csv`).
- No server, no credentials: posting the bodies is the owner's, one to `Rule/Save` and the same to
  `Rule/SaveWork`, from Swagger or curl (`README.md:64-65`).

## Entry points

| Read this first | For |
|---|---|
| `README.md` | terms, pipeline, the validator (`:67`), how to write a rule (`:86`), known tables (`:121`) |
| `rules/r302.py` | the one 採集規則: 適用年齡 from `LMT_AGE_*` — selects `:5`, rejects `:16`, worked `:21` |
| `src/data_creator/schema.py` | RuleSave_Schema: `SaveRuleRequest` as dataclasses, `to_json` / `from_json`; the 15 kinds `:22`, the 5 without a generator `:43` |
| `src/data_creator/validate.py` | every acceptance check, each citing its `REA_PROTO_BE@ba161ff` line: grammar `:73`, `specificConfig` `:141`, scope `:198`, the body `:248` |
| `src/data_creator/build.py` | the pipeline `:109`; `assemble` groups by 醫令 `:85` |
| `src/data_creator/rules_api.py` | `Collected` / `Rejected` `:35`, loading a rule `:63` |
| `schemas/<TABLE>.csv` | the two tables' columns, from the owner's `<TABLE>_Schema.xlsx` of 2026-09-22 |

## Storage

- **In**: `data/in/<TABLE>_Data.csv`, the table name taken from the file name
  (`src/data_creator/tables.py:45`). The row in force has `LMT_E_DATE` = `2910-12-31` — the tables never
  hold NULL there (`:18`, `:39`); 5 275 of 17 276 `MHCT_PAYLIMIT` rows in the 2026-09-22 export, one per
  醫令.
- **Out**: `data/out/rule_fields/r<code>.csv` — the rule模組欄位資料檔, 醫令 + cells read + fields
  filled; `data/out/RuleSave_batch_payload.json`; `data/out/items/<醫令>.json` with `--split`
  (`src/data_creator/build.py:16-18`). Any error and nothing but the intermediates is written.
- On the 2026-09-22 export: 71 bodies — 38 in years, 32 in months, 1 in days — the hand-made 302 batch
  of that day, now reproduced (`rules/r302.py:21-24`; log 302-batch-prediction).

## Integration

- **Its output is `REA_PROTO_BE`'s `SaveRuleRequest`, field for field** (`src/data_creator/schema.py:1-12`;
  `REA_PROTO_BE@ba161ff Services/ViewModels/RuleDto.cs:6-22`, `RuleConfigurationDto.cs:9-245`) — also the
  Azure Swagger host's ([rea-proto-be](../rea-proto-be/index.md) › Integration). The validator mirrors
  each generator's `IsValidSpecificConfig` and the two expression parsers
  ([declare-verify](../declare-verify.md) › Part 2): a 302 without `referenceDate` fails here, not in
  the job.
- **302's `referenceDate` is `["executionDate"]`** on the owner's ruling of 2026-09-22
  (`rules/r302.py:43`); `MHCT_PAYLIMIT.LMT_AGE_DATE_REF_TYPE` is empty on every exported row, so the
  table itself cannot say. Per-declaration results still need Oracle: not predictable from here.
- **Not yet a rule**: `MHCT_PAYLIMIT.LMT_SEX` (19 rows in force, values `1`/`2` — what 301 takes) and
  `MHCT_PAYLTYPE` (19 `LMT_TYPE_CODE` values, no mapping to a rule kind on disk) (`README.md:121-127`).
  Each waits for the owner's mapping — plan step 5, one commit per rule kind.
- Nothing links it to `REA_UI` or `REA_kernel`: it targets the prototype back end only.
