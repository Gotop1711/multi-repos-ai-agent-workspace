# rea / field-map

本文逐筆列出每一個規則對話框的每一個欄位，以 kernel 的名稱對照 ui 的名稱 — 用途是確認某個名稱，或
確認它在另一側沒有對應。kernel 取自 `REA_kernel@458e663`（`Specification/V1/Codes/V1.0/_<code>.cs`），
ui 取自 `REA_UI@411c809`（`src/utils/rule/ruleUIConfig.ts`），prototype 取自 `REA_PROTO@3fdf47c`。

**對應關係只有一條規則，沒有例外**：ui 的識別字就是 kernel 的 `Value` 把第一個 ASCII 字母轉為小寫，
兩個方向皆然。執行這項轉換的兩層機制、它們不動的東西（`options[].value` 屬於資料，永不轉換），以及
往返為何可逆，見 rule-editor › Field names。以下表格即是這條規則的逐筆展開 — 查表是為了確認名稱、或
找出沒有對應的名字，不必在表中尋找特例，因為並不存在特例。

`子群組` 欄標示該欄位被渲染在哪一個 ui 專屬的子群組；由哪個選項觸發、以及它讀起來是什麼句子，見
rule-codes。被多個子群組共用的欄位只有一個值，只列一次。

## 主設定 MainFields

| code | kernel `Value` | REA_UI | kernel `Label` | 子群組 |
|---|---|---|---|---|
| 101 計畫代碼或特定醫院資格 | `PlanCodes` | `planCodes` | 計畫代碼 |  |
| 102 服務項目代碼 | `ServiceCodes` | `serviceCodes` | 服務項目代碼 |  |
| 103 診療科別 | `DeptCodes` | `deptCodes` | 診療科別 |  |
| 104 評鑑等級代號 | `GradeCodes` | `gradeCodes` | 評鑑等級代號 |  |
| 105 需事前報備 | `Note` | `note` | 說明 |  |
| 106 限制特殊設備 | `EquipmentCodes` | `equipmentCodes` | 特殊設備 |  |
| 201 限制申報科別 | `DeptCodes` | `deptCodes` | 申報科別 |  |
| 202 限專科醫師別 | `SpecialistCodes` | `specialistCodes` | 專科醫師別 |  |
|  | `DoctorRole` | `doctorRole` | 執行醫師 |  |
| 203 醫事人員類別 | `PersonnelTypes` | `personnelTypes` | 醫事人員類別 |  |
| 204 限醫事人員資格 | `QualificationCodes` | `qualificationCodes` | 醫事人員資格 |  |
| 205 限專任醫師處方 | `SpecialistCodes` | `specialistCodes` | 專科醫師別 |  |
| 206 限專任醫師執行 | `SpecialistCodes` | `specialistCodes` | 專科醫師別 |  |
| 301 適用性別 | `GenderCode` | `genderCode` | 性別 |  |
| 302 適用年齡 | `MinOp` | `minOp` | 下限符號 |  |
|  | `Min` | `min` | 最小值 |  |
|  | `MaxOp` | `maxOp` | 上限符號 |  |
|  | `Max` | `max` | 最大值 |  |
|  | `Unit` | `unit` | 單位 |  |
| 303 限制申報頻率 | `FrequencyType` | `frequencyType` | 頻率類型 |  |
|  | `Weeks` | `weeks` | 週數 | weekLimit |
|  | `Period` | `period` | 期間長度 | dayMonthYearLimit/intervalLimit/samePartLimit |
|  | `PeriodUnit` | `periodUnit` | 期間單位 | dayMonthYearLimit/intervalLimit/samePartLimit |
|  | `Max` | `max` | 次數上限 | countLimit/weekLimit/dayMonthYearLimit/intervalLimit/samePartLimit |
|  | `IntervalValue` | `intervalValue` | 間隔長度 | intervalLimit |
|  | `IntervalUnit` | `intervalUnit` | 間隔單位 | intervalLimit |
| 304 限制申報次數 | `CountLimitType` | `countLimitType` | 次數限制類型 |  |
|  | `Period` | `period` | 期間長度 | timePeriodExceedLimit/samePartTimePeriodLimit/timesLimit |
|  | `PeriodUnit` | `periodUnit` | 期間單位 | timePeriodExceedLimit/samePartTimePeriodLimit/timesLimit |
|  | `Max` | `max` | 次數上限 | lifeTimeLimit/singleDeclareLimit/exceedLimitWithTreatment/timePeriodExceedLimit/doubleExceedLimit/visitCountExceedLimit/samePartTimePeriodLimit/perOutpatientLimit/emergencyDeclareLimit/timesLimit |
|  | `OverTimes` | `overTimes` | 超過次數 | doubleExceedLimit |
|  | `OrderCode` | `orderCode` | 診療項目 | exceedLimitWithTreatment/timePeriodExceedLimit/doubleExceedLimit/visitCountExceedLimit |
|  | `VisitType` | `visitType` | 就診類別 | perOutpatientLimit/emergencyDeclareLimit |
|  | `BloodTransfusionOnce` | `bloodTransfusionOnce` | 輸血限制 |  |
| 305 不得同時申報項目 | `BodyPart` | `bodyPart` | 部位 |  |
|  | `BodyPartCategory` | `bodyPartCategory` | 部位代碼類別 |  |
|  | `BodyPartPrefixLen` | `bodyPartPrefixLen` | 部位前幾碼 | bodyPartPrefix/bodyPartRange |
|  | `BodyPartRangeStart` | `bodyPartRangeStart` | 部位起始值 | bodyPartRange |
|  | `BodyPartRangeEnd` | `bodyPartRangeEnd` | 部位結束值 | bodyPartRange |
|  | `BodyPartCodes` | `bodyPartCodes` | 部位代碼 | bodyPartCode |
|  | `BodyPartPrefix` | `bodyPartPrefix` | 部位開頭值 | bodyPartPrefix |
|  | `BodyPartGroup` | `bodyPartGroup` | 部位群組 | bodyPartGroup |
|  | `OrderCategory` | `orderCategory` | 併同申報項目類別 |  |
|  | `OrderPrefixLen` | `orderPrefixLen` | 併同申報項目前幾碼 | orderPrefix/orderRange |
|  | `OrderRangeStart` | `orderRangeStart` | 併同申報項目起始值 | orderRange |
|  | `OrderRangeEnd` | `orderRangeEnd` | 併同申報項目結束值 | orderRange |
|  | `OrderCodes` | `orderCodes` | 併同申報項目代碼 | orderCode |
|  | `OrderPrefix` | `orderPrefix` | 併同申報項目開頭值 | orderPrefix |
|  | `OrderGroup` | `orderGroup` | 併同申報項目群組 | orderGroup |
| 306 需同時併報項目 | `DiagnosisCategory` | `diagnosisCategory` | 主診斷代碼類別 |  |
|  | `DiagnosisPrefixLen` | `diagnosisPrefixLen` | 主診斷代碼前幾碼 | diagnosisPrefix/diagnosisRange |
|  | `DiagnosisRangeStart` | `diagnosisRangeStart` | 主診斷代碼起始值 | diagnosisRange |
|  | `DiagnosisRangeEnd` | `diagnosisRangeEnd` | 主診斷代碼結束值 | diagnosisRange |
|  | `DiagnosisCodes` | `diagnosisCodes` | 主診斷代碼代碼 | diagnosisCode |
|  | `DiagnosisPrefix` | `diagnosisPrefix` | 主診斷代碼開頭值 | diagnosisPrefix |
| 307 適應症診斷碼限制 | `DiagnosisCodes` | `diagnosisCodes` | 診斷碼條件 |  |
|  | `DiagnosisScope` | `diagnosisScope` | 篩選範圍 |  |
| 401 門住診限制 | `VisitTypes` | `visitTypes` | 門住診限制 |  |

