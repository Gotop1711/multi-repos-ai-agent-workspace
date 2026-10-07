# rea / validation-job-api

The kernel's validation-job contract: how the ui asks `REA_kernel` to check a declaration batch and
how it learns the outcome. Cited at `REA_kernel@8b852f3` (`develop`), paths under `src/`. The kernel's
own `docs/ValidationJob.md` describes the worker side and, at `:206-208`, two read endpoints that do
not exist in the controller; the controller is the evidence here. The ui side is plan
hospital-data-upload; the prototype's older equivalent (`ValidationJob/Batch`, CSV upload) is
declare-verify › Part 3.

## Create — `POST /api/v1/ValidationJob`
- Body: a JSON array of `ClaimBatchKey` (`API/NHI.API.ClaimValidator/Controllers/V1/ValidationJobApiController.cs:21-22`),
  a record of `HospId`, `HospDataType`, `ApplType` (strings), `FeeYm`, `ApplDate` (`DateTime`), all
  five `[JsonRequired]`, and `OrderCode` (`string?`, default null — null means the whole batch, a value
  means that 醫令 only) (`Model/NHI.Model.ClaimValidator/POCO/V1/Jobs/ClaimBatchKey.cs:14-21`).
- Names are exact: `PropertyNamingPolicy = null` (`API/NHI.API.ClaimValidator/Program.cs:10`), so the
  wire is PascalCase, which the ui's request interceptor produces from camelCase (rea-ui › Folders).
  These are the 資料表檔 column names `HOSP_ID, HOSP_DATA_TYPE, FEE_YM, APPL_TYPE, APPL_DATE, ORDER_CODE`
  in PascalCase.
- One job per element, status `Pending` (`Service/NHI.Service.DTO.ClaimValidator/Implementation/V1/ValidationJobSL.cs:11-19`);
  the answer is `200` with `[{ "id": "<ObjectId>" }]`, lowercase `id` from an anonymous object
  (`ValidationJobApiController.cs:24-25`). The owner's swagger run on 2026-10-07 posted one element
  with `FeeYm`/`ApplDate` as `2026-10-07` and got one id back.
- Dates: the worker hands `FeeYm` and `ApplDate` unchanged to the claim query
  (`ETL/NHI.ETL.ClaimValidator/Workers/ClaimValidationWorker.cs:113`, `IClaimDataSL.cs:20`). A date-only
  string binds with `Kind = Unspecified`, like the mock data's `new DateTime(2026, 4, 1)`
  (`Service/NHI.Service.DAO.ClaimValidator/Implementation/V1/MockClaimSL.cs:117`); a `Z`-suffixed
  timestamp binds as UTC. Whether that changes the query's matches is not tested — inferred: send
  `YYYY-MM-DD`.

## Read — `GET /api/v1/ValidationJob`
- The only read endpoint: an OData query over every `ValidationJob`, `$filter`, `$orderby`, `$top`,
  `$skip` allowed (`ValidationJobApiController.cs:31-33`). No `/{id}` route and no result endpoint;
  `ClaimResult` rows (`POCO/V1/Jobs/ClaimResult.cs`) are reachable by no controller today.
- A row: `Id`, `ClaimBatch` (the key above), `Status` (`ValidationJobStatusEnum`, starts `Pending`),
  `RetryCount`, `LockedBy`, `LockedAt`, `CreatedAt`, `UpdatedAt`, `CompletedAt`, `ErrorMessage`
  (`POCO/V1/Jobs/ValidationJob.cs:15-45`). So the ui polls with `$filter=Id eq '<id>'`.
