---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf
sha256: b5dd576e234ae9eae0d0fec3ef824b9170da0934b89514de4e6fb76137c8aaed
bytes: 922139
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.p1.jpg 2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.p7.jpg 2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.p12.jpg
---
<!-- page 1 · picture: 2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.p1.jpg -->
「第三代醫療資訊系統建置案」開發規範
二、整合與部署架構
圖 3、整合與部署架構
三、本機開發環境
第三代健保開發環境安裝，如附件一
。
3
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
四、開發文件規範
開發人員須具備 Vue3 與 ASP.NET Core WebAPI 開發能力。
(一) 開發規範文件
 共通開發規範：本文件，包含整體系統範圍、系統劃分、版
本管理。
 前端開發規範：前端 Vue3 開發規範。
 後端開發規範：後端 ASP.NET Core RESTful API 開發規範。
 資料庫規範：資料庫規範。
(二) 開發資訊網站
 開發規範文件。
 程式範例專案。
 程式範例專案。
 Schema 資料。
(三) 系統一覽與代碼
表 1、系統一覽與代碼
序
號
類別 系統代
碼
系統名稱
1 醫療 CMS 醫療申訴系統
2 醫療 HMA 醫務管理子系統
3 醫療 HMA 印鑑管理系統
4 醫療 HMF 支付標準管理子系統
5 醫療 IAM 醫療權限管理子系統
6 醫療 RCM 醫療給付共通作業子系統
7 醫療 IEA 外界資料交換子系統
8 醫療 IEC 院所申報醫師別子系統
9 醫療 IEQ 醫院服務品質指標查詢子系統
4
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
10 醫療 IES、
IER
保險對象特定醫療資訊查詢子系統
11 醫療 IHA 醫療稽核作業子系統
12 醫療 IHC 健保卡醫費勾稽子系統
13 醫療 IHF 高診次子系統
14 醫療 IHH 醫療費用統計子系統
15 醫療 IHU 承保勾稽子系統
16 醫療 IME 代辦項目拆帳金額運算子系統
17 醫療 IMA 健保醫療資訊雲端查詢管理報表
18 醫療 IPA 健保卡就醫資料上傳檢核子系統
19 醫療 IPM 應用系統運作管理子系統
20 醫療 IRM 醫療系統各項使用紀錄管理分析系統
21 醫療 PMS 印表機管理系統
22 醫療 RAP 醫療費用申報暫付子系統
23 醫療 RCP 門診費用子系統
24 醫療 RDD 住院病例組合編審子系統
25 醫療 RDP 住院費用子系統
26 醫療 REP 交付機構費用子系統
27 醫療 RFD 醫療財務介面子系統
28 醫療 RPG 追扣補付醫療費用帳務管理子系統
29 醫療 RPO 欠費催繳訴追呆帳及分期攤繳子系統
30 醫療 ICM 共用作業子系統
31 醫療 IPD 健保資訊網服務系統程式建置
32 醫療 IPU 批次作業平台
33 藥品特材管理 RDR 強化 DRGs 案件審查子系統
34 藥品特材管理 REA 醫令自動化審查子系統
35 藥品特材管理 PAC 影像服務管理子系統
36 藥品特材管理 QB1 事前審查作業子系統
5
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
37 藥品特材管理 IPL 38 藥品特材管理 REF 39 藥品特材管理 HMD 40 藥品特材管理 HMS 41 藥品特材管理 IFE 42 藥品特材管理 QBJ 43 藥品特材管理 RGB 44 藥品特材管理 QCC 45 藥品特材管理 ICE 46 醫事機構 IWS 47 醫事機構 IWP 48 醫事機構 ITM 49 醫事機構 IAU
(RAY/
RMD)
50 醫事機構 IMQ
IMU
IMI
51 醫事機構 IPR 52 醫事機構 CII/IPB 53 醫事機構 IAV 54 醫事機構 QPA~Q
PE
55 醫事機構 56 醫事機構 ISH 57 醫事機構 IIX 58 醫事機構 HIC1 59 醫事機構 HIC2 60 醫事機構 HIC3 61 醫事機構 ISC 62 醫事機構 Q 系列 專業審查子系統
專審輔助子系統
藥品管理子系統
特材管理子系統
代位求償子系統
醫療費用自墊核退子系統
總額預算監控子系統
專案計畫結算作業子系統
醫療院所即時查詢病患就醫資料結算作業
健保醫療資訊網首頁
對外服務管理平台
應用系統監控作業
檢驗(查)結果每日上傳作業
(每月上傳/出院病摘申報)
健保醫療資訊雲端查詢系統
醫事人員溝通平台
醫療資料傳輸共通介面 API
醫療影像每日上傳作業
居家輕量化 APP 系統
資料彙算同步作業
民眾自費檢驗(查)結果上傳
檢驗(查)資料交換系統
健保卡內部管理平台
健保卡 VPN 對外服務系統
健保卡 Internet 認卡服務系統
整合式資料中心客服系統
各類試辦計畫與專案管理
6
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
63 醫事機構 QFM 家醫大平台
64 醫事機構 IRC、
IRI
電子處方箋
65 醫事機構 IMG 雲端影像調閱系統
66 醫事機構 Internet Internet 醫療對外服務項目
67 醫事機構 VPN VPN 醫療對外服務項目
68 醫事機構 HISVP
N
對外服務 HIS 測試系統
69 醫事機構 IVC 虛擬健保卡綁定查詢作業
70 醫事機構 YFI 醫療資訊傳輸服務(WEB API)
71 民眾服務 INFO 健保一般業務查詢及管理
72 民眾服務 OPD 資料開放平台
73 民眾服務 ISM 民眾意見信箱(含廉政信箱)
74 民眾服務 IWB 全球資訊網附加服務系統
75 民眾服務 IHK 健康存摺
76 民眾服務 APP 全民健保行動快易通︱健康存摺 App
7
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
(四) 定義與常用縮寫
表 2、常用縮寫表
名詞 縮寫 Patient pat register reg outpatient department opd laboratory lab prescription Rx National Health Insurance NHI Electronic medical record emr Order odr vital sign vs diagnosis diag medical record mr schedule sch Stock stk payment pay Parameter param Permission prm Authorization auth Authentication auth 中文
病患
掛號
門診部
檢驗、檢驗檢查、實驗室
處方、處方箋
全民健保
電子病歷
醫令/醫囑
生理資料/量測資料
診斷
病歷
排程
庫存
支付
參數
權限
權限
權限
8
<!-- page 7 · picture: 2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.p7.jpg -->
「第三代醫療資訊系統建置案」開發規範
Constant const 常數
9
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
貳、開發管理
採用 Scrum 流程。
一、團隊結構與分工
 標團隊(分工)方式，分成三大類：
 醫療、服務、加值
