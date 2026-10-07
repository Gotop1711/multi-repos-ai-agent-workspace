# 2026-10-07 | claude | rea | ui-helpers-vs-utils

## Task
Owner, mid-way through `HospitalDataUploadPanel.vue` and a csv→json function in `REA_UI`
(uncommitted on `develop`), asks: helper or util? and should `src/api/caseTransform.js` move to
`helpers/` or `utils/`? Advice only; the child was not touched.

## Done
- Read the regulation (R L627–653): `helpers/ - 工具函式`, `utils/ - 工具函式集` — no criterion. Searched
  the whole text layer: the .NET chapter lists `Utilities` and `Helpers` as one item「工具類」(R L2481) and
  bans a catch-all `CommonUtils` (R L3674); the Node/BFF chapter has `utils/` only, with naming rules
  (R L8153, L8181–8189). No chapter says which methods go where.
  Derived the repo's own split from imports and recorded it in rea-ui › Folders.
- Answered: `csvToJson` is domain code (NHIA export headers, `M/d/yyyy` dates) → `utils/<feature>/`,
  not `common.js`; `caseTransform.js` stays in `api/` (boundary concern, BFF-bound).
- Found while reading: the prototype BE already parses this CSV (`POST ValidationJob/Batch/File`,
  declare-verify › Part 3) and its JSON twin names `FeeYearMonth`/`ApplyType`/`ApplyDate`, not the
  header-derived `FeeYm`/`ApplType`/`ApplDate` the draft emits; the kernel's job input is 尚待確認
  (`REA_kernel@7f9936f docs/ValidationJob.md:214`). Reported to the owner, not filed as a plan — the
  panel's target backend is the owner's call.

## Decisions & pitfalls
- "Helper vs util" is answered by dependency direction here, not by the regulation's wording.
- The draft emits PascalCase keys in the browser; the repo's rule is camelCase in the ui and the
  request interceptor pascalizes on the way out (`interceptors.js:21`). Flagged.

## TODO
- Owner: decide the panel's target (prototype BE file upload vs JSON vs kernel) and sign plan
  hospital-data-upload (draft, filed this session: four commits, the converter skipped under file upload).
