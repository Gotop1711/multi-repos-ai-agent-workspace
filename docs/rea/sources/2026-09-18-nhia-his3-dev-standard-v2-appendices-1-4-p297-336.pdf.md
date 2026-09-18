---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf
sha256: de6a132a70d3e5e28f2f755f9def740a16a3a5b23631be765ca5285786c3a59d
bytes: 5918937
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p1.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p2.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p3.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p4.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p5.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p6.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p7.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p8.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p9.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p10.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p11.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p12.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p16.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p17.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p18.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p19.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p23.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p24.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p25.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p30.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p31.jpg 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p40.jpg
---
<!-- page 1 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p1.jpg -->
「第三代醫療資訊系統建置案」開發規範
壹拾參、 附件
一、第三代健保開發環境安裝
(一) 在開發過程無論是前後端版本及擴充元件都可能會改版，請參考
使用程式庫白名單。
(二) 安裝 Visual Studio 2022
(三) 安裝 Vue3
1、安裝 Node.js 、npm
289
<!-- page 2 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p2.jpg -->
「第三代醫療資訊系統建置案」開發規範
2、檢查 Node.js 、npm 版本
node -v
npm -v
確認是否已安裝完成
3、Visual Studio Code 安裝
執行 VSCodeUserSetup-x64-1.56.2.exe
4、延伸模組安裝
Vue – Official
290
<!-- page 3 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p3.jpg -->
「第三代醫療資訊系統建置案」開發規範
291
<!-- page 4 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p4.jpg -->
「第三代醫療資訊系統建置案」開發規範
Vue Extension Box
Vue 3 Snippets
292
<!-- page 5 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p5.jpg -->
「第三代醫療資訊系統建置案」開發規範
ESLint
Prettier
5、安裝 Vue3 + Vite
可參考以下網址
https://zh-hk.vuejs.org/guide/quick-start.html
建立專案資料夾
開啟 vs code 終端
293
<!-- page 6 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p6.jpg -->
「第三代醫療資訊系統建置案」開發規範
建置 Vue3 + Vite 專案
npm init vue@latest
294
<!-- page 7 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p7.jpg -->
「第三代醫療資訊系統建置案」開發規範
Vue3 + Vite install 及 Vue3 run
開啟 http://localhost:5173/ 網頁
Ctrl + c 可結束
295
<!-- page 8 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p8.jpg -->
「第三代醫療資訊系統建置案」開發規範
6、安裝 Bootstrap5
npm install bootstrap@5.3.3 5XX 版本
檢查 package.json 已安裝的環境
296
<!-- page 9 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p9.jpg -->
「第三代醫療資訊系統建置案」開發規範
(四) 安裝 MongoDB
1、安裝 windows MongoDB for windows
MongoDBdb-windows-x86_64-8.0.4-signed.exe
2、安裝 MongoDBdb-compass-1.45.0-win32-x64
297
<!-- page 10 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p10.jpg -->
「第三代醫療資訊系統建置案」開發規範
設定連線(MongoDB 已經啟動)
自已可以設定個名稱
298
<!-- page 11 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p11.jpg -->
「第三代醫療資訊系統建置案」開發規範
再按下 Save & Connect
二、三代醫療系統介面設計規範
依據來源：
1、114/6/25 第三代醫療資訊系統建置案
畫面樣板會議
_
三代醫療署內(INTRA)
2、114/7/7 健保三代畫面元件樣式討論
3、114/7/15 三代系統設計書規劃初稿說明討論(第三次)
項次 類別 規範說明
1 共通性 按鈕名稱要納管，先收集後由資拓做第一次收斂，之後
299
<!-- page 12 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p12.jpg -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
原則 再交由署方做第二次收斂後定稿為資料字典。
按鈕名稱提出時要一併提交該按鈕所在的畫面截圖，以
便審查方判斷。
2 畫面設計時，按鈕名稱以資料字典中現有的為命名，若
無法適用則需提出申請由科長審查通過後加入資料字典
後使用。
3 調整顯示文字大小後(瀏覽器調整顯示比例以 150%為
限)，控制畫面欄位標題以不斷行為原則。
4 Header 登入資訊直接在 Header 上顯示，格式為：
日期：[系統日期] | [登入使用者單位] | [登入使用者姓名]
| 執行主機：[設備代號]
例：日期：114/06/12 | 署本部 | 系統管理員 | 執行主
機：H20DEVInT2016
圖例如下：
5 在 Header 上註明目前是哪個環境，例：UAT...，以紅色
標示。
色碼：#FF0000。
圖例如下：
6 功能表 因為某些功能名稱較長，功能表需提供以下任一方式來
300
<!-- page 13 -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
完整顯示功能名稱：
 功能表可由使用者操作自行調整寬度。
 功能表提供水平 scrollbar。
 功能名稱過長時自動折行。
