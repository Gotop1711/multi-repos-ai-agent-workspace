---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf
sha256: 0958a53c3022e73c774e55665f90b75ea2ea791c2f164635536050ce995212cc
bytes: 2723440
extractor: pdfkit
status: ok
received: 第三代醫療資訊系統建置案_開發規範_V2.0_p29-58.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p1.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p14.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p15.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p16.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p17.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p18.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p19.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p20.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p21.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p24.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p25.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p26.jpg 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p27.jpg
---
<!-- page 1 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p1.jpg -->
「第三代醫療資訊系統建置案」開發規範
圖 7、前後端分離架構圖
21
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
肆、前端(Vue3)開發規範
Vue3 規範：風格指南請參考官方網站：https://vuejs.org/。
一、專案結構與規範
(一) 前端整體架構定位
 前端定位為 UI Layer（畫面呈現層）
 不負責核心業務邏輯
 不可直接呼叫後端 API
 所有資料來源必須統一透過 BFF（Backend For Frontend）
 目的：隱藏後端 API、降低耦合、提升安全性
(二) 目錄結構
保持清晰的目錄結構，便於維護與擴展。
1、publics/-放置圖示與圖片
├── images/ - 圖片資源
├── icons/ - 圖⽰
2、src/ -程式碼主目錄，包含所有應用程式相關的程式碼
src/
├─ api/
│ ├─ modules/
│ │ ├─ auth/
│ │ │ ├─ types.js
│ │ │ └─ index.js
├─ layouts/ - 頁面布局
├─ router/ - Vue Router 路由配置
├─ utils/ - 工具函式集
3、下方列出項目為共用項目請勿任意更改，如需要修改請提供
申請：
22
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
 auth/ -認證相關
 components/ - 全域共用元件
 composables/ - Vue3 組合式函式
 helpers/ - 工具函式
 layouts/ - 頁面布局
 router/ - Vue Router 路由配置
 utils/ - 工具函式集
