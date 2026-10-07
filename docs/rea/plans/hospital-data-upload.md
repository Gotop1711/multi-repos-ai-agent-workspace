# rea — hospital-data-upload

Status: draft

## Goal
The right drawer's first real panel: the user drops a 院所資料 CSV (`HOSP_ID, HOSP_DATA_TYPE,
FEE_YM, APPL_TYPE, APPL_DATE[, ORDER_CODE]`, dates `M/d/yyyy` — the prototype back end's own batch
file, declare-verify › Part 3, `REA_PROTO_BE@ba161ff Services/ValidationJob/ValidationJobCsvParser.cs:95`)
and a validation job is created from it. The owner's 2026-10-07 draft (uncommitted on `develop` over
`REA_UI@b7e7073`: `components/rules/HospitalDataUploadPanel.vue`, `csvToJson` in `utils/common.js`,
its test, the aside button wired to the panel) is the starting point. Rests on rea-ui › Folders and
› Layout.

**Open decision, the owner's, before signing — which backend receives the batch:**
- (a) prototype BE `POST ValidationJob/Batch/File`: post the `File` as multipart, no conversion in
  the browser (`api/request.js` already has `objectToFormData`; `caseTransform` leaves `File` alone);
- (b) prototype BE `POST ValidationJob/Batch`: JSON items named `HospId, HospDataType, FeeYearMonth,
  ApplyType, ApplyDate, OrderCode` (`REA_PROTO_BE@ba161ff Services/ViewModels/CreateValidationJobRequest.cs:8-43`),
  the two dates `DateOnly` — so `YYYY-MM-DD`, not a full ISO timestamp (inferred from the .NET type);
- (c) kernel `POST /api/v1/ValidationJob`: input 尚待確認 (`REA_kernel@7f9936f docs/ValidationJob.md:214`);
  the deployed image proxies every `/api/*` to the kernel (ui-deployment), so (a)/(b) need a route.
With (a) the converter is not needed; with (b) it becomes an explicit column map, not a generic
SCREAMING_SNAKE→PascalCase rename, because `FEE_YM`→`feeYearMonth`, `APPL_*`→`apply*`.

## Writes
`REA_UI` (`develop`).

## Steps
1. `chore(ui): hospital-data csv module` — move `csvToJson` and its private parser out of
   `src/utils/common.js` (restore that file to `b7e7073`) into `src/utils/hospitalData/csv.js`; the
   test to `tests/unit/utils/hospitalData/csv.test.js`. Keys camelCase (the ui's rule,
   `src/api/caseTransform.js:1-3`; the request interceptor PascalCases on the wire,
   `src/api/interceptors.js:21`), named by the column map of the chosen backend; dates in the form
   that backend binds. Keep the RFC 4180 parser private until a second caller exists. Skip this step
   entirely under (a).
2. `feat(ui): validation-job api module` — `src/api/modules/validationJob/{index,types}` per the
   regulation's `api/modules/<name>/` (nhia-frontend-standard › Project layout): one function for
   the chosen endpoint, plus status polling if the panel shows progress.
3. `feat(ui): HospitalDataUploadPanel` — replace the stub: `accept=".csv"`, `:auto-upload="false"`,
   `:limit="1"`, no placeholder `fileList`; read `file.raw` with `File.text()`, show row count and
   parse errors in the drawer, submit through step 2, then `emit('close', result)` so the aside's
   `open()` promise resolves (usage in `src/composables/useRightDrawer.js:9-24`). Move the file to
   `src/components/drawers/`, the folder that header names, or amend the header — one or the other.
   Component test with `@vue/test-utils` (the regulation's test stack, R L5533).
4. `feat(ui): open the upload panel from the aside` — the one-line `DefaultLayout.vue` change already
   in the draft, with `size` set; nothing else in the layout (plan ui-layout-routing owns the rest).
`npm run lint`, `npx vitest run` green at every commit.

## Done when
In `npm run dev` against the chosen backend: aside button → drawer titled 院所資料上傳 → drop the
prototype's sample CSV → a job is created and its id or status appears → × closes and the drawer
resets. A CSV with a bad date or a missing column is refused in the drawer with the row named.
`src/utils/common.js` is unchanged from `b7e7073`.
