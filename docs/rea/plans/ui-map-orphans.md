# rea — ui-map-orphans: every UI-map key names a field the kernel serves

Status: draft

## Goal
Nine keys in `REA_UI@411c809 src/utils/rule/ruleUIConfig.ts` name no field in the served schema, and
`applyUIMapToBlock` matches the map *by* the served field id — so each costs an input that never
renders, silently (`src/utils/rule/ruleSchemaUtils.js:111`, `:155`, `:190`; rule-editor › Field
names). Five are already carried elsewhere: 105 `mainSetting` for `Note` (rule-codes), 205 and 206
`doctorRole` + `employmentType` (plan ui-205-206-stale-fields). This plan is the other four,
observed against `REA_kernel@458e663` and the deployment of 2026-09-11
(`docs/rea/rea-kernel/sources/2026-09-11-ruleschema-live.json.md@548ac767c5d8`):

1. **201 `referenceDates`** (`ruleUIConfig.ts:105`). `_201.cs` dropped its whole `ReferenceFields`
   block between `2ff26b0` and `458e663` (rea-kernel); the 2026-09-11 deployment still served it, the
   2026-09-17 one does not, so 201's 參考日期 selector no longer renders. Whether 201 should
   keep the field is a kernel question — it is the one code of twenty with no `ReferenceFields`.
2. **307 `prefixLength` and `monthUnit`** (`:387`, `:392`, in `subFieldWidths.diagnosisCodes`). The
   served `DiagnosisCodes` `ObjectArray` has exactly four `SubFields` — `RangeStart1`, `RangeEnd1`,
   `RangeStart2`, `RangeEnd2` (`Codes/V1.0/_307.cs:17-61`); the other four width overrides match.
   The two names come from the prototype's block 307, which has `prefixRange` and `monthStart` /
   `monthEnd` (`REA_PROTO@3fdf47c tests/mock/api/rulesSpecificSetting.json`).
3. **`prefixLen` and `prefixRange` in four scope conditions** — `subMainDiagnosisCode`, `partCode`,
   `treatmentArea`, `treatmentItems` (`ruleUIConfig.ts:466-467`, `:484-485`, `:503-504`, `:555-556`).
   None of the four `Conditions` carries a prefix-length field; `PrefixLen` exists only in 305 and
   306 `MainFields` (`grep` over `Codes/V1.0/`). Both names are the prototype's inputIds
   (`REA_PROTO@3fdf47c tests/mock/api/rulesScopeSetting.json:11`, `:79`), so 檢核範圍's 「前 N 碼」
   box has never rendered in any of the four — the 開頭 and 開頭範圍 modes show their text inputs
   with no length beside them.

Whether each gap closes ui-side (drop the dead key) or kernel-side (serve the field) is the ruling
this plan needs; 1 and 3 look like missing kernel fields, 2 like dead copy. `REA_kernel` is
read-only, so any kernel half ends as a request.

## Writes
`REA_UI (debug-ui)` for whatever the ruling drops or renames. Nothing in `REA_kernel`: a field it
should serve is a request to its owners, carried here and closed as
`Abandoned: — decided: requested …`.

## Steps
1. Owner/PM ruling per group: does the field belong, and on which side?
2. Ui-side: remove or rename the dead keys; a test that every `mainSettingUIMap` and
   `scopeSettingUIMap` key matches a `Value` in `mock/rulesData.js` would catch the next one — the
   mock is diffed against the served schema already (rule-editor › Tests).
3. Kernel-side: the request, fields in kernel PascalCase.
4. `npx vitest run` and `npm run lint` clean.

## Done when
No key in either UI map names a field the served schema lacks, the guard test pins it, and 201's
參考日期 and 檢核範圍's 前 N 碼 render or are gone by decision rather than by accident.
