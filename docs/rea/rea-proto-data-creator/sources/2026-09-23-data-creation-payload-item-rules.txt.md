---
source: docs/assets/rea/rea-proto-data-creator/2026-09-23-data-creation-payload-item-rules.txt
sha256: a93c87091bb8821ca3ea3477cb496b6d3dd14728226ef571ffa2a772254a818f
bytes: 3741
extractor: verbatim
status: ok
received: 後端驗測資料生產__RuleSave_payload_item_產出規則.txt
---
# 名詞請參考：後端驗測資料生產__定義.txt
# 對應：後端驗測資料生產__資料採集規則.txt

共通 RuleSave_payload_item 填值規則：
- `specificConfig.referenceDate` 要給 `["executionDate"]`的值。

101: 101 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
102: 102 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
103: 103 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
104: 104 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
106: 106 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中

201: 201 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
202: 202 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中。ENAME 的值 ("1" 或 "2"；多筆資料的 ENAME 值應該都相同) 填入 [RuleSave_payload_item] 的 `specificConfig.doctorTypes` 之中，字串值前面補字串 "0"，成爲 "01" 或 "02"。
203: 203 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 PRSN_TYPE 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中。PRSN_TYPE 是用 "," 分隔的字串資料。
204: 204 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
205: 205 的 [rule模組欄位資料檔] 內的資料應該都是 TREAT_CODE 不重複的資料。每筆資料用來產出對應的 [RuleSave_payload_item] 的 `specificConfig` 中的以下欄位：
    - 若 FULL_TIME_DOC 欄位有值 (應是 "1")，則在 `mainSetting` 中放入 "2"；沒有值，放 "1"。
    - 在 `doctorTypes` 中放入 "02"。
    - `employmentType` 填 "01"。
206: 206 的 [rule模組欄位資料檔] 內的資料應該都是 TREAT_CODE 不重複的資料。每筆資料用來產出對應的 [RuleSave_payload_item] 的 `specificConfig` 中的以下欄位：
    - 若 FULL_TIME_EXEC 欄位有值 (應是 "1")，則在 `mainSetting` 中放入 "2"；沒有值，放 "1"。
    - 在 `doctorTypes` 中放入 "01"。
    - `employmentType` 填 "01"。

301: 301 的 [rule模組欄位資料檔] 每筆資料的 LMT_SEX 值要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中。LMT_SEX 值是 "1" 或 "2"。
302: 302 的 [rule模組欄位資料檔] 每筆資料依以下情況填入 [RuleSave_payload_item] 的 `specificConfig` 中的以下欄位：
    - 若是 (LMT_AGE_S_DAY && LMT_AGE_E_DAY) 有值，則 `unit` 填入 "D"，`min` 填入 LMT_AGE_S_DAY 的值，`max` 填入 LMT_AGE_E_DAY 的值。
    - 若是 (LMT_AGE_S_MONTH && LMT_AGE_E_MONTH) 有值，則 `unit` 填入 "M"，`min` 填入 LMT_AGE_S_MONTH 的值，`max` 填入 LMT_AGE_E_MONTH 的值。
    - 若是 (LMT_AGE_S_YEAR && LMT_AGE_E_YEAR) 有值，則 `unit` 填入 "Y"，`min` 填入 LMT_AGE_S_YEAR 的值，`max` 填入 LMT_AGE_E_YEAR 的值。
303:
304:
305:
306:
307:

401:
