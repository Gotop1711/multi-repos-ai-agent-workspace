# 2026-10-07 | claude | rea | ui-helpers-vs-utils

## Task
Owner, mid-way through `HospitalDataUploadPanel.vue` and a csv→json function in `REA_UI`
(uncommitted on `develop`), asks: helper or util? does `src/api/caseTransform.js` move? what to
change? Advice and a plan; the child was not touched.

## Done
- Regulation read whole for a helpers/utils criterion: none. Front-end chapter glosses both as 工具函式
  (R L650, L653); the .NET chapter treats `Utilities / Helpers` as one item (R L2481) and bans a
  catch-all `CommonUtils` (R L3674); the Node chapter has `utils/` only (R L8153, L8181–8189).
- The repo's own split (leaf domain-free `helpers/`, feature-grouped `utils/`, `caseTransform` an
  `api/` boundary concern that the BFF will absorb) derived from imports → rea-ui › Folders.
- Owner named the kernel as the receiver. Read `REA_kernel@8b852f3` (four new commits, none on the
  job API): `POST /api/v1/ValidationJob` takes `List<ClaimBatchKey>` — the CSV's own column names in
  PascalCase, `DateTime` dates, `OrderCode` optional — and answers `[{ id }]`; OData `GET` is the only
  read; the kernel's `docs/ValidationJob.md` lists two endpoints that do not exist → new module
  validation-job-api.
- Plan hospital-data-upload (draft): converter to `utils/hospitalData/`, camelCase keys, dates as
  `YYYY-MM-DD`, an `api/modules/validationJob` module, the panel rebuilt, the aside wired.

## Decisions & pitfalls
- "Helper vs util" is answered by dependency direction here, not by the regulation's wording.
- The draft emits PascalCase keys and `Z`-suffixed timestamps; the ui's rule is camelCase and the
  request interceptor pascalizes (`interceptors.js:21`); the swagger run used date-only values.
- The prototype BE's JSON twin uses other names (`FeeYearMonth`, `ApplyType`); irrelevant now the
  target is the kernel, but a reason not to share a converter between the two.
- `check`: rea-kernel's doc sits exactly at its cap (pointer folded into an existing line); a body
  line starting `Status:` in a plan is read as a lifecycle line.
- The closeout pushed `rea` to origin by mistake; `rea` is pushed only on the owner's word.

## TODO
- Owner: sign plan hospital-data-upload; `git push origin --delete rea` if the remote branch is unwanted.
- The `Z`-timestamp vs `DateTime.Kind` effect on the kernel's claim query is inferred, untested.