4、API 呼叫規範
 - 僅可使用相對路徑：/api/**
 - 不得寫死 IP、Domain、後端實體網址
 - 不得在環境設定檔中出現後端真實位址
5、API 共用項目規範
 - 共用元件不得任意修改
 - 如需修改必須提出申請並經架構審核
 - 跳窗訊息要使用 Element Plus Dialog
(三) 微前端架構規範（Module Federation）
 - 主系統（Shell）僅提供共用 Layout 與殼層功能
 - 子系統可獨立開發與部署
 - 子系統彼此不得相互依賴
 - CSS 必須使用 scoped 或 namespace class
 - 禁止全域覆寫樣式或全域覆寫 UI 套件樣式
二、前端開發慣例
1、命名規範
(1) 文件命名
23
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
前後端命名規格會統一在命名原則處理。
 **文件命名：**使用 kebab-case(如 user-profile.vue)。
 **元件命名：**使用 PascalCase(如 BaseButton)。
 **變數與方法：**使用駝峰命名法(如 handleSubmit)。
(2) 元件封裝
對於重複使用的元件，進行二次封裝，並放置於
components/ 目錄下。
2、CRUD 元件結構
標準 CRUD 必須拆為：
 - edit
 - form
 - list
 - table
3、使用規範
(1) 樣式與佈局
 使用 Element Plus 的 Layout Container 與 Grid 系統（el-
container、el-row、el-col）進行響應式佈局。
 統一使用 SCSS 管理樣式，所有共用樣式、變數與主題設
定集中於 styles/ 目錄。
 避免直接修改 Element Plus 原始樣式或覆寫 node_modules
內容，應透過：
◼ SCSS Variables
◼ CSS Variables
◼ Theme Config
◼ class 擴展方式
進行客製化。
 頁面樣式應以「頁面 class scope」管理，避免全域污染。
 優先使用 Flex/Grid 進行版面控制，避免大量使用 inline
style。
24
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
(2) 元件使用
 優先使用 Element Plus 提供的標準元件（如 el-table、el-
form、el-dialog、el-tabs）。
 避免直接操作原生 HTML 元素實作功能性 UI（例如自行
手刻 modal、select、pagination）。
 共用功能需封裝為 reusable components，統一放置於：
◼ components/common
◼ components/base
等共用目錄。
 元件事件與資料流應遵循 Vue3 Composition API 與單向資
料流原則。
 禁止直接操作 DOM（例如 document.getElementById、
jQuery 操作），應透過 Vue Reactive 機制處理。
(3) Composition API
 優先使用 Composition API 管理邏輯，確保代碼結構清晰
且便於重用。
4、必填欄位規範
 必填欄位需加 class="required"
 顯示紅色「*」(#FF0000)
5、欄位樣式規範
 非必填欄位：#666666
25
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
 必填欄位：#FF0000
 欄位內容：#000000
 提示文字：#909090
 畫面底色：#FFFFFF
6、排版規範
 採三欄式設計
 欄位標題不可斷行
 標題與欄位間隔 1 個半形空白
7、權限控管
 有權限但不可操作 → 鎖住
 無權限 → 不顯示
8、樣式 CSS 規範
 Vue 單檔元件（SFC）使用 scoped 樣式
 使用明確命名空間（Namespace）之 class
 若使用 Element Plus，應避免以全域方式覆寫其元件樣式
三、驗證規範
1、基本原則
 前後端驗證必須一致
 必須包含長度限制、特殊符號過濾、RegEx 驗證
 主系統建立統一驗證模組
 子系統透過 Federation 引用
 所有驗證邏輯應集中於 src/utils/validate.js
 禁止各頁面自行重複實作驗證規則
2、驗證規範
(1) 日期驗證規範
 系統日期格式統一使用民國年（YYY/MM/DD）
26
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
 支援格式：
◼ YYY/MM/DD
◼ YYYMMDD
 年月格式支援：
◼ YYY/MM
◼ YYYMM
 必須驗證：
◼ 日期格式正確
◼ 日期存在性
◼ 閏年判斷
◼ 系統日期不可超過限制
 提供統一函式：
◼ validateDate
◼ validateYearMonth
◼ validateSysDate
◼ validateSysMonth
◼ isLeapYear
◼ isValidRocDate
(2) Email 驗證規範
 Email 必須符合 RFC 基本格式
 不允許包含逗號
 必須過濾常見 typo：
◼ gmai
◼ gmal
◼ gmil
◼ gail
 - 必須過濾常見錯誤 domain：
◼ .con
◼ .con.tw
◼ .te
◼ .hine.net
 - 提供統一函式：
◼ checkEmail
(3) 密碼驗證規範
27
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
 密碼僅允許英文與數字
 長度限制：6~15 碼
 不允許特殊符號
 提供統一函式：
◼ checkPassword
(4) 身分證與統編驗證規範
I. 台灣身分證 / 居留證
 支援：
◼ 本國身分證
◼ 舊式外來人口統一證號
◼ 新式外來人口統一證號
 必須進行檢查碼驗證
 提供統一函式：
◼ validateTaiwanId
II. 統一編號
 必須為 8 碼數字
 必須符合財政部統編檢查邏輯
 支援第 7 碼為 7 之特殊規則
 提供統一函式：
◼ isValidGUI
(5) 數值驗證規範
 - 純數字：
◼ isDigit
◼ isDigitOnly
 - 整數：
◼ isInteger
 - 小數：
◼ isNumeric
 - 數值格式：
◼ checkNumber
28
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
 - 時間格式：
◼ checkTime
(6) 字元與長度驗證規範
 ASCII 字元長度 = 1
 非 ASCII（中文）長度 = 2
 必須提供 Byte Length 驗證
 必須檢查特殊字元
 提供統一函式：
◼ getByteLength
◼ validateByteLength
◼ hasSpecialChar
◼ isEnglish
(7) DataType 驗證規範
系統欄位格式需支援以下型別：
型別 說明
C(n) 中文欄位
S(n) 特殊中文字欄位
A(n) 英數欄位
P(n) 純數字欄位
D 日期欄位
ID 身分證欄位
N(p,s) 數值欄位
M(p,s) 金額欄位
 必須提供 parseDataType 驗證解析
 必須提供 vDataType Directive
 Directive 必須於 mounted / updated 自動套用
 不合法資料需自動 focus 至欄位
(8) Vue Directive 規範
29
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
 統一使用 vDataType 處理欄位格式
 Directive 不得直接寫於頁面內
 所有欄位規則必須可重複使用
 禁止頁面自行綁定 keyup 驗證
(9) 錯誤訊息規範
 驗證錯誤訊息需集中管理
 錯誤提示需使用 Element Plus 元件
 不得使用 alert()
 必須支援：
◼ 必填錯誤
◼ 格式錯誤
◼ 長度錯誤
◼ 系統限制錯誤
四、最佳實踐
1、ESLint
配置 ESLint 規範代碼風格，推薦使用 eslint-plugin-vue。
2、Prettier
結合 Prettier 格式化代碼，與 ESLint 一致。
3、狀態管理
使用 Pinia 作為狀態管理工具。
30
<!-- page 11 -->
「第三代醫療資訊系統建置案」開發規範
4、路由管理
使用 Vue Router 進行路由配置，實現模組化與動態加載。
5、效能優化
 使用動態加載 (import()) 減少初始包大小。
 使用 Vue 的內建指令(如 v-memo)進行渲染優化。
 啟用只載入你實際需要的元件(component)或功能模組，而
不是一次把整個 UI 套件庫都載入進來。
五、前端共用元件
依據不重複開發與統一操作邏輯的原則，開發過程中將陸
續抽取出各類共用元件提供不同子系統共同使用。
1、一般共用
將使用 Element Plus ，統一呈現或操作方式，包含：確
認視窗、有狀態之按鈕群組、驗證元件、日期、月曆、訊息
提示、API Call 等。
2、醫療元件
病歷通用查詢元件、通用文字元件、通用表格元件、通
31
<!-- page 12 -->
「第三代醫療資訊系統建置案」開發規範
用圖形元件、TPR 元件。
3、硬體相關元件
讀卡/三卡驗證、拍照上傳、本機列印、遠端列印。
六、測試
 請參考單元測試-前端單元測試。
七、安全性規範
1、- 禁止使用 eval()
2、- 禁止使用 innerHTML 直接注入內容
3、- 所有輸入內容需經過驗證
4、- 必須防止 XSS 與 Injection
5、- LocalStorage 禁止存放敏感資訊
6、- Token 必須由 BFF 管控
八、強制遵守清單
1、- 必須透過 BFF
2、- 不得寫死後端位址
3、- 微前端不得互相污染
4、- CSS 必須 scoped
5、- 前後端驗證一致
6、- 不得自行安裝套件
7、- UI 必須符合色碼規範
8、- 權限控制正確
9、- 必須撰寫單元測試
10、- 禁用 AJAX，改用 axios
32
<!-- page 13 -->
「第三代醫療資訊系統建置案」開發規範
11、- 禁用 jquery
12、- 禁止頁面自行實作驗證邏輯
13、- 必須使用統一 validate 模組
14、- 必須使用 vDataType Directive
九、前端開發環境
1、開發工具
 Node.js v23.6.1 最新版
 Visual Studio Code 最新版
2、程式語言與架構
 Vue3 v3.5.13 + Vite 6.0.0 最新版
3、Visual Studio 延伸模組安裝
4、請勿自行安裝其他元件，以避免授權(收費)等問題，需要其
他元件時，請跟系統架構師申請。
5、UI 框架及其他運用擴充套件請參考使用程式庫白名單。
33
<!-- page 14 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p14.jpg -->
「第三代醫療資訊系統建置案」開發規範
(二) 前端 UI 框架
前端開發 Style 請參考附件二。
1、健保資訊網服務系統 Internet
(此為示意圖，非真正畫面)
(1) 套用共用 UI 框架，分為”共用框架區”與”子系統工
作區”：
A、共用框架區
 下載專區、聯絡窗口、網路地圖、網路使用說明。
 依人使用者不同介面：一般民眾、藥商、醫事機構、其他
機構、其他服務。
 下方網站頁腳(Footer)。
B、子系統工作區
 子系統畫面
34
<!-- page 15 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p15.jpg -->
「第三代醫療資訊系統建置案」開發規範
2、健保資訊網服務系統 VPN
(1) 登入
(此為示意圖，非真正畫面)
(2) 套用共用 UI 框架，分為”共用框架區”與”子系統工
作區”：
A、共用框架區
 下載專區、聯絡窗口、網路地圖、網路使用說明、資安專
區。
 下方網站頁腳(Footer)。
B、子系統工作區
 登入介面：可使用醫事人員卡、健保卡、自然人憑證卡、
醫事機構卡、政府單位憑證卡、健保 OTP 憑證、行動自
然人憑證。
35
<!-- page 16 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p16.jpg -->
「第三代醫療資訊系統建置案」開發規範
3、首頁
(此為示意圖，非真正畫面)
(1) 套用共用 UI 框架，分為”共用框架區”與”子系統工
作區”：
A、共用框架區
 下載專區、聯絡窗口、網路地圖、網路使用說明、資安專
區。
 左側選單頁。
 下方網站頁腳(Footer)。
B、子系統工作區
 首頁中間上方區為最新公告消息，下方區服務項目對應到
左選單頁大項目。
36
<!-- page 17 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p17.jpg -->
「第三代醫療資訊系統建置案」開發規範
4、功能作業
(此為示意圖，非真正畫面)
(1) 以預檢醫療費用申報收件狀況查詢為例，套用共用
UI 框架，分為”共用框架區”與”子系統工作區”：
A、共用框架區
 下載專區、聯絡窗口、網路地圖、網路使用說明、資安專
區。
 左側選單頁。
 下方網站頁腳(Footer)。
B、子系統工作區
 預檢醫療費用申報收件狀況查詢。
37
<!-- page 18 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p18.jpg -->
「第三代醫療資訊系統建置案」開發規範
5、醫事人員溝通平台
(1) 登入
(此為示意圖，非真正畫面)
(2) 套用共用 UI 框架，分為”共用框架區”與”子系統工
作區”：
A、共用框架區
 回健保資訊首頁、使用指南、常見問題、諮詢窗口。
 下方網站頁腳(Footer)。
B、子系統工作區
 登入介面：可使用健保讀卡機、晶片讀卡機。
38
<!-- page 19 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p19.jpg -->
「第三代醫療資訊系統建置案」開發規範
6、首頁
(此為示意圖，非真正畫面)
(1) 套用共用 UI 框架，分為”共用框架區”與”子系統工
作區”：
A、共用框架區
 回健保資訊首頁、使用指南、常見問題、諮詢窗口。
 左側選單頁
 下方網站頁腳(Footer)
B、子系統工作區
 尚未處理表單提醒。
39
<!-- page 20 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p20.jpg -->
「第三代醫療資訊系統建置案」開發規範
7、電子轉診多合一整併作業
(此為示意圖，非真正畫面)
(1) 套用共用 UI 框架，分為”共用框架區”與”子系統工
作區”：
A、共用框架區
 回健保資訊首頁、使用指南、常見問題、諮詢窗口。
 左側選單頁。
 下方網站頁腳(Footer)。
B、子系統工作區
 電子轉診多合一整併作業。
40
<!-- page 21 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p21.jpg -->
「第三代醫療資訊系統建置案」開發規範
8、醫療資訊系統
(此為示意圖，非真正畫面)
(1) 套用共用 UI 框架，分為”共用框架區”與”子系統工
作區”：
A、共用框架區
 回健保資訊首頁、使用指南、常見問題、諮詢窗口。
 左側選單頁。
 下方網站頁腳(Footer)。
B、子系統工作區
 公告事項。
41
<!-- page 22 -->
「第三代醫療資訊系統建置案」開發規範
十、前端主系統及子系統微前端配置
(一) 微前端架構說明
一旦前端架構變得更加複雜，充滿了概念、套件和框架，
保持儲存庫快速、乾淨且面向單一目的的好方法就是使用微前
端架構。三代使用 Webpack 5 ( Module Federation)做為微前
端，主要目的為了前端不會只有一個專案，可依不同子系統具
有不同專案，必免在前端程式更新時影響到其他子系統。
1、核心目標：
讓不同 Web 應用(或模組)在執行時動態共享程式碼。
2、常見用途
(1) 微前端(Micro-frontend)
(2) 在不重新部署整個專案的情況下更新某個子模組
(3) 多個專案共享相同的 UI 元件或工具模組
3、特點
(1) 支援 runtime 加載(非 build time)
(2) 模組可共享依賴(如 Vue、React)
(3) 主機(Host)與遠端(Remote)之間是鬆耦合
4、Vue3 專案使用 BFF 之目的
在 Vue3 SPA(Single Page Application)中，若直接呼叫後端
服務：
(1) 不同後端 API 格式不統一 → 前端要寫很多資料
轉換程式
(2) 需要多次呼叫不同 API 才能組成一頁 → 增加網
路延遲
(3) 有跨域(CORS)問題
42
<!-- page 23 -->
「第三代醫療資訊系統建置案」開發規範
(4) 後端 API 可能暴露太多細節給瀏覽器端
(5) BFF 的好處：
 統一 API 格式
 Vue3 永遠只對接 BFF，不管後端有幾個系統。
 減少網路請求
BFF 可以一次向多個服務取資料再回傳給前端。
 安全性
隱藏內部 API、資料庫結構，只讓 Vue3 接 BFF。
 專屬邏輯
前端需要的特殊邏輯可放在 BFF，不影響後端核心服務。
(二) 子系統配置
1、子系統結構
(1) src/ -程式碼主⽬錄，包含所有應⽤程式相關的程
式。
(2) subSystemRouter.js 設定。
子系統將路由結構提供給主系統(不需要將子系統 vue-
router 提供給主系統)。
43
<!-- page 24 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p24.jpg -->
「第三代醫療資訊系統建置案」開發規範
44
<!-- page 25 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p25.jpg -->
「第三代醫療資訊系統建置案」開發規範
(3) 子系統 vite.config 設定
45
<!-- page 26 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p26.jpg -->
「第三代醫療資訊系統建置案」開發規範
(三) 主系統配置
1、主系統 router 設定
46
<!-- page 27 · picture: 2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.p27.jpg -->
「第三代醫療資訊系統建置案」開發規範
2、主系統 vite.config 設定
47
<!-- page 28 -->
「第三代醫療資訊系統建置案」開發規範
十一、使用 BFF 層
(一) BFF(Backend For Frontend)
1、BFF 是介於前端(Vue3) 與後端服務/第三方 API 之間的一
層後端服務：
(1) 聚合資料：把多個 API 的資料整理成前端直接可
用的格式
(2) 過濾/轉換資料：只回傳前端需要的欄位，避免暴
露不必要資訊
(3) 處理安全性：統一 Token、Session 驗證，不讓前
端直接暴露後端 API
(4) 減少前端複雜度：避免 Vue3 直接對接多個後端
服務，降低維護成本
(二) Vue3 + BFF 架構圖
Vue3
Requests
BFF
User
Service
Order
Service
圖 8、Vue3 + BFF 架構圖
第三方
API
48
<!-- page 29 -->
「第三代醫療資訊系統建置案」開發規範
(三) 實作重點
1、前端(Vue3)
(1) 只呼叫 /api/...(BFF 提供的 API)
(2) 使用 Axios/Fetch，統一錯誤處理
(3) Vuex/Pinia 存放從 BFF 回來的資料
// example: /src/api/user.js
import axios from 'axios'
export const getUserProfile = () => {
return axios.get('/api/user/profile')
}
2、BFF 層(Node.js / .NET)
(1) 匯整資料
(2) 轉換格式
(3) 權限驗證
(4) 快取(減少對後端的壓力)
(5) 可用技術：
 Node.js + Express/NestJS
 .NET 8 Web API
 Spring Boot
例：Node.js BFF 範例
import express from 'express'
import axios from 'axios'
const app = express()
// BFF API
app.get('/api/user/profile', async (req, res) => {
const token = req.headers.authorization
const user = await axios.get('http://userservice:8080/profile',
{
headers: { Authorization: token }
49
<!-- page 30 -->
「第三代醫療資訊系統建置案」開發規範
})
const orders = await
axios.get(`http://orderservice:8080/user/${user.data.id}/orders`
)
// 匯整成前端需要的資料格式
res.json({
name: user.data.name,
orderCount: orders.data.length
})
})
app.listen(3000, () => console.log('BFF server running on port
3000'))
3、後端服務(微服務或單體系統)
(1) 專注於自身的業務邏輯
(2) 不直接面向前端，透過 BFF 存取
4、開發流程
(1) 前端 Vue3 → 設計所需資料格式
(2) BFF → 聚合後端 API
(3) 後端 → 提供必要資料 API
(4) 部署
 Vue3 SPA 部署到 CDN
 BFF 部署到 Node.js/.NET 伺服器
 後端服務獨立部署
5、BFF 命名
因為佈署到容器的問題，BFF 層會獨立成為一個專案，以
IMSNC 為例，在 GitHub Repositories 會再增加 IMSNC-BFF，
而專案會命名為 Med3BFF.IMSNC
50
