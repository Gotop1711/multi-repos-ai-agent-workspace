# rea / scope-conditions

「檢核範圍」裡每個條件的選單結構：第一層項目、其下的中間輔助層、最末層，以及每一層的資料從哪裡來。
依據 `REA_kernel@1706cb5` 的 `src/Service/NHI.Service.DTO.ClaimValidator/Specification/V1/Codes/V1.0/_101.cs`
（下稱 `_101.cs`，`:<行>` 皆指此檔）與 `REA_UI@3ad7356` 的 `src/utils/rule/ruleUIConfig.ts`。十三個條件在
二十個 code 檔內逐欄位相同（`diff` 只差 101 的一條 `VisibleWhen`；field-map › 檢核範圍 Conditions），所以本文適用
所有規則。`667734c`（2026-10-13）補齊了欄位並給了十二個條件 translator，見第 7 節。

## 1. 三層模型

```
第一層      「欄位」下拉：選一個條件（案件分類、層級別 …共十三個）
  └ 中間輔助層  選了條件後出現的輔助選單：比對條件、類別、輸入方式、比對欄位
      └ 最末層    真正指定「比對什麼值」的控制項：多選選單、下拉、或輸入框
```

| 層 | 是什麼 | 資料來源 |
|---|---|---|
| 第一層 | `RuleCode.Conditions` 的十三個 `ConditionDescriptor` | **全部寫死**（rea-kernel › Where the 檢核範圍 menu comes from） |
| 中間輔助層 | 條件底下帶 `Options = [...]` 的輔助欄位 | **全部寫死** |
| 最末層 | 條件底下最後填值的欄位 | **三種**：資料表、寫死、使用者輸入 |

結論一句話：**只有最末層可能來自資料庫，而且只有六個條件如此；第一層與中間輔助層沒有任何一項來自資料庫。**

## 2. 中間輔助層的兩種角色

| 角色 | 欄位 | 作用 | 會不會改變最末層 |
|---|---|---|---|
| **修飾** | `Operator` 比對條件（包含／不包含）；`FilterOptions` 比對欄位 | 說明最末層的值「怎麼比、比哪個申報欄位」 | 不會 |
| **切換** | `Category`（類別／類型／輸入方式） | 決定最末層出現哪一個控制項，或向資料表查哪一個資料類別 | 會 |

切換的兩種機制：

- **代入路徑。** 案件分類與醫事類別的最末層路徑是 `/api/v1/Options/PxxtCode/PBA/{Category}`（`:75`, `:145`）；
  ui 以使用者選的 `Category` 值代入 `{Category}` 後才發請求（`REA_UI@5721638`
  `src/utils/rule/ruleSchemaUtils.js:9`, `src/views/rules/ScopeSetting.vue:751`, `:764`），未代入完成的路徑不送出
  （`src/stores/ruleEditor.js:170-173`）。
- **顯示條件。** 代碼型條件的每個最末層欄位帶 `VisibleWhen { Field = "Category", Value = "01|02|03|04" }`
  （`:273-331`, `:362-424`, `:456-526`, `:667-725`）；ui 以 `linkedOptions` 把 `Category` 的每個值對到一個
  `subGroups` 區塊，只顯示被選中的那一個（`ruleUIConfig.ts:449-469`, `:470-487`, `:488-507`, `:538-558`；機制見
  rule-editor › Schema → form）。

## 3. 總覽：十三個第一層項目

| # | 第一層項目（`Value`） | 中間輔助層（皆寫死） | 最末層 | 最末層來源 | 型 |
|---|---|---|---|---|---|
| 1 | 案件分類 `CaseType` | 比對條件 → 案件分類類別 | 案件分類選項（多選） | 資料表 `PBA/{Category}` | B |
| 2 | 層級別 `Level` | 比對條件 | 層級別選項（多選） | 資料表 `QRD/003` | A |
| 3 | 醫事類別 `HospCode` | 比對條件 → 醫事類別類型 | 醫事類別選項（多選） | 資料表 `PBA/{Category}` | B |
| 4 | 醫令類別 `OrderType` | 比對條件 | 醫令類別選項（多選） | 資料表 `PBA/132` | A |
| 5 | 處方調劑方式 `RelMode` | 比對條件 | 處方調劑方式選項（多選） | 資料表 `PBA/131` | A |
| 6 | 主次診斷代碼 `SubMainDiagnosisCode` | 比對條件、比對欄位（22 個 ICD 欄位）→ 輸入方式 | 代碼／開頭值＋前幾碼／起訖值 | 使用者輸入 | C |
| 7 | 部分負擔代碼 `PartCode` | 比對條件 → 輸入方式 | 代碼／開頭值／起訖值 | 使用者輸入 | C |
| 8 | 診療之部位 `TreatmentArea` | 比對條件 → 輸入方式 | 代碼／開頭值／起訖值，或「群組」下拉 | 使用者輸入；群組為寫死 | C＋D |
| 9 | 年齡 `Age` | 無 | 基準日、上下限運算子、上下限、單位 | 寫死；上下限為使用者輸入 | D |
| 10 | 清單下併報項目 `AssociatedItems` | 比對條件 | 項目代碼 | 使用者輸入 | C |
| 11 | 核定治療項目 `TreatmentItems` | 比對條件、比對欄位 → 輸入方式 | 代碼／開頭值／起訖值 | 使用者輸入 | C |
| 12 | 就醫科別 `Department` | 比對條件 | 就醫科別選項（多選） | 資料表 `PXX/997` | A |
| 13 | 僅機械手臂輔助手術 `Robotic` | 無 | 是否限定（是／否） | 寫死 | D；二十個 code 皆 `Disabled`（`:756`） |

