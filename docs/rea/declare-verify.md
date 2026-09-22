# rea / declare-verify

`NhiDeclareVerify` — the back end of the retired prototype, held as `REA_PROTO_BE`. Every citation
below is `REA_PROTO_BE@ba161ff`, path relative to the repository root, unless another repo is named.
Read from source only; nothing here was run. Run and setup: [rea-proto-be](rea-proto-be/index.md).

## In one minute

A claim reviewer decides, per 診療項目 (order code), what a hospital's declaration must satisfy:
"only a specialist may perform this", "patient aged 0–6", "only hospitals in plan X". This service

1. **stores** those rules as the prototype UI's form data (MongoDB `rule`);
2. **compiles** them into an executable rule tree for Microsoft RulesEngine (MongoDB `workflow`);
3. **checks** real declarations from Oracle against the tree, in background jobs, and writes one
   pass/fail record per declared order (MongoDB `validation_result`).

It is one ASP.NET Core project (`net10.0`, `NhiDeclareVerify.csproj:4`), four controllers, no tests,
no authentication.

## The big picture

```
 prototype UI (REA_PROTO)                     operator / script (Swagger, curl)
        │ UiTemplate/*  Payment/*                     │ Rule/SaveWork     ValidationJob/*
        │ Rule/Get  Rule/Save                         │
        ▼                                             ▼
 ┌──────────────────────────── NhiDeclareVerify  /api/v1 ────────────────────────────┐
 │  AUTHORING                        COMPILING                   CHECKING            │
 │  UiTemplateService  ─ forms       RuleService.SaveWorkflow    ValidationJobService│
 │  PaymentService     ─ item list     15 rule generators        + 3 background     │
 │  RuleService.Save   ─ form data     10 scope converters         workers, a queue  │
 └───────┬───────────────────────────────┬──────────────────────────────┬───────────┘
         ▼                               ▼                              ▼
   MongoDB: rule_list,             MongoDB: workflow              Oracle: PBAB_* declarations,
   rules_specific_setting,                                        MHAT_* hospital & staff files
   rules_scope_setting, rule                                      MongoDB: validation_job,
   Oracle/EF: MHCT_*, PXXT_*                                      validation_result
```

## Part 1 — Authoring: what the UI talks to

| Endpoint (`/api/v1/…`) | What it does | Where |
|---|---|---|
| `GET UiTemplate/RuleList/Get` | the list of rule kinds | `Controllers/UiTemplateController.cs:20` |
| `GET UiTemplate/RulesSpecificSetting/Get` | each rule's 主設定 form | `:45` |
| `GET UiTemplate/RulesScopeSetting/Get` | the 檢核範圍 form | `:70` |
| `POST UiTemplate/…/Save` (three) | replace one of those documents | `:95`, `:121`, `:147` |
| `POST Payment/Item/Get` | order codes by keyword | `Controllers/PaymentController.cs:26` |
| `POST Payment/Detail/Get` | paged item details + rule dates | `:38` |
| `POST Payment/ExecutionScope/Item/Get` | option lists for the rule header | `:49` |
| `POST Rule/Get` | one stored rule, by item and dates | `Controllers/RuleController.cs:65` |
| `POST Rule/Save` | store the form data | `:26` |

- **Templates are opaque JSON.** Each of the three collections holds a single document whose `data`
  is returned as is (`Services/UiTemplateService.cs:18-23`, `:38-43`). A save deletes everything in
  the collection and inserts the new body, 10 MB at most (`:15`, `:89-92`). The back end never reads
  a template's content — the forms' meaning lives in the UI and in the generators of Part 2.
- **Payment data is the 支付標準.** `MHCT_PAYMENT` joined to the newest `MHCT_PAYITEMS` row per
  code (`Services/PaymentService.cs:92-108`). Each row also gets its rule history: the distinct
  start/end dates of that item's documents in `rule`, newest first (`:243-268`).
