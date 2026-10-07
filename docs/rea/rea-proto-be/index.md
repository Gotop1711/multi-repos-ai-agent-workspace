# rea / rea-proto-be

Repository `REA_PROTO_BE` (`projects/rea_proto_be`, access read-only) — `NhiDeclareVerify`, the
ASP.NET Core back end the retired prototype UI was written against. A local copy of a zip folder:
no upstream, one import commit, `./workspace.sh clone` cannot rebuild it. Cited at
`REA_PROTO_BE@ba161ff`. How it works, end to end: [declare-verify](../declare-verify.md).

## What it is, in three lines

- Serves the prototype UI its form templates, the 支付標準 item list and stored rules.
- Turns a saved rule into a Microsoft RulesEngine workflow.
- Runs background jobs that check Oracle declaration data against those workflows.

## Run

- **Stack.** `net10.0`; EF Core + Oracle, Dapper, MongoDB.Driver, RulesEngine 6, CsvHelper,
  Swashbuckle, OpenTelemetry (`NhiDeclareVerify.csproj:4`, `:11-34`). The `.sln` was one folder up
  and is not in this copy — build the `.csproj`.
- **Start.** `dotnet run` → `http://localhost:5066`, opens `/swagger`; `https` profile adds `:7007`
  (`Properties/launchSettings.json:12-30`). Docker: SDK build, `aspnet:10.0` runtime, port 8080
  (`Dockerfile:1-19`).
- **Settings** (`appsettings.json`): `MongoDbSettings:ConnectionString` / `DatabaseName`,
  `ConnectionStrings:OracleConnection`, `Jaeger:Endpoint` (tracing, off when blank),
  `ValidationJob:BatchSize` 500 and `MaxConcurrency` 3. The three connection values are committed
  blank; the project has a `UserSecretsId` (`NhiDeclareVerify.csproj:7`) — supply them there or by
  environment. No secret is in the repository.
- **Tests.** None.

## What each mode needs

| | Development | any other environment |
|---|---|---|
| 支付標準 and code tables (EF) | in-memory, seeded from `SeedData/*.csv` at start | Oracle |
| templates, rules, workflows, jobs, results | MongoDB | MongoDB |
| declarations and `MHAT_*` look-ups (Dapper) | **Oracle** | Oracle |

`Program.cs:19-29`, `:92-102`; the Dapper side opens an `OracleConnection` whatever the environment
(`Infrastructure/Persistence/UnitOfWork.cs:23-24`, `:37`). So in Development the authoring endpoints
work with MongoDB alone; validation jobs do not. The seeds are real reference data, 11 MB:
`MHCT_PAYMENT`, `MHCT_PAYITEMS`, `PXXT_CODE` (138 rows), `PXXT_CODE_TYPE`.

## Entry points

| Read this first | For |
|---|---|
| `Program.cs` | start-up: databases, seeding, Swagger, tracing |
| `Extensions/DependencyInjection/ServiceCollectionExtensions.cs` | every service, keyed by rule code |
| `Controllers/*.cs` | the 17 endpoints under `/api/v1` |
| `Services/RuleService.cs` | saving a rule; compiling it to a workflow |
| `Services/Rules/` | `Core/` parser and base; one generator per rule code; `Scope/` converters |
| `Services/ValidationJobService.cs` | the checking loop |
| `Services/DeclarationData/ReferenceData/` | what is looked up per rule code |
| `Infrastructure/Persistence/Repositories/DeclarationRepository.cs` | all Oracle SQL |

## Storage

- **MongoDB** — `rule_list`, `rules_specific_setting`, `rules_scope_setting` (one document each);
  `rule`, `workflow` (one per item per start date); `validation_job`, `validation_result`.
- **Oracle, read only** — declarations `PBAB_OP_DTL/ORD`, `PBAB_HP_DTL/ORD`; `MHAT_HOSP_PLAN`,
  `MHAT_SERVICE`, `MHAT_DETAFUNC`, `MHAT_HOSP_GRAD`, `MHAT_SPEC_DTL`, `MHAT_DOC_DOC`, `MHAT_LIC`,
  `MHAT_PERSON`, `MHAT_PRSN_DEGREE`, `MHAT_HOSPBSC`; `MHCT_PAYMENT`, `MHCT_PAYITEMS`, `PXXT_CODE`,
  `PXXT_CODE_TYPE`. It calls the database function `DECRYPT_AES` on the patient id
  (`DeclarationRepository.cs:44`, `:121`). The service writes nothing to Oracle.

## Integration

- **`REA_PROTO` is its client.** The UI's API modules call eight of these paths verbatim —
  `Payment/Item/Get`, `Payment/Detail/Get`, `Payment/ExecutionScope/Item/Get`, `Rule/Get`,
  `Rule/Save`, and the three `UiTemplate/…/Get` (`REA_PROTO@3fdf47c src/api/modules/payment/index.ts:21-41`,
  `src/api/modules/rules/index.ts:22-56`) — against `Controllers/*.cs` here. Its base URL is
  `VITE_BASE_URI` (`src/api/request.js:6`). It never calls `Rule/SaveWork`, `UiTemplate/…/Save` or
  `ValidationJob/*`: those are driven from Swagger or scripts.
- **`REA_UI` still calls two of its paths.** `/api/v1/Payment/Item/Get` and `/Detail/Get`
  (`REA_UI@a024004 src/api/modules/payment/index.ts:19,29`) are `Controllers/PaymentController.cs:26`,
  `:38` here, and the ui's nginx and dev proxy send `/api/v1/Payment/` to an Azure App Service host
  (`REA_UI@a024004 frontend.conf:14`, `.env.development:6`; [bff](../bff.md)). That host's live
  Swagger on 2026-09-22 lists these 17 paths and every DTO field for field
  (`docs/rea/rea-proto-be/sources/2026-09-22-nhideclareverify-swagger-live.json.md@25ea24c3d433`
  L1303, `SaveRuleRequest`; browsable: [Swagger page](nhideclareverify-swagger-2026-09-22.html)) —
  so it runs this code or a build with the same contract; which commit is not knowable from
  outside. It is the host the data-creator plan's output is posted to
  ([plan](../plans/rea-proto-data-creator-setup.md)). Stopped since 2026-09-30 (`403`; rea-ui ›
  Deployment). It ran this code in `Development` on this seed: its last answers
  (`sources/2026-09-30-post-payment-*.json.md`) equal a replay (plan payment-mock).
- **The template the project manager points to is this service's data.** `REA_PROTO`'s
  `tests/mock/api/rulesSpecificSetting.json` has the shape of `UiTemplate/RulesSpecificSetting/Get`
  ([rea-proto](../rea-proto/index.md)); here that body is an opaque MongoDB document
  (`Services/UiTemplateService.cs:38-43`), so this repository does not contain the forms themselves.
- **Not the kernel.** `REA_kernel` and this service both turn numbered rule codes into RulesEngine
  checks (`REA_kernel@e5ba92e src/Model/NHI.Model.ClaimValidator/NHI.Model.ClaimValidator.csproj:14`),
  but no file links them: neither names the other's types (`RuleSchema`/`RuleNode` there,
  `UiRule`/`Condition`/`pbabDtlOrdModel` here; grep both ways, no match). A shared code number is not
  evidence of shared logic — compare the generator with the kernel's code before assuming so.