## 參考欄位 ReferenceFields

| kernel `Value` | REA_UI | kernel `Label` | 出現於 |
|---|---|---|---|
| `ReferenceDates` | `referenceDates` | 參考日期 | 101, 102, 103, 104, 105, 106, 202, 203, 204, 205, 206, 302, 303, 304, 305, 306, 307 |
| `HospCodes` | `hospCodes` | 醫事機構代號欄位 | 106, 202, 203 |
| `DoctorTypes` | `doctorTypes` | 醫師角色 | 202, 205, 206 |
| `AgeReference` | `ageReference` | 出生日期來源 | 302, 307 |
| `DoctorType` | `doctorType` | 醫師類別 | 103 |

## 307 `DiagnosisCodes` 的 SubFields

| kernel `Value` | REA_UI | kernel `Label` |
|---|---|---|
| `RangeStart1` | `rangeStart1` | 起始值 |
| `RangeEnd1` | `rangeEnd1` | 結束值 |
| `RangeStart2` | `rangeStart2` | 起始值（第二段） |
| `RangeEnd2` | `rangeEnd2` | 結束值（第二段） |

## 檢核範圍 Conditions

十三個 condition 在二十個 code 上逐欄位相同（`_101.cs` 至 `_401.cs` 全數比對）。其下欄位同樣只差首
字母大小寫，二十一個相異欄位名全部列於第四欄。