二、Scrum 流程要點
 一個子系統或一個團隊使用一個 Project。
 2 週一個 Sprint，一天以 6 小時計算。
 每一個 task 不應該超過 6 小時。
 站立會議：執行每日站立會議，簡單報告昨日進度、今天預
定工作，是否需要協助，不討論實際程式問題。
 Sprint 最後一日進行”衝刺回顧/檢討”，並規劃下一個 Sprint
內容。
 每個 task 都必須有”負責人員”
、
工作時間”
。
”負責人員”需填寫”(剩餘)
 程式的 Task 必須連結 GitHub 版本，以進行追蹤。
三、版本管理(Git)
(一) 工具
1、Git v2.35.1 以上。
2、TortoiseGit (選用)。
3、地端版 GitHub 儲存庫
(二) 版本管理方式
1、採用 GitHub 流程。
2、設定七大項目專案名稱，分別設定其權限，但命名依三代規
10
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
範：
(1) 健保資訊網服務系統 VPN。
(2) 健保資訊網服務系統 Interne。
(3) 署內醫療資訊系統 Intranet。
(4) 健保醫療資訊雲端查詢系統 IMU。
(5) 醫事人員溝通平台 IPR
(6) 健康存摺 IHK。
(7) 健保署開放資料查詢 INA。
3、三代 GitHub 架構使用地端版建置在署內，會依開發進度變
更
(1) INA 健保署開放資料查詢 INA
 |-INAE0000-Backend
 |-INAE0000-Frontend
 |-INAE0000-BFF
(2) NHI3-ipr 醫事人員溝通平台 IPR
 |-NHI3-ipr- LocalLibrary-ipr
 |-NHI3-ipr- Backend-ipr
 |-NHI3-ipr- Frontend
(3) NHI3
 |- NHI3-Library