- **Header options** come from `PXXT_CODE`, sub-system `PBA`: 醫令類別 `132`, 醫事類別
  `011/012/013`, 案件分類 `101`–`107` grouped per 醫事類別 (`:182-196`, `:425-437`); only codes
  whose end date is 2910-12-31 (`:328-333`).

### Saving a rule is versioning by date

One request may select several items; each gets its own document (`Services/RuleService.cs:164-180`,
`:326-344`). For one item (`:196-232`):

| Situation | Result |
|---|---|
| no rule yet | insert, `RuleEndDate` = `DateOnly.MaxValue` (the "active" version) |
| same start date as the active version | overwrite it in place (`:283-298`) |
| later start date | close the active one at start − 1 day, insert a new one (`:307-318`) |
| earlier start date than any existing | refused — `InvalidOperationException` (`:261-274`) |

## Part 2 — Compiling: from form data to a rule tree

`POST Rule/SaveWork` takes the same body as `Rule/Save` and writes `workflow`, with the same
date-versioning (`Services/RuleService.cs:390-414`). The body has three parts
(`Services/ViewModels/RuleConfigurationDto.cs:9-60`, `:214-244`):

```
form      selectedItems, ruleStartDate, hospCode, caseTypeMap, orderType
ruleExpr  how the rule kinds combine          e.g.  "202且(301或302)"
rules[]   one per rule kind: code "202", data.conditions[]
             each condition: groupName, specificConfig (the 主設定),
                             scopeConditions[] + scopeRuleExpr (the 檢核範圍)
```

The tree built from it (`RuleService.cs:502-527`, `Services/Rules/Core/BaseRuleGenerator.cs:35-83`):

```
root            name = ruleExpr; 且 → And, 或 → Or, 非 → Not, （） → ()
 └─ Unit_202    one per rule kind; Or over its conditions
     └─ Scope_And_Main          one per condition, when it has a scope
         ├─ scope tree          from scopeRuleExpr, leaves made by the scope converters
         └─ "<groupName>_限專科醫師別"   made by that code's generator
```

- `ruleExpr` and `scopeRuleExpr` share one parser: Chinese operators are replaced, tokens become a
  placeholder tree with precedence Not > And > Or, then each placeholder is swapped for the real rule
  carrying the same code or scope id (`Services/Rules/Core/ExpressionParser.cs:15-22`, `:204-213`,
  `:220-247`).
- Every leaf is a C# lambda string evaluated against one object named `pbabDtlOrdModel` — the
  declaration (`Services/ValidationJobService.cs:399`). Lists the reviewer picked become a local
  `limitItems` array (`Services/Rules/Core/RuleExpressionHelper.cs:13`).
- The workflow is named `<item>_<code>_<code>…` (`RuleService.cs:524`). Checking reads the codes
  back out of that name to know which reference data to load (`ValidationJobService.cs:384-385`).

### The fifteen rule kinds

Registered in `Extensions/DependencyInjection/ServiceCollectionExtensions.cs:67-81`; the enum is
`Services/Rules/Core/RuleCode.cs`. Generators are `Services/Rules/<Name>RuleGenerator.cs`.