7 目前正在使用的功能，在功能表中需自動改變該功能名
稱之文字顏色或加上底色，以方便辨識。
8 點擊麵包屑上的「子功能」名稱後，在功能表中該做功
能的 Tree 要展開，並且自動拉動功能表的垂直 scrollbar
將該子功能拉到功能表的最頂端顯示，以減少子功能表
在畫面下方時，使用者還要手動拉 scrollbar 的動作。
9 作業功
能
功能畫面區底色為白色。
色碼：#FFFFFF。
10 畫面設計以三欄式為原則。
11 畫面欄位標題以不斷行為原則。
12 欄位標題與欄位間，以 1 個半形空白為區隔。
13 非必填欄位的欄位名稱文字顏色為深灰色。
色碼：#666666。
圖例如下：
14 必填欄位在欄位名稱前加 1 個半形「*」，欄位名稱文字
(含「*」)顏色為紅色。
色碼：#FF0000。
圖例如下：
15 欄位內容文字顏色為黑色，目的在使用者要看的清楚。
色碼：#000000。
圖例如下：
301
<!-- page 14 -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
16 各欄位中的提示文字，統一用灰色標示，只有在該欄位
資料完全未輸入時才會顯示，資料輸入時要自動清除。
色碼：#909090。
圖例如下：
17 使用者有權限使用，但當下因作業階段控制而不可使用
的按鈕要鎖住。
使用者無權限使用的按鈕(例：明文查詢)，不要顯示在畫
面上。
18 若按鈕按下後會有開啟小視窗操作的機制，則該按鈕的
名稱後加 3 個半形「.」，例：【查詢...】。
19 本署各分區目前有以「分局」、「作業組」、「分區」稱
呼，統一定義為「分區」。
20 欄位名稱「院所代號」統一改為「醫事機構代號」。
21 日期欄位中年度的顯示，一律以民國年呈現。
22 資料刪除要有確認機制，執行刪除時跳出 alert 確認視窗
詢問是否確認刪除，按【確認】執行刪除，按【取消】
取消本次刪除作業。
23 按鈕樣
式
按鈕啟用時為白底綠框綠字。
 色碼：底色 #FFFFFF，框線 #16858D，文字
#16858D。
 樣式：圓角長方形，只要文字，不用搭配圖示。
 預設尺寸：寬 142px，高 42px。
圖例如下：
302
<!-- page 15 -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
24 按鈕為焦點時為綠底粗體白字。
 色碼：底色 #16858D，框線 #16858D，文字
#FFFFFF 加粗體。
 樣式：圓角長方形，只要文字，不用搭配圖示。
 預設尺寸：寬 142px，高 42px。
圖例如下：
25 按鈕為停用時為灰底灰字。
 色碼：底色 #E2E4E5，框線 #8C8E90，文字
#8C8E90。
 樣式：圓角長方形，並在按鈕名稱左方加上「鎖頭」
圖示。
 預設尺寸：寬 142px，高 42px。
 圖例如下：
