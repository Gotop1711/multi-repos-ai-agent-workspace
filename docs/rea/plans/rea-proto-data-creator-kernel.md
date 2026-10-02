# rea — rea-proto-data-creator-kernel

Status: draft

## Goal
`REA_PROTO_DATA_CREATOR` gains a second target: from the same 資料表檔 and the same fifteen 採集規則 it
writes, per rule kind, one `POST /api/v1/RuleSet` body for `REA_kernel` — a JSON array of
`RuleSetParameter` (`OrderCode`, `SchemaVersion` `1.0`, `RuleStartDate`, `Logic`, `OtherNote`),
one item per 醫令, `Logic` one leaf `{Code, Name, GroupName, Main, Reference}` or an `Or` of leaves
— checked here as the kernel's four save validators check it, so a file that builds is a file the
kernel accepts (ruleset-api › Save). Rests on `REA_kernel@6540a4c`, which the live host runs
(`docs/rea/rea-kernel/sources/2026-10-02-ruleschema-live.json.md@6bc34f74a2a3`), on the owner's
capture of a ui save
(`…/sources/2026-10-02-api-post-ruleset-request-body-example.json.md@07a15b0b3ef4`), and on
field-map › 值的規則. Tried on the 2026-09-22 exports: all 12 763 bodies map and pass but 61 of 307's.

## Writes
`REA_PROTO_DATA_CREATOR (main)`. Nothing in `REA_kernel` (read-only): step 5 is a request to its
owners.

## The mapping — prototype `specificConfig` → kernel leaf
Common: `referenceDate ["executionDate"]` → `Reference.ReferenceDates [{Fields:
["ExecutionStartDate"]}]` where the code serves `ReferenceFields` — 201 does not, so its leaf has
no `Reference` (else 400); `doctorTypes` → `Reference.DoctorTypes [{Fields: [..]}]` (202, 205,
206); `Name` = the code's schema `Label`; `GroupName` = 群組1, 群組2…; no `Condition`;
`employmentType` has no kernel field (dropped).

| Code | `Main` |
|---|---|
| 101–104, 106, 201, 203, 204 | `mainSetting` → the code's one `StringArray` key (`PlanCodes`, …; field-map) |
| 202 | `mainSetting` → `SpecialistCodes`; `employmentType "01"` → `DoctorRole "FullTime"` (label 專任; inferred) |
| 205, 206 | `mainSetting[0]` → `SpecialistCodes`, a `String` (`"1"` 無限制, `"2"` 除山地離島地區之外基層院所) |
| 301 | `mainSetting[0]` → `GenderCode`, a `String` |
| 302 | `MinOp ">="`, `Min`, `MaxOp "<="`, `Max`, `Unit` — inclusive, as the prototype compiled them |
| 307 | each `rangeGroups` row → `DiagnosisCodes [{RangeStart1, RangeEnd1, RangeStart2, RangeEnd2}]` (months as numbers; no `prefixRange`); `filterFields` → `DiagnosisScope` |
| 401 | `mainSetting` → `VisitTypes` — the padded digits are the four options exactly |

## Steps
1. `feat: kernel schema` — `schemas/RuleSchema_1.0.json`, the live GET of 2026-10-02 (250 KB): the
   file the kernel validator reads for types, `Required`, `Min`, `CompareField`, options,
   SubFields.
2. `feat: kernel body` — `src/kernel.js`: the table as one function per code; the assembler
   (`SchemaVersion` from the schema, `RuleStartDate` `2026-01-01` per the 產出規則, `OtherNote` in the
   ui's text form `{"<code>":"群組1:\n主設定: <Label>: v1、v2"}`); the validator mirroring the kernel's
   four validators and the service's one-`OrderCode`-per-batch rule (ruleset-api › Save), each
   check citing its kernel line.
3. `feat: --target kernel` — `build --target kernel` writes `data/out/kernel/r<code>.json`, one
   array per rule kind — one POST each; `--batch-size N` splits it into `r<code>.<n>.json`;
   `validate --target kernel` checks hand-made files; `--target proto` (default) is today's
   output, unchanged.
4. `docs: README` — the target, the mapping, and two things the validator cannot see: a batch is
   all-or-nothing (one bad item, nothing saved), and a start date earlier than the 醫令's current
   version is refused — the dev store holds `12116B` (2026-10-01) and `01116B` (2026-10-02)
   already.
5. 307 — **blocked on a ruling.** The kernel marks all four `DiagnosisCodes` sub-fields `Required`
   (`_307.cs:25,35,47,57`): 24 醫令 have a row without `ENAME` (`RangeEnd1`), 61 a row without
   months, so 61 of 114 would be refused and, all-or-nothing, the file with them. The prototype
   treated both as optional (open top; no age bound). (a) Ask the kernel's owners to drop
   `Required` on `RangeEnd1`, `RangeStart2`, `RangeEnd2`; (b) the owner names fill values; (c)
   ship the 53 complete 醫令 only. Recommended: (a).

## Done when
The owner runs `build --target kernel`; posts `r203.json` (79 items — 203 is one of the two codes
the kernel translates today, with 201) to `POST /api/v1/RuleSet` on `210.59.250.145:8080` and gets
200 with one `{OrderCode, RuleStartDate}` per item; `GET /api/v1/RuleSet?$filter=OrderCode eq '…'`
shows `TranslatorVersion "1.1"` and a non-null `TranslatedRules`; one other kind's file (say
`r401.json`) also answers 200, stored with `Codes ["401"]` and `TranslatedRules` null — the
kernel's gap, not the tool's. A `ValidationJob` over a 203 醫令 is the kernel team's test: it needs
claim rows in their Oracle.
