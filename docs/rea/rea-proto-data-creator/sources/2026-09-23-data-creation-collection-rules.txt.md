---
source: docs/assets/rea/rea-proto-data-creator/2026-09-23-data-creation-collection-rules.txt
sha256: 49db1dceb1988e0689274eea0fd0e4ee5354e518ebed968440fed53dddd058c9
bytes: 1002
extractor: verbatim
status: ok
received: 後端驗測資料生產__資料採集規則.txt
---
# 名詞請參考：後端驗測資料生產__定義.txt

共通採集規則：
- LMT_E_DATE=2910-12-31

101: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=001
102: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=002
103: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=003
104: MHCT_PAYLTYPE_Data.csv 中，LMT_TYPE_CODE=13，LMT_GROUP_CODE=004
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