26 日期/時
間欄位
樣式
日期欄位的顯示格式為：YYY/MM/DD，民國年
年(3 碼，不足補 0)/月(2 碼，不足補 0)/日 2 碼，不足補
0)，例：097/02/01、114/05/21。
27 時間欄位的顯示格式為：HH:MM:SS，24 小時制，
時(2 碼，不足補 0):分(2 碼，不足補 0):秒(2 碼，不足補
0)，例：09:05:01、13:30:00。
28 日期輸入欄位，除可用萬年曆選取，也需要可在欄位直
接輸入，輸入格式：YYYMMDD(民國年)，例：
1140512，輸入完成後顯示格式為：YYY/MM/DD，例：
114/05/12。
303
<!-- page 16 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p16.jpg -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
圖例如下：
29 年度輸入欄位，除可用萬年曆選取，也需要可在欄位直
接輸入，輸入格式：YYY(民國年)，例：097、114。
圖例如下：
30 月份輸入欄位，除可用萬年曆選取，也需要可在欄位直
接輸入，輸入格式：MM，例：07、12。
圖例如下：
31 時間欄位不用小時鐘，輸入格式：24 小時制 HH:MM，
例：15:02，且輸入欄位要有提示文字。
32 資料輸
入
圖例如下：
304
<!-- page 17 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p17.jpg -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
33 下拉選
單
下拉選單的箭頭一律向下。
圖例如下：
尚未開啟下拉選項時
開啟下拉選項後
34 單選選
項
圖例如下：
35 複選選
項
圖例如下：
36 訊息視
窗
一般或作業完成訊息視窗的框線顏色為綠色。
 訊息視窗尺寸：預設寬度：450px。
 色碼：框線 #1A875454。
 訊息文字字體大小：22px
 訊息文字中之標點符號一律使用全形。
圖例如下：
305
<!-- page 18 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p18.jpg -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
37 錯誤或作業失敗訊息視窗的框線顏色為紅色。
 訊息視窗尺寸：預設寬度：450px。
 色碼：框線 #DC354569，警示圖示 #FF0000。
 訊息文字字體大小：22px。
 訊息文字中之標點符號一律使用全形。
圖例如下：
38 確認視窗的框線顏色為綠色，裡面的按鈕樣式比照前述
的按鈕標準。
 訊息視窗尺寸：預設寬度：450px。
 色碼：框線 #1A875454。
 訊息文字字體大小：22px。
 訊息文字中之標點符號一律使用全形。
 按鈕順序由左至右為【確認】、【取消】。
 按鈕預設尺寸：寬 142px，高 42px。
 焦點為該確認視窗，不可預設於任何按鈕上，以免使