| Code | Name | Passes when… | Looks up |
|---|---|---|---|
| 101 | HospPlan | hospital holds a chosen plan code on the reference date | `MHAT_HOSP_PLAN` |
| 102 | HospService | hospital holds a chosen service code on that date | `MHAT_SERVICE` |
| 103 | TreatmentDepartment | hospital has a chosen 診療科別 on that date | `MHAT_DETAFUNC` |
| 104 | GradCode | hospital's 評鑑等級 is among the chosen | `MHAT_HOSP_GRAD` |
| 106 | SpecialEquipment | hospital owns a chosen equipment type | `MHAT_SPEC_DTL` |
| 201 | DeclarationDepartment | detail or order 科別 is among the chosen | — |
| 202 | Specialist | executing / prescribing / remote doctor holds a chosen 專科 | `MHAT_DOC_DOC`, `MHAT_LIC` |
| 203 | PersonType | any named person has a chosen 人員類別 | `MHAT_PERSON` |
| 204 | PersonDegree | the relevant person holds a chosen 資格 | `MHAT_PRSN_DEGREE` |
| 205 | FullTimeDoctorPrescription | prescriber is full-time here, or one of five alternatives | `MHAT_LIC`, `MHAT_HOSPBSC`, `PXXT_CODE` |
| 206 | FullTimeDoctorExecution | executor is full-time here, or one of three alternatives | same |
| 301 | Sex | 2nd character of the ID: 1/8 male, 2/9 female | — |
| 302 | Age | reference date falls between birth + min and birth + max | — |
| 307 | IcdCode | a diagnosis field falls in a code range (optional age in months) | — |
| 401 | OutpatientInpatient | 醫事類別 digit: 1 門診, 2 住診, `13` 牙醫; 急診 by order codes | `PBAB_*_ORD` |

Details worth knowing:
- **Reference date** is chosen in the form for 101–104, 203, 204, 302: `applyDate`,
  `executionDate` or `admissionDate`, any of them matching (`Services/Rules/HospPlanRuleGenerator.cs:24-25`,
  `:50-58`). For 106, 202, 205, 206, 307 it is computed per declaration by the enrichment step.
- **Built-in exemptions.** 101/102 pass outright for 轉代檢 orders (`…/ReferenceData/HospQualificationHospIdProvider.cs:46-48`,
  `:76-78`); 202 passes when `PartCode`'s 2nd character is `0` or 案件分類 is `02`
  (`Services/Rules/SpecialistRuleGenerator.cs:314-321`); 205 passes outright for 山地離島 hospitals,
  轉代檢 orders and 在宅急症 cases, and otherwise accepts the 遠距 or 居家醫療 person being full-time
  instead of the prescriber (`Services/Rules/FullTimeDoctorPrescriptionRuleGenerator.cs:30-38`).
- **Which hospital is asked about** for 101/102: the 轉檢 hospital for transferred orders, else the
  real hospital, else the declaring one; ten order codes and the `303xxx` family always use the
  general case (`HospQualificationHospIdProvider.cs:99-158`).
- **Person ids are compared by first 4 + last 3 characters**, in SQL and in every expression
  (`Infrastructure/Persistence/Repositories/DeclarationRepository.cs:445-449`, `:463`;
  `Services/Rules/PersonTypeRuleGenerator.cs:37-48`) — the ids on file are masked in the middle
  (inferred from the matching; no comment says so).
- **Age 302** uses the child's birth date when `PartCode` is `903`
  (`…/ReferenceData/AgeReferenceDataService.cs:12-18`).

### The ten scope conditions

Keyed by the condition's `id` (`Services/Rules/Core/ScopeRuleCode.cs`); each is `Contains` or
`NotContains` (`Services/Rules/Scope/*.cs`).

| `id` | Meaning | Declaration field |
|---|---|---|
| `caseType` | 案件分類 | `CaseType` |
| `hospCode` | 醫事類別 | `HospDataType` |
| `orderType` | 醫令類別 | `OrderType` |
| `relMode` | 處方調劑方式 | `DetailRelMode` |
| `department` | 就醫科別 | `DetailFuncType` or `OrderFuncType` |
| `subMainDiagnosisCode` | 主次診斷 | `Icd9CmCode`, `Icd9CmCode1` |
| `partCode` | 部分負擔代碼 | `PartCode` |
| `treatmentArea` | 診療部位 | `CurePath` |
| `treatmentItems` | 核定治療項目 | `CureItem1`–`4` |
| `robotic` | 僅機械手臂輔助手術 | `NoListMark == "3"` |

The four code-like ones take a `category`: `01` exact codes, `02` a prefix of N characters, `03` a
prefix range (`Services/Rules/Core/CodeRangeRuleConverter.cs:18`, `:76`, `:135`).

## Part 3 — Checking: a validation job, step by step

| Endpoint | What it does | Where |
|---|---|---|
| `POST ValidationJob/Batch` | create jobs from a JSON list; answers 202 at once | `Controllers/ValidationJobController.cs:33` |
| `POST ValidationJob/Batch/File` | the same from a CSV upload | `:54` |
| `POST ValidationJob/Status` | status, total and processed counts, message | `:100` |
| `POST ValidationJob/Cancel` | cancel a Pending or Processing job | `:126` |
| `POST ValidationJob/Results/Download` | filtered results as a JSON file | `:153` |

A job names one declaration batch: `HospId`, `HospDataType`, `FeeYearMonth`, `ApplyType`,
`ApplyDate`, optionally one `OrderCode` (`Services/ViewModels/CreateValidationJobRequest.cs:8-43`).
The CSV needs columns `HOSP_ID, HOSP_DATA_TYPE, FEE_YM, APPL_TYPE, APPL_DATE` (+ `ORDER_CODE`),
dates as `M/d/yyyy`, duplicates dropped (`Services/ValidationJob/ValidationJobCsvParser.cs:95`,
`:116`, `:59-64`).

1. **Queue.** The job is written to `validation_job` as `Pending`; its id goes into an in-memory
   channel (`Services/ValidationJobService.cs:56-61`, `:300-325`;
   `Services/ValidationJob/ValidationJobQueue.cs:10-15`).
2. **Pick up.** Three workers (setting `ValidationJob:MaxConcurrency`) read the channel
   (`Services/ValidationJobBackgroundService.cs:24-26`, `:38`).
3. **Load.** 醫事類別 ≤ 19 → `PBAB_OP_DTL ⋈ PBAB_OP_ORD`; 20–29 → `PBAB_HP_DTL ⋈ PBAB_HP_ORD`;
   otherwise nothing (`Services/DeclarationData/DeclarationDataService.cs:30-43`;
   `DeclarationRepository.cs:72-80`, `:158-166`). One row = one order line with its case's fields;
   the patient id is decrypted in the database (`:44`).
4. **Group by order code**, load that code's *active* workflow (`ValidationJobService.cs:354`,
   `:572-592`). No workflow → every row is recorded as "not checked" (`:363-381`).
5. **Enrich.** For each code in the workflow name, that code's reference-data service adds Oracle
   look-ups and computed fields (`Reference…`) to the row (`:393-397`;
   `Services/DeclarationData/Models/Declaration.cs:296-421`).
6. **Run** RulesEngine on the row; map the result tree to a record (`:399-413`).
7. **Flush** every 500 records (`ValidationJob:BatchSize`) and update progress (`:530-565`).
8. **Finish.** `Completed` with a summary — totals, failed rule kinds, a sample line per failure —
   or `Failed` with the exception chain, 4 000 characters at most (`:135-155`, `:171-197`,
   `:465-473`).

### Reading a result record

`Infrastructure/Persistence/Models/ValidationResultDocument.cs`; built by
`Services/ValidationJob/RuleResultMapper.cs:59-87`, `:190-272`.

```
HospId, FeeYm, ApplDate, CaseType, SeqNo, OrderSeqNo, OrderCode      which order line
Result.OrderCodeFilter      false = no workflow existed for this order code
Result.OrderCodeResult      the whole tree passed
Result.OrderCodeExpression  "202&&(301||302)"
Result.RuleLists[]          one per rule kind:
   ItemId "202", ItemResult, ErrorCode "C8", ItemExpression "group1||group2"
   ItemGroups[]             one per condition:
      GroupName, GroupFilter (scope matched), GroupResult (main rule passed), GroupRemark
```

`ErrorCode` maps the rule kind to the 審查 error code: 101–105 → CC1–CC5, 106 → C6, 201 → CD9,
202 → C8, 203 → C12, 204 → C71, 205 → CC6, 206 → CC7, 301 → C53, 302 → C52, 303/304 → C34,
305 → C36, 306 → C65, 307 → C62, 401 → C31 (`RuleResultMapper.cs:28-50`).

## What will surprise you

Observed in the code:
- **`Rule/Save` does not make a rule checkable.** Only `Rule/SaveWork` writes `workflow`
  (`Controllers/RuleController.cs:26-44`). The prototype UI calls `Rule/Save` and never `SaveWork` or
  any `ValidationJob` endpoint (`REA_PROTO@3fdf47c src/api/modules/rules/index.ts:32`; no match for
  either word under its `src/`).
- **Checking ignores rule dates.** It always takes the workflow whose end date is `MaxValue`, whatever
  the declaration's month (`ValidationJobService.cs:575-578`). Closed versions are never used.
- **Five error codes have no generator**: 105, 303, 304, 305, 306 are in the error map but not in
  `RuleCode` (`RuleResultMapper.cs:34`, `:44-47`; `RuleCode.cs`). A rule kind without a generator is
  dropped while compiling (`RuleService.cs:536-541`).
- **Stored but never read**: `ReferenceConditions`, `ReferenceRuleExpr`, `ResultAction`, the
  2026/07/03 `BodyPart…` / `Order…` fields, and 302's `OperatorMin` / `OperatorMax`
  (`RuleConfigurationDto.cs:39`, `:64-69`, `:104-105`, `:155-177`) — no file outside `ViewModels/`
  names them; 302 always compiles `≥ min` and `≤ max` (`AgeRuleGenerator.cs:25`, `:38-43`).
- **A rejected condition vanishes silently, and a rule kind whose conditions all vanish still
  compiles.** 302 rejects a config missing `unit`, `min`, `max` or a `referenceDate` entry
  (`Services/Rules/AgeRuleGenerator.cs:94-101`); the base generator skips it
  (`Services/Rules/Core/BaseRuleGenerator.cs:60-64`) and emits `Unit_302` as an `Or` over no rules
  (`:35-42`, `RuleService.cs:543-550`). `SaveWork` answers `Success:true` for such a body.
- **An early start date is a 500 on `Save`, a quiet `Success:false` on `SaveWork`** — the first
  catches only Mongo exceptions, the second everything (`RuleService.cs:234-251`, `:55-64`).
- **The queue is memory only.** Nothing re-queues at start-up (`Program.cs`), so a job `Pending` at a
  restart stays `Pending`.
- **Template save is delete-then-insert**, though its comment says transactional
  (`UiTemplateService.cs:88-92`).
- **No authentication, no CORS policy**: `UseAuthorization()` with no scheme and no `[Authorize]`
  anywhere; Swagger is on in every environment (`Program.cs:107-113`).

Inferred, not run:
- **Out of scope counts as failed.** A condition is `And(scope, main)` and the rule kind is `Or` over
  conditions, so a row outside every condition's scope fails the rule kind; only `GroupFilter:false`
  and the remark 不適用 tell it apart (`BaseRuleGenerator.cs:35-42`, `:70-77`;
  `RuleResultMapper.cs:250`).
- **Rule kinds share scratch fields.** `ReferenceDate`, `ReferenceHospId` and `ReferencePrsnId` are
  single fields that several enrichers set differently — 202 uses execution date, 205 uses 就醫日期
  (`…/ReferenceData/SpecialistReferenceDataService.cs:156-160`,
  `…/FullTimeDoctorPrescriptionReferenceDataService.cs:126-128`). In a workflow holding both, the
  last code in the workflow name wins for both.
- **Matching people on 4 + 3 characters** can match more than one person.
- **An empty `Or` unit fails the job, not the save.** The job builds the engine per order code
  (`ValidationJobService.cs:384`) inside one try (`:123-155`); RulesEngine 6 validates each workflow
  in its constructor and refuses a rule that has an `Operator` but no `Rules` (from the library's
  source, which is not in this repository) — so one hollow workflow marks the whole job `Failed`.
