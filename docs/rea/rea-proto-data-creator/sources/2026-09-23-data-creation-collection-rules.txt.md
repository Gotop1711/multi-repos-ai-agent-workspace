---
source: docs/assets/rea/rea-proto-data-creator/2026-09-23-data-creation-collection-rules.txt
sha256: 6d14b100deb8f7fa5e7cbef62b4e5dc36b26164b284b209453d43573e8d4ccb3
bytes: 994
extractor: verbatim
status: ok
received: 後端驗測資料生產__資料採集規則.txt
---
# 名詞請參考：後端驗測資料生產__定義.txt

共通採集規則：
- LMT_E_DATE=2910-12-31

101: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=1
102: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=2
103: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=3
104: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=4
106: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=1

201: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=3
202: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=7
203: MHCT_PAYLIMIT_Data.csv 中，PRSN_TYPE 有值的項目
204: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=14
205: MHCT_PAYLIMIT_Data.csv 中所有項目
206: MHCT_PAYLIMIT_Data.csv 中所有項目

301: MHCT_PAYLIMIT_Data.csv LMT_SEX 有值的項目
302: MHCT_PAYLIMIT_Data.csv 中有值邏輯符合：`(LMT_AGE_S_DAY && LMT_AGE_E_DAY) || (LMT_AGE_S_MONTH && LMT_AGE_E_MONTH) || (LMT_AGE_S_YEAR && LMT_AGE_E_YEAR)` 的項目
303:
304:
305:
306:
307:

401:
