# 2026-10-02 | claude | rea | rea-proto-data-creator-kernel

## Task
Owner wants `REA_PROTO_DATA_CREATOR` to also produce bodies for `REA_kernel`'s validation (today it
serves `REA_PROTO_BE` only); attaches the swagger skeleton and an example of `POST /api/v1/RuleSet`,
names the live swagger on `210.59.250.145:8080`. No signature yet, so no child write: a plan.

## Done
- Read the kernel's save path at `6540a4c`: controller (array body), the four validators in order,
  `RuleSetSL` versioning (all-or-nothing batch, duplicate `OrderCode`, earlier start date), the
  ETL worker's use of `TranslatedRules`; fetched `origin/develop` (`3c3c9fb`, no contract change).
- Fetched the live `RuleSchema` and swagger: swagger identical to the 2026-09-30 ingest; schema
  differs from 2026-09-17 in 203 only. Ingested the schema and the owner's two attachments (kernel
  sources). Store read-only: two ui-saved rows (`12116B`, `01116B`).
- Scratch: built today's prototype payloads, mapped them to kernel bodies, validated against the
  live schema the kernel's way — all pass but 61 of 307's 114 (`Required` months / end code).
- Written: plan rea-proto-data-creator-kernel (draft: mapping table, steps, 307 ruling); ruleset-api
  › Save; field-map › 值的規則; rea-kernel › Live deployment + the worker consumes `TranslatedRules`;
  rea-proto-data-creator › the kernel contract.
- On the owner's word (in session): index cap 80 → 100 on `main` (`c6ef647`, workspace log
  index-cap), `rea` rebased onto it — the index sat at exactly 80 before this plan's line.

## Decisions & pitfalls
- 301 `GenderCode` and 205/206 `SpecialistCodes` are `String` in the kernel, arrays in the prototype;
  307's months are `Number`; `prefixRange` and `employmentType` have no kernel field.
- `CompareField` only compares numbers, so 307's `RangeEnd1 >= RangeStart1` never fires; 302's
  `Max > Min` is strict — no row in the export has min == max.
- The kernel's `docs/ruleSetExample` at `6540a4c` still show the old shapes; do not copy them.
- The kernel docs' paths in rea-kernel › The schema (`DTO…/POCO`) are stale: POCO and validators
  live under `src/Model/…` and `src/API/…/Validation/` — not fixed, other task's text.

## TODO
- Owner: rule on 307 (plan step 5 — recommended: ask the kernel team to drop `Required`), confirm
  202 `DoctorRole "FullTime"`, then `Writes:` + `Signed:` on the plan; I then ship steps 1–4.
- Owner: 306-main-setting, rea-proto-data-creator-setup, payment-snapshot, reference-groups await
  `Verified:`; push `rea`.
- [workspace] `check` could print the wrapped count of a file it fails, saving a `fold` round trip.