用者誤按。
圖例如下：
306
<!-- page 19 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p19.jpg -->
「第三代醫療資訊系統建置案」開發規範
項次 類別 規範說明
39 分頁控
制
圖例如下：
307
<!-- page 20 -->
「第三代醫療資訊系統建置案」開發規範
三、日誌 Log 規範
(一) 文件目的與適用對象
1、本文件用於說明 WebAPI 專案中如何使用 NLog、
OpenTelemetry 及例外處理整合記錄與傳輸 Log。
2、適用對象：後端開發人員、架構師、SRE 工程師、Log 分
析人員。
(二) Log 架構與處理流程
1、Log 記錄方式
(1) 採用 NLog，將 Log 以 JSON 格式寫入本地檔
案。
(2) 檔名格式為：processname_podid_yyyyMMdd.json
(3) 每日一筆檔案。
2、Log 傳送至 CLM 的方式
編號 傳輸方式 說明
1 Kafka Log 可即時傳送。
2 TCP 檔案 特殊情境下轉為檔案方式上傳。
(三) AP 實作說明
(1) 已將 Log 開發成共用服務，以減少重複程式以達
到 clean code 之目的。同時 Log 開發成共用服務
命名也符合三代的規範。
(2) Med3Core.LogCommon 佈署在署內環境以 Nexus
建置 NuGet Server，PG 從
http://192.168.84.147:8081/repository/iisi-nhi3-nuget
選用不同版本，安裝即可使用，以減少 PG 要另外
撰寫 Log 的負擔，及加快開發速度。
308
<!-- page 21 -->
「第三代醫療資訊系統建置案」開發規範
(3) Log 開發成共用服務也會列入 GitHub 的版控及
CI/CD 的自動化佈署(包含其他的共用)。
(4) 只需 using LOGCC0001N01.Logging; 即可使用。
(5) 在環境變數中設定 Kafka IP、一段 Log Kafka
Topic：aplog、機敏 Log Kafka Topic：auditlog。
並設定為 GlobalDiagnosticsContext.Set();
(6) 使用 OpenTelemeTry SDK 需要加入 Tag 即可進
行追蹤，例如 actyvity.SetTag(“db.statement”,sql)。
程式中應記錄詳細錯誤來源與 Trace 資訊，利於排查。
try
{
...
}
catch (Exception ex)
{
activity?.SetStatus(ActivityStatusCode.Error, ex.Message);
// 記錄 OpenTelemetry Trace 錯誤
logger.Error(ex, "SQL Error!");
return Results.Problem("Database error: " + ex.ToString());
}
(四) OpenTelemetry Trace 內容
HTTP 請求(System.Net.Http)
Tag 說明
http.client.duration 請求執行時間
http.method HTTP 方法
http.url 請求 URL
http.status_code HTTP 回應碼
net.peer.name/port 目標主機與 Port
309
<!-- page 22 -->
「第三代醫療資訊系統建置案」開發規範
資料庫查詢(SQL / MongoDB)
類別 Tag 說明
SQL db.system 如 mssql、
mysql、Oracle
SQL db.statement 執行語句
SQL db.user 資料庫帳號
SQL/MongoDB otel.status_code 成功 / 失敗
MongoDB db.MongoDB.collection 集合名稱
MongoDB db.operation 操作類型(如
find, insert)
310
<!-- page 23 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p23.jpg -->
「第三代醫療資訊系統建置案」開發規範
(五) OpenTelemetry Trace Jaeger 的操作畫面
311
<!-- page 24 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p24.jpg -->
「第三代醫療資訊系統建置案」開發規範
(六) 範例程式碼：Log 與 Trace 整合
Oracle 操作範例
MongoDB 操作範例
312
<!-- page 25 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p25.jpg -->
「第三代醫療資訊系統建置案」開發規範
(七) NLog Style
屬性 說明 PodId Pod K8s 容器名稱 Namespace K8s 命名空間 ContainerImage 容器映像檔 images Machinename 節點名稱 LogTime Log 紀錄時間 SystemCode 專案代號 描述說明/範例 decenc-
deployment-
774fb695df-hm72
flo-service devharbor-
d7.intra.nhi.gov.tw/
h70githubdev/share
d/flo-service:1.0.0
hi0kmsdevtkc-
worker-nodepool-
c6wlm-k5z69-
rqz8p
採用 ISO 8601 國
際標準格式，並
設為台灣時間
2025-06-
10T16:21:57.51063
34+08:00
202501099080126 313
是否必要 是否為
預設值
A 是/
AP 是/
中台否/
中台否/
B 是
B 是
A 是/
中台否/
B 是
AP 是/
中台否/
B 是
A 是/
AP 是/
中台否/
中台否/
B 是
B 是
A 是/
中台否/
B 是
AP 是/
中台否/
B 是
是 AP 是/
中台否/
B 是
是 AP 是/
<!-- page 26 -->
「第三代醫療資訊系統建置案」開發規範
BusCode 五碼子系統別 PgmId 執行程式代號 FunCode 功能名稱 UserId 使用者 ID UserName 使用者名稱 UserRole 使用者角色 ClientIP Client IP HospId 醫事機構代號 BranchCode 分區代號 UserOs 使用者作業系統 UserBrowser 使用者瀏覽器 SessionId 瀏覽器工作階段識
別碼前端使用
TokenId 會話令牌 4 中台否/
B 是
IMSNC 是 AP 是/
中台否/
B 是
IMSNC0001S01 是 AP 是/
中台否/
B 是
WEBAPI 是 AP 否/
中台否/
B 否
SA AP 是/中台
否/B 否
AP 是/中
台否/B
否
SA AP 是/
AP 是/
中台否/
中台否/
B 否
B 否
user AP 是/
中台否/
B 否
AP 是/
中台否/
B 否
192.168.1.100 AP 是/
AP 是/
中台否/
中台否/
B 否
B 否
3501200000 否 否
0 否 否
Windows 10 AP 是/
中台否/
B 否
AP 是/
中台否/
B 否
Microsoft Edge AP 是/
AP 是/
中台否/
中台否/
B 否
B 否
abc123xyz456 否 否
eyJhbGciOiJIUzI1
是 AP 是
NiIsInR5cCI6IkpX
314
<!-- page 27 -->
「第三代醫療資訊系統建置案」開發規範
VCJ9
PageId 紀錄頁面識別 IMSNC1001S01 否 否
Duration 停留時間 4 否 否
AlertLevel 機敏功能(N 一般/Y
機敏資料
N 否 AP
是
OracleErrCode Oracle 錯誤代碼 D102001 資料已
是 AP 是/
存在
中台否/
B 是
MongoDBErrCode MongoDB 錯誤代碼 D103002 文件驗
證失敗
是 AP 是/
中台否/
B 是
SystemErrCode 系統錯誤代碼 S100101 應用程
是 AP 是/
式容器
中台否/
B 是
PgmErrCode 程式錯誤代碼 是 AP 是/
中台否/
B 是
SqlCommand Sql 指令 AP 是/
AP 是/
中台否/
中台否/
B 是
B 是
MongoDBCollection MongoDB 集合名
稱
AP 是/
中台否/
B 是
AP 是/
中台否/
B 是
Processname 程式名稱 是 AP 是/
中台否/
B 是
Type 寫入的 index 名稱
(Machinename + _ +
BusCode + _ +
FunCode)
AP 是/
中台否/
B 是
AP 否/
中台否/
B 是
RequestPath Request 路徑 是 AP 是/
中台否/
B 是
DBSpendtime 資料庫執行時間 是 AP 是/
中台否/
315
<!-- page 28 -->
「第三代醫療資訊系統建置案」開發規範
HttpMethod HTTP 請求方法 Processid 程序識別碼 Logger 日誌記錄類別 Level log 層級
Trace、Debug、
Info、Warn、
Error、Fatal
RunCaseStart 程序執行開始時間 RunCaseEnd 程序執行結束時間 RunTimeTotal 程序執行整體時間
(毫秒)
Message 錯誤訊息內容 QueryPersonalinfoR
eason
查詢機敏原因 PersonalinfoQueryR
ecords
記錄個資的查詢記
錄
Microsoft.AspNetC
ore.Routing.Endpoi
ntMiddleware
Info 採用 ISO 8601 國
際標準格式，並
設為台灣時間
2025-06-
10T16:21:57.51063
34+08:00
採用 ISO 8601 國
際標準格式，並
設為台灣時間
2025-06-
10T16:21:57.51063
34+08:00
5ms 完成取得所有醫
療機構
316
B 是
是 AP 是/
中台否/
B 否
是 否
是 AP 是/
中台否/
B 是
是 AP 是/
中台否/
B 是
是 AP 是/
中台否/
B 是
是 AP 是/
中台否/
B 是
是 AP 是/
中台否/
B 是
是 AP 否/
中台否/
B 否
否 AP 否
否 AP 否
<!-- page 29 -->
「第三代醫療資訊系統建置案」開發規範
FileName 上傳檔案名稱 FileSize 上傳檔案大小 OpenFileStart 上傳檔案處理開始
時間
OpenFileEnd 上傳檔案處理結束
時間
OpenFileTimeTotal 上傳檔案處理整體
時間
SftpTargetServer SFTP 目標主機 SftpTransferResult SFTP 傳輸結果 ExecKey 發信執行 key 值(主
機上排程會依據此
值去決定執行哪個
區塊的 db 收件檔)
EmailSeqNo 電子郵件序號 RecvUserName 收件者名稱 SendUserNmae 寄件者名稱 QueryKey 信件查詢鍵值 SendResult 傳送結果 SendCostTime 傳送耗時 SamId SAM 卡卡片標號 BatchReqAddTime 批次請求新增時間 QryRecvSeqNO 查詢的收件序號 CaseSeqNo 案件序號(批次分派
process 資料表的
seq)
JobName 單次執行批次程式
名稱
IpmJobName IPM 單次執行批次
程式序號
Extend 其他(可依 SA 自行
定義 Log 內容，以
josn 格式儲存)
return result;
}
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
否 否
317
<!-- page 30 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p30.jpg -->
「第三代醫療資訊系統建置案」開發規範
catch (MongoDBException ex)
{
activity?.SetStatus(ActivityStatusCode.Error, ex.Message);
_logger.Error(ex, "MongoDB.FindDocuments error");
throw;
}
}
}
318
<!-- page 31 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p31.jpg -->
字串
名稱
"trace" "debug" "info" "warn" "error" "fatal" 「第三代醫療資訊系統建置案」開發規範
(八) NLog 等級
"trace" => NLog.LogLevel.Trace,
"debug" => NLog.LogLevel.Debug,
"info" => NLog.LogLevel.Info,
"warn" => NLog.LogLevel.Warn,
"error" => NLog.LogLevel.Error,
"fatal" => NLog.LogLevel.Fatal,
NLog 支援的等級由低到高依序與使用時機是：
NLog.LogLevel
對應 說明
LogLevel.Trace 最細節，通常用來追蹤程式流程，幾乎不會在正式環境開啟。
LogLevel.Debug 除錯用，比 info 更詳細，通常用於開發或測試環境。
LogLevel.Info 一般訊息，記錄正常流程，例如「使用者登入成功」。
LogLevel.Warn 警告，表示潛在問題，但系統仍能運作，例如「API 回應延遲」。
LogLevel.Error 錯誤，功能失敗但系統還能繼續運作，例如「資料庫更新失敗」。
LogLevel.Fatal 致命錯誤，系統可能無法繼續運作，例如「系統啟動失敗」。
(九) NLog 設定重點(nlog.config)
1、檔名與編碼設定
2、AP JSON Layout
B 為批次
3、稽核 JSON Layout
(1) iitt_audit_log 稽核記錄檔
屬性 說明 資料描述
319
<!-- page 32 -->
「第三代醫療資訊系統建置案」開發規範
LOGIN_ID(二代) 使用者代號
AUDIT(二代) 識別稽核資料 識別稽核資料固定填入”Y”
BRANCH AUDIT
分區別
_CODE(二代)
TXT_DATE(二代) 日期 採用 ISO 8601 國際標準格式，並設
為台灣時間
2025-06-10T16:21:57.5106334+08:00
PROC_ID(二代) 作業別 三代前 9 碼程式命名
PGM_ID(二代) 程式代號 三代程式命名
MAIN_LOG(二代) 主要記錄 主要會是 SQL 查詢指令
FILE_NAME(二代) 檔案名稱 下載檔案或產生報表名稱
EXEC_OS_ID(二代) 系統執行帳號
AUDIT_BRANCH
(二代)
稽核記錄分區別 記錄稽核記錄的分區別,跨局作業
為”0”
-局本部,
非跨區則該分區別,HM 主機記錄為
"m"，IB 為"a","b","c"…
CLI_IP(二代) 用戶端 IP 位址
HOSP_ID(二代) 醫事機構代號 多筆時請以","隔開，
如 0101020017,2717030014
PRN_ID_AES(二代) 加密身分證字號 以加密後內容儲存，多筆以","隔開
EXT_FIELD2(二代) 擴展欄位二
(2) immi_log_to_irm 藥歷查詢稽核紀錄檔
屬性 說明 資料描述
LOGIN_ID(二代) 使用者代號
AUDIT(二代) 識別稽核資料 識別稽核資料固定填入”Y”
BRANCH_CODE 分區別
320
<!-- page 33 -->
「第三代醫療資訊系統建置案」開發規範
TXT_DATE(二代) 日期 採用 ISO 8601 國際標準格式，並
設為台灣時間
2025-06-
10T16:21:57.5106334+08:00
PROC_ID(二代) 作業別 三代前 9 碼程式命名
PGM_ID(二代) 程式代號 三代程式命名
MAIN_LOG(二代) 主要記錄 主要會是 SQL 查詢指令
FILE_NAME(二代) 檔案名稱 下載檔案或產生報表名稱
EXEC_OS_ID(二代) 系統執行帳號
AUDIT_BRANCH(二代) 稽核記錄分區別 記錄稽核記錄的分區別,跨局作業
為”0”
-局本部,
非跨區則該分區別,HM 主機記錄為
"m"，IB 為"a","b","c"…
CLI_IP 用戶端 IP 位址
HOSP_ID(二代) 醫事機構代號 多筆時請以","隔開，
如 0101020017,2717030014
ID_AES(二代) 加密身分證字號 以加密後內容儲存，多筆以","隔開
EXT_FIELD2(二代) 擴展欄位二
(3) pxxt_audit_trace 加密記錄檔
屬性 說明 資料描述
APPL_USER_ID(二代) 使用者代號
AUDIT(二代) 識別稽核資料 識別稽核資料固定填入”Y”
BRANCH_CODE(二代) 分區別
TXT_DATE(二代) 日期 採用 ISO 8601 國際標準格式，並設為台
灣時間
2025-06-10T16:21:57.5106334+08:00
PROC_ID(二代) 作業別 三代前 9 碼程式命名
321
<!-- page 34 -->
「第三代醫療資訊系統建置案」開發規範
PGM_ID(二代) 程式代號 三代程式命名
MAIN_LOG(二代) 主要記錄 主要會是 SQL 查詢指令
FILE_NAME(二代) 檔案名稱 下載檔案或產生報表名稱
EXEC_OS_ID(二代) 系統執行帳號
AUDIT_BRANCH(二代) 稽核記錄分區別 記錄稽核記錄的分區別,跨局作業為”0”
-
局本部,
非跨區則該分區別,HM 主機記錄為"m"，
IB 為"a","b","c"…
CLI_IP(二代) 用戶端 IP 位址
HOSP_ID(二代) 醫事機構代號 多筆時請以","隔開，
如 0101020017,2717030014
PRN_ID_AES(二代) 加密身分證字號 以加密後內容儲存，多筆以","隔開
EXT_FIELD2(二代) 擴展欄位二
(4) pxxt_decrypt_log ID 解密紀錄檔
屬性 說明 資料描述
APPL_USER_ID(二代) 使用者代號
AUDIT(二代) 識別稽核資料 識別稽核資料固定填入”Y”
BRANCH_CODE(二代) 分區別
TXT_DATE(二代) 日期 採用 ISO 8601 國際標準格式，並
設為台灣時間
2025-06-
10T16:21:57.5106334+08:00
PROC_ID(二代) 作業別 三代前 9 碼程式命名
PGM_ID(二代) 程式代號 三代程式命名
MAIN_LOG(二代) 主要記錄 主要會是 SQL 查詢指令
FILE_NAME(二代) 檔案名稱 下載檔案或產生報表名稱
322
<!-- page 35 -->
「第三代醫療資訊系統建置案」開發規範
EXEC_OS_ID(二代) 系統執行帳號
AUDIT_BRANCH(二代) 稽核記錄分區別 記錄稽核記錄的分區別,跨局作業
為”0”
-局本部,
非跨區則該分區別,HM 主機記錄
為"m"，IB 為"a","b","c"…
CLI_IP(二代) 用戶端 IP 位址
HOSP_ID(二代) 醫事機構代號 多筆時請以","隔開，
如 0101020017,2717030014
PRN_ID_AES(二代) 加密身分證字號 以加密後內容儲存，多筆以","隔
開
EXT_FIELD2(二代) 擴展欄位二
稽核 Log 與一般 AP Log 分開處理，檔名是不一樣，避免造成相互影
響。
323
<!-- page 36 -->
「第三代醫療資訊系統建置案」開發規範
(十) Log 記錄範例
{
"logtime": "2025-04-29T01:32:02.317Z",
"podid": "nuknown",
"namespace": "default",
"machinename": "HW106019",
"processname": "HMA.H4001S01",
"RequestPath": "/api/hospitals",
"HttpMethod": "GET",
"UserId": "SA",
"UserName": "SA",
"logger": "LogCommonLib.Extensions.NLogMdcMiddleware",
"level": "Info",
"RunCaseStart": "2025-04-29T01:32:01.912Z",
"RunCaseEnd": "2025-04-29T01:32:02.322Z",
"RunTimeTotal": 410.37,
"message": " ScopeProperty 記錄測試 log 成功"
}
備註：Log 欄位僅於有值時寫入，無值欄位不出現。
324
<!-- page 37 -->
「第三代醫療資訊系統建置案」開發規範
四、第三代醫療資訊系統錯誤及返回代碼規劃
(一) Return Code & Error Code 結構
{事件類型字母代碼(大寫字母一位)}{嚴重程度(數字一
位)}{事件子分類(數字三位)}{錯誤事件(數字三位)}
(二) 事件類型字母代碼(大寫字母一位)
為識別錯誤/返回事件發生的主要領域。
 D：資料庫事件
 S：系統事件
 B：業務邏輯事件
