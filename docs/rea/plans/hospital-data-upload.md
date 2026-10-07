# rea — hospital-data-upload

Status: shipped
Writes: REA_UI (develop)
Signed: gotop1711 — 2026-10-07
Shipped: 2026-10-07 — REA_UI@652f853, REA_UI@7827302, REA_UI@180231a, REA_UI@a446ca2, and the owner's REA_UI@69266f1, REA_UI@bdd28ec (develop, unpushed)

## Goal
The right drawer's first real panel: the user drops a 院所資料 CSV (`HOSP_ID, HOSP_DATA_TYPE,
FEE_YM, APPL_TYPE, APPL_DATE[, ORDER_CODE]`, dates `MM/dd/yyyy` or `yyyy/MM/dd`, month and day zero-padded — the owner's rule) and the ui creates one kernel
validation job per row through `POST /api/v1/ValidationJob` (validation-job-api,
`REA_kernel@8b852f3 …/Jobs/ClaimBatchKey.cs:14-21`), then shows the returned job ids. The owner's
2026-10-07 draft (uncommitted on `develop` over `REA_UI@b7e7073`: `components/rules/HospitalDataUploadPanel.vue`,
`csvToJson` in `utils/common.js`, its test, the aside button wired to the panel) is the starting
point. The receiving backend is the kernel (owner, 2026-10-07; the swagger run that day created a job
from exactly this shape). Rests on rea-ui › Folders and › Layout.

What the kernel fixes: keys `HospId, HospDataType, FeeYm, ApplType, ApplDate, OrderCode` — the CSV
headers SCREAMING_SNAKE→PascalCase, so the draft's generic rename is right; the five required; dates
bind to `DateTime`, sent date-only `YYYY-MM-DD` as in the swagger run, not the draft's
`T00:00:00.000Z`; `OrderCode` omitted or null when the column is blank. Response `[{ id }]`.
Job status: `GET /api/v1/ValidationJob?$filter=Id eq '<id>'` — the only read endpoint today.

## Writes
`REA_UI` (`develop`).

## Steps
1. `chore(ui): hospital-data csv module` — take the draft's `csvToJson` out of `src/utils/common.js`
   (restore that file to `b7e7073`). A generic `csvToJson` goes to `src/helpers/csv.js` (owner's
   choice): RFC 4180 quoting, BOM, CRLF, blank lines; returns `{ headers, headerLine, rows: [{ line,
   record }] }`, values as strings, no domain rule; its parser stays private. On it,
   `src/utils/hospitalData/csv.js` exports `parseHospitalDataCsv` with the file's rules. Tests beside
   each: `tests/unit/helpers/csv.test.ts`, `tests/unit/utils/hospitalData/csv.test.js`. Keys camelCase in the browser (the ui's rule,
   `src/api/caseTransform.js:1-3`; the request interceptor PascalCases on the wire,
   `src/api/interceptors.js:21`, which yields the kernel's exact names); date fields accepted only as
   `MM/dd/yyyy` or `yyyy/MM/dd`, emitted as `YYYY-MM-DD`, anything else a row error; blank `orderCode` → omitted.
2. `feat(ui): validation-job api module` — `src/api/modules/validationJob/{index,types}` per the
   regulation's `api/modules/<name>/` (nhia-frontend-standard › Project layout): `createValidationJobs(rows)`
   → `POST /api/v1/ValidationJob`, and `getValidationJobs({ ids })` → the OData `$filter` for status.
   Mock entries in `mock/` so `VITE_USE_MOCK=true` still runs.
3. `feat(ui): HospitalDataUploadPanel` — replace the stub: `accept=".csv"`, `:auto-upload="false"`,
   `:limit="1"`, no placeholder `fileList`; read `file.raw` with `File.text()`, show row count and
   the rows that fail (missing required column, bad date) with their line numbers, submit through
   step 2, list the returned ids, then `emit('close', ids)` so the aside's `open()` promise resolves
   (usage in `src/composables/useRightDrawer.js:9-24`). The panel is host-agnostic and sits directly in
   `src/components/`; the composable header's example path says so (owner's placement, in session). Component test with
   `@vue/test-utils` (the regulation's test stack, R L5533).
4. `feat(ui): open the upload panel from the aside` — the one-line `DefaultLayout.vue` change already
   in the draft, with `size` set; nothing else in the layout (plan ui-layout-routing owns the rest).
`npm run lint`, `npx vitest run` green at every commit.

## Done when
In `npm run dev` against the kernel: aside button → drawer titled 申報資料上傳 → drop a CSV with the
six columns → one job id per row appears in the drawer and `GET /api/v1/ValidationJob` lists them →
× closes and the drawer resets. A CSV with a bad date or a missing required column is refused in the
drawer with the row named, and nothing is posted. `src/utils/common.js` is unchanged from `b7e7073`.