「→」表示前者選定後才決定後者；「、」表示並列。

## 4. 四種型

### A 型 — 資料表直取（層級別、醫令類別、處方調劑方式、就醫科別）

```
比對條件（寫死：包含／不包含） ＋ 最末層多選（資料表，固定的子系統／資料類別）
```

| 項目 | 最末層欄位 | 路徑 | 行 |
|---|---|---|---|
| 層級別 | `LevelOptions` | `QRD/003` | `:104` |
| 醫令類別 | `OrderTypeOptions` | `PBA/132` | `:173` |
| 處方調劑方式 | `RelModeOptions` | `PBA/131` | `:201` |
| 就醫科別 | `DepartmentOptions` | `PXX/997` | `:746` |

沒有切換型輔助層：選了條件就直接查固定的一組代碼。

### B 型 — 資料表，經寫死的類別切換（案件分類、醫事類別）

```
比對條件（寫死） ＋ 類別（寫死） ──代入 {Category}──▶ 最末層多選（資料表 PBA/<類別值>）
```

| 項目 | 類別（寫死的值） | 最末層欄位 | 實際查詢 |
|---|---|---|---|
| 案件分類 | 101 門診西醫、104 住診（`:60`） | `CaseTypeOptions`（`:75`） | `PBA/101`、`PBA/104` |
| 醫事類別 | 011 門診、012 住診、013 其他（`:129`） | `HospCodeOptions`（`:145`） | `PBA/011`、`PBA/012`、`PBA/013` |

- **能查哪幾個資料類別是寫死的**，只有每個類別底下的代碼列來自資料表。要多一個類別（例如門診中醫）是改程式，不是
  加資料。
- 只有 101 的 `CaseTypeOptions` 多帶一條 `VisibleWhen`（`:79`），其餘十九個 code 沒有；`HospCodeOptions` 在任何
  code 都沒有。ui 不依賴它，兩者都由 `linkedOptions` 切換（`ruleUIConfig.ts:407-420`, `:425-440`）。

### C 型 — 使用者輸入，經寫死的輸入方式切換（主次診斷代碼、部分負擔代碼、診療之部位、核定治療項目、清單下併報項目）

```
比對條件（寫死） [＋ 比對欄位（寫死）] ＋ 輸入方式（寫死） ──VisibleWhen──▶ 最末層輸入框
```

| 輸入方式（寫死） | 出現的最末層 | 型別 |
|---|---|---|
| 01 代碼 | `Codes` | 可加多筆的文字 |
| 02 開頭 | `InputPrefix`、`PrefixLen` 前幾碼（`Number`，`Min` 1，`667734c` 起；`:287`, `:377`, `:471`, `:681`） | 文字＋數字 |
| 03 開頭範圍 | `RangeStart`、`RangeEnd` | 文字 |
| 04 群組（僅診療之部位） | `GroupOption` | 下拉，見 D 型；選項 `04` 本身 `Disabled`（`:449`），translator 拒絕（第 7 節） |

| 項目 | 比對欄位（寫死） | 輸入方式 | 行 |
|---|---|---|---|
| 主次診斷代碼 | 主診斷、次診斷（一）（二）、門診（三）（四）、住院（三）～（十九）：22 個（`:226-258`，`667734c` 前只有兩個） | 01–03 | `:209-331` |
| 部分負擔代碼 | 無 | 01–03 | `:332-424` |
| 診療之部位 | 無 | 01–04 | `:425-526` |
| 核定治療項目 | 特定治療項目代號（一）～（四）（`:640-652`） | 01–03 | `:623-725` |
| 清單下併報項目 | 無 | 無輸入方式，直接 `Codes`（`:612`） | `:595-622` |

- **輸入的代碼沒有任何對照表。** kernel 的選項服務 `IOptionSL` 只有 Options controller 一個使用者，沒有 validator
  拿 `PXXT_CODE` 或其他表檢查存入的值（`REA_kernel@458e663` 全 `src` 搜尋）。