(三) 嚴重程度(數字一位)
識別事件的嚴重等級。
 0 = trace
 通常用於函式進入/離開點、迴圈每次執行等，不會影響系統
判斷。原則上僅於本地開發作為偵錯用途使用，不建議出現
在本地開發環境以外的地方。
 1 = debug
 一般開發階段用來協助還原程式邏輯、找出 bug 的訊息。原
則上為針對變數、流程、條件判斷等節點做紀錄，不建議出
現在本地開發環境以外的地方。
 2 = info
 正常流程下的業務訊息，用於紀錄系統狀態/事件，不表示錯
誤。原則上紀錄會產生影響的業務事件，或關鍵的作業狀
態。
 3 = warn
 發現可疑狀況，非預期但尚可繼續運作。原則上為提醒異常
但不至於中斷系統作業的潛在問題。
 4 = error
325
<!-- page 38 -->
「第三代醫療資訊系統建置案」開發規範
 明確的功能錯誤或失敗，需要修正或處理，但不至於系統整
體掛掉。原則上紀錄 API 處理失敗、DB 例外、參數不符等
導致作業無法完成之錯誤。
 5 = fatal
 導致服務無法運作、系統必須停止或重新啟動的嚴重錯誤。
原則上紀錄崩潰或重啟失敗等需要人員立即處理的嚴重錯
誤。
(四) 事件子分類(數字三位)
 依事 6 件,類型訂定範圍。
