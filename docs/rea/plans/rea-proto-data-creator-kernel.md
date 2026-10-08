# rea — rea-proto-data-creator-kernel

Status: draft

## Goal
`REA_PROTO_DATA_CREATOR` gains a second target: from the same 資料表檔 and the same fifteen 採集規則 it
writes, per rule kind, one `POST /api/v1/RuleSet` body for `REA_kernel` — a JSON array of
`RuleSetParameter` (`OrderCode`, `SchemaVersion` `1.0`, `RuleStartDate`, `Logic`, `OtherNote`),
one item per 醫令, `Logic` one leaf `{Code, Name, GroupName, Main, Reference, UpdatedAt}` or an
`Or` of leaves — shaped as the ui shapes its saves and checked as the kernel's four validators
check it, so a file that builds is a file the kernel accepts (ruleset-api › Save). Rests on the
owner's 2026-10-08 records of the ui saving every one of the fifteen kinds on `33116B`
(`docs/rea/rea-kernel/sources/2026-10-08-post-ruleset-<code>.json.md`, e.g. 307 `@e159e6e20a7c`,
202 專任 `@3e034b98ffeb`, 103 `@b467b5903a92`), the schema the host serves that day
(`…/sources/2026-10-08-ruleschema-live.json.md@476fba76c157`, `REA_kernel@692bdc0`) and field-map ›
值的規則. Tried on the 2026-09-22 exports with the mapping below: all 12 763 bodies pass.

## Writes
`REA_PROTO_DATA_CREATOR (main)`. Nothing in `REA_kernel` (read-only).

## The mapping — collected table values → kernel leaf
**Precedence (owner, 2026-10-08): the kernel's conditions and specification first; the recorded ui
payloads second; what the tool produced for `REA_PROTO_BE` last, as reference only.** The 採集規則
still say which rows and columns; the prototype's `specificConfig` names below only locate a value.
`Name` = the code's schema `Label`; `GroupName` = 群組1, 群組2…; no `Condition`; `UpdatedAt` = build time.
`Reference`, as the ui sends it: **every** `ReferenceFields` key the code serves, one group at the
kernel's `Default` — `ReferenceDates` included (`["ApplyDate", "ExecutionStartDate"]`; 203
`["ExecutionStartDate", "FuncDate"]`), `DoctorType` 103, `HospCodes` 106/202, `DoctorTypes` 205/206,
`AgeReference` 302/307 (`Birthday`, `ChildBirthday` since `692bdc0`) — except 202's `DoctorTypes`,
which `ENAME` supplies (`["01"]` or `["02"]`). 201 serves none and gets no `Reference` (else 400).
The prototype's `referenceDate ["executionDate"]` and 205/206's constant `doctorTypes` are dropped.

| Code | `Main` |
|---|---|
| 101–104, 106, 201, 203, 204 | `mainSetting` → the code's one `StringArray` key (`PlanCodes`, …; field-map) |
| 202 | `mainSetting` → `SpecialistCodes`; `employmentType "01"` → `DoctorRole "FullTime"` — the ui's radio 執行醫師/專任 emits exactly `Executor` / `FullTime` (records 202-01, 202-02) |
| 205, 206 | `mainSetting[0]` → `SpecialistCodes`, a `String` (`"1"` 無限制, `"2"` 除山地離島地區之外基層院所) |
| 301 | `mainSetting[0]` → `GenderCode`, a `String` |
| 302 | `MinOp ">="`, `Min`, `MaxOp "<="`, `Max`, `Unit` — inclusive, as the prototype compiled them |
| 307 | each `rangeGroups` row → `DiagnosisCodes [{RangeStart1, RangeEnd1, RangeStart2, RangeEnd2}]`; `filterFields` → `DiagnosisScope`; the kernel requires all four (`_307.cs:25,35,47,57`), so a blank `ENAME` becomes `RangeEnd1 = RangeStart1` and a missing month pair `0`…`9999` — the values the owner typed into the ui (record 307: `I63`–`I63`, `0`–`9999`); `prefixRange` has no field |
| 401 | `mainSetting` → `VisitTypes` — the padded digits are the four options exactly |

## Steps
1. `feat: kernel schema` — `schemas/RuleSchema_1.0.json`, the live GET of 2026-10-08 (250 KB): the
   file the kernel validator reads for types, `Required`, `Min`, `CompareField`, options, SubFields.
2. `feat: kernel body` — `src/kernel.js`: the table as one function per code; the assembler
   (`SchemaVersion` from the schema, `RuleStartDate` `2026-01-01` per the 產出規則, `OtherNote` in
   the ui's text form `{"<code>":"群組1:\n主設定: <Label>: v1、v2"}`); the validator mirroring the
   kernel's four validators and the service's one-`OrderCode`-per-batch rule (ruleset-api › Save),
   each check citing its kernel line; the 18 records as fixtures the validator must accept.
3. `feat: --target kernel` — `build --target kernel` writes `data/out/kernel/r<code>.json`, one array
   per rule kind — one POST each; `--batch-size N` splits it into `r<code>.<n>.json`; `validate
   --target kernel` checks hand-made files; `--target proto` (default) is today's output, unchanged.
4. `docs: README` — the target, the mapping, and two things the validator cannot see: a batch is
   all-or-nothing (one bad item, nothing saved), and a start date earlier than the 醫令's current
   version is refused — the dev store already holds seven 醫令 dated 2026-10-01 … 2026-10-09.
5. Before signing, the owner confirms two readings taken from the records: 307's fills (`RangeEnd1 =
   RangeStart1`, months `0`–`9999`) for a blank `ENAME` / month pair, and 202's `DoctorRole
   "FullTime"` for `employmentType "01"`. Dropping `Required` on 307's three fields stays open as a
   request to the kernel team; the plan needs no change if they do.

## Done when
The owner runs `build --target kernel`; posts `r203.json` (79 items — 203 is one of the two codes the
kernel translates today, with 201) to `POST /api/v1/RuleSet` on `210.59.250.145:8080` and gets 200
with one `{OrderCode, RuleStartDate}` per item; `GET /api/v1/RuleSet?$filter=OrderCode eq '…'` shows
`TranslatorVersion "1.1"` and a non-null `TranslatedRules`; one other kind's file (say `r401.json`)
also answers 200, stored with `Codes ["401"]` and `TranslatedRules` null — the kernel's gap, not the
tool's. A `ValidationJob` over a 203 醫令 is the kernel team's test: it needs claim rows in their Oracle.
