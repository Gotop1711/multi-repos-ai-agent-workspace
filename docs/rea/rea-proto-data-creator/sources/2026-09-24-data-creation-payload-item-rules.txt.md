---
source: docs/assets/rea/rea-proto-data-creator/2026-09-24-data-creation-payload-item-rules.txt
sha256: 2d37fb1ccbe6248c2a98dbccd29bc0a227892cfb6006835986c062266980ba65
bytes: 5179
extractor: verbatim
status: ok
received: 後端驗測資料生產__RuleSave_payload_item_產出規則.txt
---
# 名詞請參考：後端驗測資料生產__定義.txt
# 對應：後端驗測資料生產__資料採集規則.txt

共通 RuleSave_payload_item 填值規則：
- `form.ruleStartDate` 要給 "2026-01-01" 的值。
- `form.ruleEndDate` 要給 "9999-12-31" 的值。
- `specificConfig.referenceDate` 要給 `["executionDate"]`的值。
- `specificConfig` 下面，除了下面規則指明要填值的欄位和 `specificConfig.referenceDate` 以外的欄位 (完整的 `specificConfig.*` 欄位請參考 POST_RuleSave_request-body_Schema.json)，都還是要產出，但值給 null。


101: 101 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
102: 102 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
103: 103 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
104: 104 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
106: 106 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中

201: 201 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中
202: 202 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 LMT_ITEM 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中。ENAME 的值 ("1" 或 "2"；多筆資料的 ENAME 值應該都相同) 填入 [RuleSave_payload_item] 的 `specificConfig.doctorTypes` 之中，字串值前面補字串 "0"，成爲 "01" 或 "02"。`specificConfig.employmentType` 填 "01"。
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
307: 307 的 [rule模組欄位資料檔] 若有多筆相同 TREAT_CODE 的資料，他們的 CNAME, ENAME, CNAME_1, ENAME_1 的值都要填入 [RuleSave_payload_item] 的 `specificConfig.rangeGroups` 下面的項目中。每個 rangGroup 項目中的欄位對應是：
    - CNAME 值填入 inputStart
    - ENAME 值填入 inputEnd
    - CNAME_1 值填入 monthStart
    - ENAME_1 值填入 monthEnd
    - prefixRange 值填入 CNAME 跟 ENAME 的編碼長度。起迄長度不同的話，取較長者。
除 `specificConfig.rangeGroups` 之外，307 的 [RuleSave_payload_item] 還要填寫 `specificConfig.filterFields`。值都給 `["01","02"]`。

401: 401 的 [rule模組欄位資料檔] 每筆資料的 IOPD_LMT 值要解析後填入 [RuleSave_payload_item] 的 `specificConfig.mainSetting` 之中。IOPD_LMT 的值可能是單一位數數字字串，也可能是複數位數數字字串。若是複數位數數字字串，在填入 mainSetting 之前，要先把字串拆開成多個單一位數數字字串的值。例如："23" -> "2", "3"。