(4) NHI3-ihk 健康存摺 IHK
 |-NHI3-ihk-LocalLibrary-ihk
 |-NHI3-ihk-Backend-ihk
 |-NHI3-ihk-Frontend
(5) NHI3-imu 健保醫療資訊雲端查詢系統 IMU
 |-NHI3-imu-LocalLibrary-imu
 |-NHI3-imu-Backend-imu
 |-NHI3-imu-Frontend
(6) NHI3-intra 內醫療資訊系統 Intranet
11
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
 |-NHI3-intra-LocalLibrary-hma
 |-NHI3-intra-LocalLibrary-iam
 |-NHI3- intra -Backend-hma
 |-NHI3- intra -Backend-iam
 |-NHI3- intra -Frontend
(7) NHI3-in 健保資訊網服務系統 Internet
 |-NHI3-in-LocalLibrary-iwp
 |-NHI3-in-Backend-iwp
 |-NHI3-in-Frontend
(8) NHI3-vn 健保資訊網服務系統 VPN
 |-NHI3-vn-LocalLibrary-iws
 |-NHI3-vn-LocalLibrary-xxx
 |-NHI3- vn -Backend-iws
 |-NHI3- vn -Backend-xxx
 |-NHI3- vn -Frontend
4、各大項目再依功能、任務分為各小組，各小組選一人設定為
Maintain 權限，其餘設為 Write (Developers 權限)。
5、分支策略。
(1) 主要分支：
 main 分支：僅保存穩定且可部署的代碼，嚴格要求不可直
接提交代碼。
 Develop(開發區) 分支：用於整合開發中的功能分支代碼。
 SIT(測試區)分支：用於開發後進行整合測試、自動化測試
及壓力測試，有其對應 CI/CD 自動上版。
 UAT(使用者功能測試區)分支：用於署內使用者進行功能測
試，其環境與 Prod 幾乎是相同，有其對應 CI/CD 自動上
版。
 Prod(正式區)分支：用於正式環境，對應正式 CI/CD 自動上
版。
(2) 功能分支：
 每位開發小組成員從 develop 分支拉出功能分支(feature
12
<!-- page 11 -->
「第三代醫療資訊系統建置案」開發規範
branch)。
 分支命名規則：
 功能：feature/功能名稱(依功能命名方式)。
6、合併策略
(1) 各小組成員每日最少一次拉取 Develop 分支，使功
能分支與 Develop 分支同步。
(2) 各小組成員開發到一段落養成習慣 Push 回自己的
功能分支。
(3) 各小組成員要合併回 Develop 分支，必須提出合併
(Merge)請求，合併原因必須填寫清楚，可使用
GitHub Copilot 產生填寫內容，必須包含：
 標題：簡明描述功能或修復內容。
 描述：功能名稱、功能編號、詳細說明變更的內容和影響
(合併原因說明清楚，例如修改了什麼問題及如何解決，解
決後會影響什麼等)。
(4) 合併原因避免太過冗長，也不可太簡短？同時避免
太久未更新導致合併原因難以填寫(至少一天 1
次)。
(5) 各小組成員申請合併(Merge)請求後，會由
Maintain 人員進行 Code Review 並進行審核。在
Code Review 後 Maintain 人員需填寫意見回覆，如
果問題太多請在程式內以 todo 方式註解。
(6) Maintain 人員一天至少一次將 Develop 分支合併回
master 或 main 分支，必須 Develop 分支與
master 差異太大，同時要注意可能會改動到其他
專案，如差異過太可以退版本，或與其他影響專
案進行討論。
13
<!-- page 12 · picture: 2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.p12.jpg -->
「第三代醫療資訊系統建置案」開發規範
7、開發循環
(1) 在 Develop 中有具體完成獨立功能更新至 DevTest
分支，進行必要測試。
(2) 不管在那一分支(Develop 除外)，只要有錯誤必退
回各分組 Develop 功能分支區，不可直接更改
DevTest、UAT、Prod。
(3) 同一錯誤必須完成各階測試，才能逐步往各區調
整。
8、流程圖
圖 4、流程圖
9、Branch 分支命名可用職編容易識別的主題介名，請勿太過簡
單。
10、Branch Tag 規則
錄，tag 內容為版本號。
正式發布的程式碼，必須於 production 分支進行 tag 記
14