| kernel `Value` | REA_UI | kernel `Label` | 其下欄位（kernel `Value`） |
|---|---|---|---|
| `CaseType` | `caseType` | 案件分類 | `Operator`, `Category`, `CaseTypeOptions` |
| `Level` | `level` | 層級別 | `Operator`, `LevelOptions` |
| `HospCode` | `hospCode` | 醫事類別 | `Operator`, `Category`, `HospCodeOptions` |
| `OrderType` | `orderType` | 醫令類別 | `Operator`, `OrderTypeOptions` |
| `RelMode` | `relMode` | 處方調劑方式 | `Operator`, `RelModeOptions` |
| `SubMainDiagnosisCode` | `subMainDiagnosisCode` | 主次診斷代碼 | `Operator`, `FilterOptions`, `Category`, `Codes`, `InputPrefix`, `RangeStart`, `RangeEnd` |
| `PartCode` | `partCode` | 部分負擔代碼 | `Operator`, `Category`, `Codes`, `InputPrefix`, `RangeStart`, `RangeEnd` |
| `TreatmentArea` | `treatmentArea` | 診療之部位 | `Operator`, `Category`, `Codes`, `InputPrefix`, `RangeStart`, `RangeEnd`, `GroupOption` |
| `Age` | `age` | 年齡 | `ReferenceDates`, `OperatorMin`, `Min`, `OperatorMax`, `Max`, `Unit` |
| `AssociatedItems` | `associatedItems` | 清單下併報項目 | `Operator`, `Codes` |
| `TreatmentItems` | `treatmentItems` | 核定治療項目 | `Operator`, `FilterOptions`, `Category`, `Codes`, `InputPrefix`, `RangeStart`, `RangeEnd` |
| `Department` | `department` | 就醫科別 | `Operator`, `DepartmentOptions` |
| `Robotic` | `robotic` | 僅機械手臂輔助手術 | `RoboticOption` |

各條件的中間輔助層、最末層與其資料來源（資料表、寫死、使用者輸入）：scope-conditions。

## 沒有對應的名字

### REA_UI 命名了、kernel 沒有這個欄位（九個）

`applyUIMapToBlock` 以服務端的欄位 id 查表，查不到就不渲染，不報錯（rule-editor › Field names）。

| 位置（`ruleUIConfig.ts`） | REA_UI 的名字 | kernel 實際 | 追蹤於 |
|---|---|---|---|
| 105 主設定 `:94` | `mainSetting` | `Note` → `note` | rule-codes |
| 201 參考欄位 `:105` | `referenceDates` | `458e663` 起 201 無 `ReferenceFields` | ui-map-orphans |
| 205 主設定 `:130-131` | `doctorRole`, `employmentType` | 僅 `SpecialistCodes` | 205-main-fields, field-locking |
| 206 主設定 `:139-140` | `doctorRole`, `employmentType` | 僅 `SpecialistCodes` | 205-main-fields, field-locking |
| 307 `subFieldWidths` `:387`, `:392` | `prefixLength`, `monthUnit` | 僅四個 `Range*` 子欄位 | ui-map-orphans |
| 檢核範圍四條件 `:466-467`, `:484-485`, `:503-504`, `:555-556` | `prefixLen`, `prefixRange` | 四個 condition 皆無前幾碼欄位 | ui-map-orphans |

### 只存在於 REA_UI 的名字：子群組 id

kernel 沒有子群組的概念，`subGroups` 的 key 全部沿用 prototype 的 sub-blockId，與任何 kernel 欄位無關：
304 與 305 一對一同名；303 去掉 prototype 的 `Block` 後綴（`countLimit`、`weekLimit`、
`dayMonthYearLimit`、`intervalLimit`、`samePartLimit`）；306 在 prototype 的 `code` / `prefix` /
`range` 前加 `diagnosis`。305 的 `bodyPartGroup` / `orderGroup` 同時是群組 id 與該群組唯一欄位的
id — 兩者位於不同命名空間，不衝突。

### prototype 的第三套名字（與 kernel、ui 都不同）

看到 prototype 的 inputId 不能當成 kernel 或 ui 的欄位名。306 最清楚（六個欄位全數不同名）：

| kernel `Value` | REA_UI | REA_PROTO `inputId` |
|---|---|---|
| `DiagnosisCategory` | `diagnosisCategory` | `category` |
| `DiagnosisPrefixLen` | `diagnosisPrefixLen` | `prefixRange` |
| `DiagnosisRangeStart` / `DiagnosisRangeEnd` | `diagnosisRangeStart` / `…End` | `inputStart` / `inputEnd` |
| `DiagnosisCodes` | `diagnosisCodes` | `inputCodes` |
| `DiagnosisPrefix` | `diagnosisPrefix` | `inputPrefix` |

305 同形，prototype 側加 `bodyPart` / `order` 前綴並把 `PrefixLen` 寫成 `prefixRange`、`Codes` 寫成
`inputCodes`、`Group` 寫成 `groupOption`。307 的 `DiagnosisCodes` 在 prototype 是 `rangeGroups`，
`DiagnosisScope` 是 `filterFields`，兩段 `Range*` 子欄位是 `inputStart` / `inputEnd` /
`monthStart` / `monthEnd`。
