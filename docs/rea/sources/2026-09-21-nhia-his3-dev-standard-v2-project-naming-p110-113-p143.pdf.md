---
source: docs/assets/rea/2026-09-21-nhia-his3-dev-standard-v2-project-naming-p110-113-p143.pdf
sha256: 0d8ec76803a89bda60412fd319468f0627fa58abf3facf424458f01a1a23feca
bytes: 719873
extractor: pdfkit
status: ok
received: 2026-09-21-nhia-his3-dev-standard-v2-project-naming-p110-113-p143.pdf
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
 Enterprise Scheduler
 MQ Trigger
進行管理。
四、專案架構規範
(一) WebAPI 專案
1、WebAPI 專案定位
WebAPI 專案為：
 系統對外 API 入口
 前端與後端溝通層
 外部系統整合入口
主要負責：
 Request 接收
 Authentication
 Authorization
 Validation
 API Response
 Swagger
 Middleware Pipeline
不得：
 撰寫業務邏輯
 撰寫 SQL
 操作 Transaction
 操作資料庫
2、WebAPI 專案命名規範
使開發與設計人員在規劃自己的系統，針對系統專案、程
式與檔案命名有關的問題，都能在此命名原則中找到答案。
(1) 如果以 IMS 為例專案名是 NhiCore.IMSNC001，
Controllers 命名 IMSNC0001N01Controllers.cs。
102
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
(2) 如果被要求要微服務，以 IMS 為例專案名是
NhiCore.IMSNC002，三代專案是需要編輯後才可
以執行，所以同一專案如果功能很多，可能會造
成一個小功能，整個 Pod 都要更新，因此如果可
能經常被異動的程式，可能要思考專案是不是要
切分為不同專案。
(3) 前端專案命名規則
 例如以 IMS 為例：Med3Vue.IMSNC。
 Vue 頁面命名為 IMSNC1001S01.vue 案件登錄作業。
(4) 後端專案命名規則
 例如以 IMS 為例：Med3Vue.IMSNC。
 Controllers 命名為例 IMSNC1001S01 案件登錄作業。
3、子系統程式(程式代碼)命名規則共 12 碼
(1) 第一至三碼系統碼。
(2) 第四碼作業區(與 DB 同): N: NHI，W: WWW、
INTERNET，V: VPN(IDC)， C: COMMON。
(3) 第五碼:區別程式語言。C: C Sharp(C#):，J: JAVA、
納入其他開發語言如 T: JavaScript 等。 NiFi 非程
式語言僅訂開發與命名規。
(4) 第六至九碼:作業序號。
(5) 第十碼:程式類別。
(6) 第十一、十二碼:程式序號。
4、作業程式碼第十碼說明
(1) S: SCREEN 前端。
(2) N: 後端 (具主(master)、從(slave)，API 或後端)。
103
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
(3) B:批次程式(例如 原 Pro*C 轉 C#)。
(4) R:產製報表。
(5) U:排程作業(SCHEDULE)，Script ext:shell、
YAML。
例如：
5、Common 共用命名(功能集合最多 5 碼)
(1) 子系統程式(共用功能)命名規則
 子系統代號..Common。
 例如：Med3Core.IMSNC.Log.Common。
(2) 全域共用程式命名規則
 Med3Core.功能集合.Common。
 例如：Med3Core.Log.Common。
(3) 特定區域共用命名規則
 Intra
 Med3Core .NC.功能集合.Common。
 例如：Med3Core.NC.Log.Common。
 VPN
 Med3Core.VC.功能集合.Common。
 例如：Med3Core.VC.Log.Common。
 WWW
 Med3Core WC.功能集合.Common。
 例如：Med3Core.WC.Log.Commn。
(4) .
 子系統完整命名.功能集合.Common。
 例如：Med3Core.IHANCB.Log.Common。
104
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
(5) 批次特定區域共用命名規則
 Intra
 Med3Core.NCB.功能集合.Common。
 例如：Med3Core.NCB.Log.Common。
 VPN
 Med3Core.VCB.功能集合.Common。
 例如：Med3Core.VCB.Log.Common。
 WWW
 Med3Core.WCB.功能集合.Common。
 例如：Med3Core.WCB.Log.Common。
6、批次全域共用程式命名規則
 Med3Core.CB.功能集合.Common。例如：
Med3Core.CB.Log.Common。
 在 Common Function 名稱開頭要加上功能集合
_
Log_，功能集合大小寫與 Common 命名一致。
，例如
7、API 服務共用命名(功能集合最多 5 碼)。
(1) 子系統程式(共用功能)命名規則。
 子系統代號.Service。
 例如：Med3Core.IMSNC.Log.Service。
(2) 全域共用程式命名規則。
 Med3Cor.功能集合.Service。
 例如：Med3Core.Log.Service。
(3) 特定區域共用 Med3Core 命名規則。
 Intra
 Med3Core.NC.功能集合.Service。
 例如：Med3Core.NC.Log.Service。
105
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
範例：
api/v1/patient
(十一) 專案命名規範請參考標準 Solution 結構
1、Solution 命名規範
範例 Med3Core.IMSNC.sln
2、Project 命名規範
格式：
Med3Core.{SystemCode}.{Layer}
3、禁止中文專案名稱
禁止：
 病歷系統
 禁止空泛名稱
 禁止：
 CoreProject
 MainSystem
(十二) 子系統程式代碼命名規範請參考子系統 5 碼命名原則
1、子系統代碼必須統一
2、程式代碼不得重覆
不得：
 同代碼不同系統
 同系統不同代碼
3、Batch 命名需含系統代碼
範例：
BatchHM/RAPNC02248B01
(十三) Common 專案命名規範
1、Common 必須表達用途
135