(五) 資料庫事件
 Oracle：020~029
 MongoDB：030~039
1、系統事件
 尚未明確規劃。
2、業務邏輯事件
 共用業務邏輯事件：001~100。
 子系統業務邏輯事件：一個子系統獨有一個子分類的號碼
101~300。
3、錯誤事件(數字三位)
 代表具體事件：001~999。
4、範例
 Oracle 資料庫錯誤:資料已存在(違反唯一鍵限制)。
 代碼為 D4020001。
 事件類型字母代碼：D。
 嚴重程度：4。
326
<!-- page 39 -->
「第三代醫療資訊系統建置案」開發規範
 子分類：020。
 錯誤事件：001。
5、使用
 程式拋出的錯誤交由共用函式，該共用函式會到
SharedLibraries/Err.Common/Resources 底下的 JSON 檔找出對應
資訊並以 JSON 格式回傳。
6、範例
 服務拋出 ORA-00001 錯誤，共用函式至路徑底下的檔案找到對
應資料：
{
// Oracle-errors.json
"1": {
"code": "D4020001",
"message": "資料已存在(違反唯一鍵限制)。
"
}…
回傳值為：
}
{
"code": "D4020001",
"message": "資料已存在(違反唯一鍵限制)。
"
}
7、子系統修訂代碼檔流程
 業務邏輯拋出的錯誤訂定於
https://hi0lgitetser01.intra.nhi.gov.tw/SharedLibraries/Err.Common/bl
ob/main/Resources/app-errors.json，各系統負責人需要先找 Github
的管理者開通 Err.Common 這個 Repository。
8、步驟說明
(1) 找到 Resources 資料夾下的 app-errors.json。
327
<!-- page 40 · picture: 2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.p40.jpg -->
「第三代醫療資訊系統建置案」開發規範
(2) 一個子系統獨有一個子分類的號碼，先搶先贏。按
照格式新增或修改代碼。
請記得填寫標題與修改
內容
(3) 開一個新分支並將修改提交到新分支。
圖 20、提交畫面
(4) 推送到 Github 後發送 Pull Request(發送後請不要自
行 Merge Pull Request)，請寄信告知管理員進行合
併。
圖 21、發送 Pull Request 畫面
(5) 管理者處理完畢或退回會回覆處理結果。
328
