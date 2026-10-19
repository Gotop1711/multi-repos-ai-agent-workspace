# rea / translator

How a saved `RuleSet` becomes RulesEngine rules, and how far that reaches: which codes and which 檢核範圍
conditions translate at `REA_kernel@1706cb5` (`develop`, 2026-10-19). Paths under
`src/Service/NHI.Service.DTO.ClaimValidator/Implementation/V1/Translator/V1.1/` unless stated; inferred from
source, no save executed. What the ui sends: ruleset-api; the menu the conditions come from: scope-conditions.

## Reach
- **201, 203 and 204; any other code is stored untranslated.** `RuleSetSL` fills `LogicExpression`, `Codes`, `Conditions` from the tree, then runs the latest translator — `1.1` since `851bbb3` (2026-09-29), whose `BuildCodeRules` handles `"201"`, `"203"` and, since `f71e54d` (2026-10-19), `"204"` (`Implementation/V1/Translator/V1.1/RuleSetTranslator.cs:280-284` at `1706cb5`) and whose condition leaves handle twelve of the thirteen conditions since `667734c` (2026-10-13; `RuleSetTranslator.Condition.cs:68-119`) — every one but `Robotic`, hence its flag. The twelve: `CaseType`, `HospCode` (compared to `HospDataType`), `OrderType`, `Department`, `Level` (`HospGType`), `RelMode` by `{Field}Options` membership; `PartCode`, `TreatmentArea`, `TreatmentItems` (`CureItem1-4`), `SubMainDiagnosisCode` (22 ICD fields) by 類別 — codes, prefix (`InputPrefix` + `PrefixLen`) or range — with 類別 `04` 群組 refused (`:458`); `Age` by 基準日 `01`–`05` only (`:363-373`); `AssociatedItems` against `ReferenceDetailOrderCodes`, which the ETL fills per 清單 (`ClaimDataSL.cs:342-372`, `FillAsync` now takes `Conditions`). 204 (`RuleSetTranslator._204.cs:28-96`): `MHAT_PRSN_DEGREE` rows loaded per claim for `PrsnId` and `ExePrsnId` (`ClaimDataSL.cs:604-627`), the person taken in `DoctorTypes` order — `01` → `ExePrsnId`, `02` → `PrsnId`, `03` throws — and a `QualificationCodes` degree with `TxtMark` A/U must be valid on the 參考日期 (shared `RuleSetTranslator.ReferenceDate.cs`). Any other code or field throws `NotSupportedException`, which `RuleSetSL` catches since `a63ad16` (2026-09-18): the row is saved with `TranslatedRules` / `TranslatorVersion` null「待該 Code 補上 Translator 後重新整批 retranslate」(`Implementation/V1/RuleSetSL.cs:126-146`) — the 500 that `458e663` answered for every code but 201 is gone; any other exception still 500s (`API/NHI.API.ClaimValidator/ExceptionHandling/GlobalExceptionHandler.cs:20`, `:29`). 203 requires `Reference["ReferenceDates"]` in the shape `851bbb3` introduced (ruleset-api › `Reference`). So 201's `Disabled` set is exactly the translator's gap; the other codes carry no flag because no condition of theirs translates at all. Cited at `6540a4c`; inferred from source, no save executed.

## What the ETL does with it
- **`TranslatedRules` is consumed by the ETL worker.** Per order code and effective date it loads the effective row, deserializes `TranslatedRules` into `EngineRule`s and runs RulesEngine; a blank one throws「缺少 TranslatedRules」, only *no row* becomes `NoRule` (`src/ETL/NHI.ETL.ClaimValidator/Workers/ClaimValidationWorker.cs:85-127`, `:223-252`); `ClaimDataSL.FillAsync` fills per `Codes`, `"203"` the only case (`Implementation/V1/ClaimDataSL.cs:277-290`). `Properties["Name"]` has no reader. The one thing that reads engine rule names, `RuleResultAttributionParser.Parse`, hard-requires the **unsuffixed** `Rule_{Code}` and its unsuffixed `_Skip` / `_Main` / `_Guard` children (`Translator/RuleResultAttributionParser.cs:22-27,54,80-92`) — see plan translated-rule-names.

## History
- `745ebc2` (2026-09-15) the 1.0 translator, 201 only; `851bbb3` (2026-09-29) 1.1 with 203 and the
  `Reference` groups; `a63ad16` (2026-09-18) `NotSupportedException` stops 500ing; `667734c`
  (2026-10-13) the twelve conditions and the fields they need (`ClaimData.cs`, `PbabHpDtl.cs`,
  `PbabOpDtl.cs`, `OracleDbContext.cs:113-116`, `:136`, `:235`); `f71e54d` (2026-10-19) 204 and the
  shared 參考日期 builder (`RuleSetTranslator.ReferenceDate.cs`, 203's own copy removed);
  `4b889a8` (2026-10-19) 基準日 `06`–`08` dropped from `ClaimData` (「測試機 DB 無此欄位」) and flagged
  `Disabled`. Tests: `test/NHI.Test.ClaimValidator/RuleSetTranslatorConditionV1_1Tests.cs`,
  `RuleSetTranslatorQualificationV1_1Tests.cs`, `ClaimDataSLFillDegreeTests.cs`,
  `ClaimDataRequirementTests.cs` (not run here: inspect, not execute).