- ui 的 02 區塊早就命名了 `prefixLen`（`ruleUIConfig.ts:458`, `:476`, `:495`, `:547`）；`667734c` 起 kernel 服務
  `PrefixLen`，所以它現在渲染為數字框。03 區塊的 `prefixRange` 仍無對應欄位，不渲染（plan ui-map-orphans）。

### D 型 — 最末層本身寫死（年齡、僅機械手臂輔助手術、診療之部位的群組）

| 項目 | 最末層欄位 | 寫死的值 | 行 |
|---|---|---|---|
| 年齡 | `ReferenceDates` 基準日（可排序） | 01 就醫日期、02 醫令執行起日、03 治療結束日、04 住院日期、05 出院日期；06 調劑日期、07 物理治療起日、08 檢驗日期 自 `4b889a8` 起 `Disabled`（`:540-542`，資料庫無此三欄） | `:531-543` |
| 年齡 | `OperatorMin`／`OperatorMax`、`Unit`、`Min`／`Max` | 大於、大於等於／小於、小於等於；歲、月、日；數字輸入 | `:527-594` |
| 僅機械手臂輔助手術 | `RoboticOption` | 是、否 | `:759` |
| 診療之部位 | `GroupOption`（輸入方式 04 時） | 群組一、群組二、群組三（`TreatmentG01`–`G03`） | `:514` |

年齡與僅機械手臂輔助手術沒有中間輔助層：所有欄位平列在同一列（`ruleUIConfig.ts:500-525`, `:555-558`），整個條件與
資料庫無關。選項層的 `Disabled` 在 ui 只有 `sortOptions`（基準日）與參考欄位會變灰（`SortOptionsInput.vue:30`）；
檢核範圍的下拉與多選 `el-option` 不綁 `disabled`（`ScopeSetting.vue:300-305`, `:331-339`），所以 類別 `04` 群組
仍可選（plan ui-scope-option-flags）。

## 5. 「資料表」指什麼

六個最末層欄位的 `OptionsApi` 都是 `GET /api/v1/Options/PxxtCode/{SubSys}/{DataType}`，讀 Oracle 的 `PXXT_CODE`：
以 `SUB_SYS`、`DATA_TYPE` 篩選，只取 `VALID_E_DATE = 2910-12-31` 且 `TXT_STATUS = '1'` 的列，快取一天，標籤為
`(<代碼>) <中文名稱>`。完整呼叫鏈與行號：rea-kernel › Where the 檢核範圍 menu comes from。

## 6. 改動各層要動哪裡

| 想改的東西 | 要動的地方 |
|---|---|
| A、B 型最末層的某個代碼或名稱 | 資料表 `PXXT_CODE` 的資料，不必改程式（快取最長一天後生效） |
| B 型可選的類別、任何中間輔助層的選項、D 型的選項 | kernel 二十個 `_<code>.cs` 各改一次 |
| 第一層的項目、名稱或順序 | 同上，二十個檔 |
| C 型輸入值的合法性檢查 | 目前不存在，需新增 |

## 7. 哪些條件已有 translator（`1706cb5`）

`Translator/V1.1/RuleSetTranslator.Condition.cs:68-119`：十三個條件中十二個可翻譯，只有 `Robotic` 擲出
`NotSupportedException`，所以二十個 code 都只把它標為 `Disabled`（`667734c` 前是 201 的九個）。A、B 型以
`{Field}Options` 成員比對（`HospCode` 比的是申報的 `HospDataType`、`Level` 是 `HospGType`）；C 型依類別：代碼
清單、開頭（`InputPrefix` 取前 `PrefixLen` 碼）、起訖；核定治療項目對 `CureItem1`–`4` 任一、主次診斷對勾選的
ICD 欄位任一；清單下併報項目對 ETL 依七欄 key 回填的同清單醫令（`ReferenceDetailOrderCodes`，
`ClaimDataSL.cs:342-372`）。年齡只接受基準日 `01`–`05`（`:363-373`）；診療之部位 類別 `04` 群組擲出（`:458`）。
存檔時 `NotSupportedException` 不是錯誤：列存入而 `TranslatedRules` 為 null，ETL 對它擲「缺少 TranslatedRules」
（rea-kernel › Save translates；ruleset-api › Save）——所以 ui 放行一個被標 `Disabled` 的選項，後果是一條
存得進、跑不了的規則。

## 未查證

- 已部署環境實際讀 Oracle 還是假資料（`MockOptionSL`）：沒有對它發出請求；
  `src/API/NHI.API.ClaimValidator/appsettings.json:9-11` 的 `MockData:Enabled` 預設 `false`。
- `PXXT_CODE` 各資料類別目前有哪些列：未連資料庫。
