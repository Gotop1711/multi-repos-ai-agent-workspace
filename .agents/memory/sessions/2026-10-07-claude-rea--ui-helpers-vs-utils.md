# 2026-10-07 | claude | rea | ui-helpers-vs-utils

## Task
Owner, mid-way through `HospitalDataUploadPanel.vue` and a csv→json function in `REA_UI`
(uncommitted on `develop`), asks: helper or util? does `src/api/caseTransform.js` move? what to
change? Advice and a plan; the child was not touched.

## Done
- Regulation read whole for a helpers/utils criterion: none (R L650, L653; .NET treats them as one
  item, R L2481, bans a catch-all `CommonUtils`, R L3674; Node has `utils/` only, R L8153).
- Repo's own split (domain-free leaves in `helpers/`, features in `utils/`, `caseTransform` an `api/`
  boundary concern the BFF will absorb) derived from imports → rea-ui › Folders.
- Owner named the kernel as receiver. `REA_kernel@8b852f3`: `POST /api/v1/ValidationJob` takes
  `List<ClaimBatchKey>` (the CSV's names in PascalCase, `DateTime` dates), answers `[{ id }]`; OData
  `GET` is the only read; its own doc lists two absent endpoints → module validation-job-api.
- Signed; shipped on `develop`: `652f853` csv (generic `helpers/csv.js` + hospital rules; dates only
  `MM/dd/yyyy`|`yyyy/MM/dd`), `7827302` api, `180231a` panel at `src/components/`, `a446ca2` aside;
  the owner's `69266f1` style, `bdd28ec` title replayed as-is. 1141 tests, lint clean.

## Decisions & pitfalls
- "Helper vs util" is answered by dependency direction here, not by the regulation's wording.
- The draft emitted PascalCase keys and `Z` timestamps; the ui is camelCase, the interceptor
  pascalizes, but only on the paths in `KERNEL_API_PATTERN`: a new kernel endpoint must be added.
- Kernel serialises job `Status` as a number (no enum converter).
- A kept `csvToJson` had no runtime caller (owner spotted it); now generic in `helpers/`, returning
  lines and headers, and the hospital parser builds on it.
- Owner's corrections (placement, dates, csv layering) folded into unpushed commits, not stacked.
- `check` reads a plan body line starting `Status:` as a lifecycle line.
- The closeout pushed `rea` to origin by mistake; `rea` is pushed only on the owner's word.

## TODO
- Owner: Done-when in the browser against the kernel (drop a CSV, ids appear, bad row refused), push
  `develop`, then `Verified:`; `git push origin --delete rea` if the remote branch is unwanted.
- The `Z`-timestamp vs `DateTime.Kind` effect on the kernel's claim query is inferred, untested.
