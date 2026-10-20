---
source: docs/assets/rea/rea-ui/2026-10-20-validation-result-design.html
sha256: a4b95872ad4712e0b87df4f480cd39b0841a8381d35182f95bf00afdf4baa4cc
bytes: 71742
extractor: textutil
status: ok
received: 2026-10-20-validation-result-design.html
---
REA
規則引擎系統
支付標準 特殊材料 藥品 加成 檢核結果

檢核結果

示意資料，非實際檢核結果
先確認批次檢核進度，再查看醫令判定、核減原因與申報欄位比對。
匯出核減案件 JSON
*
院所代號
HOSP_ID
0401180014
*
申報年月／費用年月
FEE_YM
2025-12
*
醫事類別
HOSP_DATA_TYPE
                        
                             11 · 門診西醫診所
                             12 · 門診西醫醫院
                             13 · 門診牙醫
                             14 · 門診中醫
                             15 · 門診洗腎
                             19 · 門診其他醫事機構
                        
                        
                             21 · 住診西醫診所
                             22 · 住診西醫醫院
                             23 · 住診其他醫事機構
                        
                        
                             30 · 特約藥局
                             40 · 物理治療所
                             50 · 特約檢驗所
                        
                    
*
申報類別
APPL_TYPE
                         1 · 送核
                         2 · 補報
                         4 · 申復送核
                         5 · 申復補報
                         7 · 再議送核
                         8 · 再議補報
                         9 · 爭審送核
                         A · 爭審補報
                    
醫令代號
ORDER_CODE
選填
                         全部醫令
                         51018C
                         09001C
                    
檢核結果
失敗
全部
正確
查詢

清除條件

標示 * 為必要條件。
查詢條件按「查詢」後套用
已套用範圍
申報年月 FEE_YM　2025/12
HOSP_ID　0401180014
HOSP_DATA_TYPE　11 · 門診西醫診所
APPL_TYPE　1 · 送核
ORDER_CODE　51018C
結果　失敗
統計依相同必要條件的全部醫令計算
批次執行進度與檢核結果
依已套用必要條件計算 · 示意資料

批次進度
僅呈現分區查詢需要的進度

1
檢核中

1
已完成
未顯示後台重試／放棄狀態

醫令檢核結果
4 筆已產出
2
通過 Pass
1
不通過 Fail
核減率分母：Pass + Fail = 3
通過率 66.7% | 核減率 33.3%
例外狀況另列、不計入核減率： NoRule 1 · 醫令 Skipped 0 ；群組層 Skipped 仍可在單筆明細查看。

統計暫列
目前仍有 1 批檢核中；統計只計已產出結果，完成前數值可能變動。
不通過醫令
依已套用條件 · 一列代表一筆申報醫令
共 1 筆
序號由小到大
檢核結果
ORDER_CODE
不通過模組／RuleCode
核減代碼／中文名稱
SEQ_NO
ORDER_SEQ_NO
HOSP_ID
HOSP_DATA_TYPE
FEE_YM
APPL_TYPE
APPL_DATE
CASE_TYPE
明細


左右捲動可檢視完整識別欄位；核減原因的欄位集合依失敗模組動態呈現。
顯示 1–1 筆，共 1 筆不通過醫令　·　每頁
                             2
                             10
                         筆
設計依目前 ValidationResult.vue 呈現；核減碼／中文名稱及原始申報欄位比對為需求規劃示意，需後端結果契約提供。


醫令判定明細 示意資料 複製 ClaimResult 下載單筆

ORDER_CODE　51018C
案件序號 4　·　醫令序號 1　·　申報年月 2025/12

醫令檢核不通過
申報識別
核減原因
失敗模組＋二代核減代碼

申報欄位比對
依模組動態列出欄位
比對欄位
院所申報值
規則要求

此為示意欄位與示意值；不同模組會提供不同欄位，正式內容需由後端檢核結果提供。
規則判定路徑
不通過模組優先
判定依據
原始 ClaimResult JSON
結果資料 · 未裁切
目前 ClaimResult 原文；不包含原始申報資料或核減原因 mapping。

核減碼、中文名稱、欄位比對為需求示意；目前 kernel 尚未把 ErrorCode／欄位錯誤證據存入 ClaimResult。核減碼例：201 → CD9（依規格文件，待實作 mapping）。

