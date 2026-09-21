---
source: docs/assets/rea/2026-09-21-nhia-his3-dev-standard-v2-nodejs-p337-348.pdf
sha256: 9cf7471ee3eaa7e752d1d3df6fb1080ffd45f82ffeca16160ca656b0745ae6f2
bytes: 762158
extractor: pdfkit
status: ok
received: 2026-09-21-nhia-his3-dev-standard-v2-nodejs-p337-348.pdf
pictures: 2026-09-21-nhia-his3-dev-standard-v2-nodejs-p337-348.pdf.p11.jpg
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
五、Node.js 開發規範
(一) 前言
各專案可根據開發需求選擇使用 JavaScript 或 TypeScript，
並作必要調整，如副檔名為.ts，本文件以 JavaScript 為例。
(二) 目錄結構
├─ src/ - 程式碼主目錄，包含所有應⽤程式相關的程式碼
│ ├─ configs/ - 設定層，放置可變設定，引入環境變數、預設
值及參數檢查等。
│ ├─ constants/ - 常數層，放置固定設定，如 http status code、
message 等。
│ ├─ controllers/ - 控制器層，負責處理 req、res 及呼叫
Services，不處理業務邏輯。
│ ├─ models/ - 資料層，定義 ORM schema (sequelize)。
│ ├─ middlewares/ - 中介層，用於攔截 req、res，進行如驗證
身分、錯誤處理等
│ ├─ routes/ - 路由層，定義 URL 與 Controller 對應關係，不處
理業務邏輯
│ ├─ services/ - 服務層，定義業務邏輯、資料庫存取等，可被
多個 Controllers 使用
│ ├─ utils/ - 工具層，共用工具
│ ├─ validations/ - 驗證層，定義資料驗證模型 (zod)
│ ├─ tests/ - 單元測試
│ └─ app.js – 建立 express 實例，掛載中介層、路由層等，最
終匯出 app 實例
├─ static/ - 靜態檔案
├─ scripts/ - 輔助腳本
├─ server.js – 伺服器啟動點，匯入 app.js，設定 listen port，處理
系統層及事件
329
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
├─ .env – 環境變數
├─ .env.template – 環境變數範例
├─ .eslintrc.js – ESlint 設定檔
├─ .gitignore – git 排除設定
├─ Dockerfile – Docker image 建置設定
├─ jest.config.js – jest 設定檔
├─ README.md – 說明文件
├─ jsconfig.json – VScode 開發環境設定
└─ package.json – 套件設定
(三) 檔案命名規範
 index.js：模組進入點
 src/ 下資料夾命名需採複數，如 controllers/、services/
 constants/ 下檔案，採下列命名原則：
 檔案名稱：小寫駝峰 (lowerCamelCase)，不必添加檔案類
型
 例如：httpStatusCode.js, respStatusCode.js
 utils/ 下檔案，採下列命名規則：
 模組為單檔案：檔案名稱使用小寫駝峰，不必添加檔案類
型
 模組為多檔案：
 於 utils/ 下建立資料夾，資料夾名稱採小寫駝峰
 資料夾內需有 index.js 作為模組入口，其餘模組檔案應
放入 src/資料夾
 例如:
├─ utils/ └── logger/
├─ src/ │ ├─ baseLogger.js
330
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
│ └─ httpLogger.js ├─ config.js └─ index.js
 models/ 下檔案，採下列命名規則：
 檔案名稱：{資料表名稱}.js
 資料表名稱：大寫駝峰 (UpperCamalCase)，單數，不必
添加檔案類型
 例如：User.js、UserAuth.js
 非上述類型檔案，遵循下列命名規則：
 檔案名稱：{模組名稱}.{模組類型}.js
 模組名稱：小駝峰 (lowerCamelCase)
 模組類型：使用上層資料夾名稱之單數命名，如
controller, service
 例如：user.controller.js, user.service.js
331
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
(四) 一般命名規則 Node.js 開發規範
類型 命名格式 範例
變數/參數名 camelCase userId, pageNumber
布林參數 isXxx, hasXxx isAdmin, hasToken
數量參數 xxxCount, xxxTotal itemCount, errorTotal
陣列參數 複數形式 + List/Array userList, tagArray
常數參數 SCREAMING_SNAKE_CASE MAX_LIMIT,
DEFAULT_TIMEOUT
函式命名
camelCase，動詞開頭，若回
傳值為布林此採疑問句式
getUserData、isActive
類別命名 PascalCase UserService
1、變數/參數命名需明確且語意清楚，例如不使用 data、info 而
用 userData、userInfo。
2、命名時不得採用保留字(如 let, var)，或容易與框架慣用字誤
解(如 express 的 req,res)。
3、命名應具備可讀性、語意性，避免使用簡寫、縮寫(除非為業
界通用如 id, url)，如 a、b、c。
4、針對不同類型的變數，應依其用途採用對應的命名慣例，例
如時間相關 xxxDate、xxxTime，文字相關 xxxText、
xxxString。
5、命名一律使用英文，不得使用中文拼音或其他語言混合。
332
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
(五) 程式開發規範
1、禁用 var，若為常數用 const，變數用 let，
2、使用嚴格等號 === 與 !==，避免使用 == 與 !=，確保類型
正確比對。
3、避免全域變數，所有變數應封裝於函式、模組或區塊範圍
內。
4、所有函式必須有具語意的名稱，禁止匿名函式直接當參數(除
非是箭頭函式且語意明確)。
5、箭頭函式 (=>) 應優先使用，除非必須使用 this 的語意才使
用 function。
6、物件與陣列解構賦值應善加利用，提升程式可讀性
const { name, email } = user;
const [first, second] = items;
7、條件句與迴圈中，避免巢狀過深。當條件複雜時，應抽出為
函式。
8、避免過早 return null 或 undefined，若需 return 物件，預設
至少 return 空物件或空陣列：
9、錯誤處理須完善，所有異步邏輯應使用 try/catch，不得忽略
Promise 的錯誤回傳。
10、禁止直接使用 console.log 除非在開發階段，應使用 logger
模組集中處理輸出。
11、撰寫單一職責函式(Single Responsibility)，每個函式僅處理
一個明確邏輯任務。
12、JSON / 物件內部屬性一律使用雙引號 "key"(尤其在傳送
API 資料時)以符合標準。
13、註解需具備語意且不得冗長：
333
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
14、函式需使用 JSDoc 註解格式
15、複雜邏輯處應標註計算過程與目的
16、共用元件模組命名
功能 建議套件名稱
設定類 gov.nhi.med3.ifr.主功能模組 .config
工具類 gov.nhi.med3.ifr.主功能模組 .util
自訂例外處理 gov.nhi.med3.ifr.主功能模
組 .exception
安全與權限 gov.nhi.med3.ifr.主功能模組 .security
(六) 程式結構與排版
1、縮排與對齊
 每層縮排 統一使用 2 空格，禁止使用 tab。
 區塊(如 if、for、function、object)必須正確對齊。
 不得混用 tab 與空格。
2、換行與空行
 每行最多 100 字元，過長應換行。
 區塊之間應保留一空行以提升可讀性。
 import/require、函式、常數群組之間建議加空行分隔。
3、括號、分號、逗號
 所有程式區塊使用 大括號 {} 包起來，即使只有一行也不省
略。
 每行結尾 強制加上分號 ;(避免 ASI 問題)。
 多行物件、陣列宣告時，最後一項也加上逗號(trailing comma)
4、模組化設計
334
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
 每個功能模組(例如：User、Order)應該包含自己的 Controller、
Service、Model、Route。
 避免巨型檔案，單一模組檔案大小建議不超過 300 行。
 功能相似或關聯性強的程式碼放在同一資料夾。
5、單一職責原則(SRP)
 每個函式、類別、模組只專注於一項功能或責任。
 增加模組的可讀性與可測試性，方便後續維護。
6、異常與錯誤管理
 全域錯誤處理機制(Express error middleware)
 服務層統一拋出錯誤，Controller 層捕捉並回傳標準錯誤格式。
7、配置與環境變數管理
 不同環境(開發、測試、正式)分開配置。
 使用 .env 文件管理敏感資訊，並用 config 模組集中讀取。
8、日誌與監控
 各層級加入適當日誌，記錄關鍵事件與錯誤。
 可整合 winston 或 pino，並搭配日誌輪替與集中管理
9、單元測試與整合測試
 各服務層邏輯皆應有對應測試。
 測試資料與模擬依賴，確保測試獨立與重現。
(七) API 設計
1、RESTful 設計風格
 使用 HTTP 方法(GET、POST、PUT、PATCH、DELETE)表達資
源行為。
 路由路徑用複數名詞表示資源，如 /users、/orders。
335
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
 不使用動詞在路由中，動作由 HTTP 方法表示。
2、API 路徑設計
 路徑命名、參數採駝峰式 (camelCase)
3、請求與回應格式
 請求及回應原則上採 JSON 格式
 需使用正確的 HTTP method
 回應狀態碼需符合正確情境
狀態碼 意義 用途範例
200 請求成功 GET、PUT 成功
201 資源建立成功 POST 建立新資料
204 無內容回應 DELETE 成功無回傳內容
400 請求錯誤 參數格式錯誤、必填欄位缺失
401 未授權 未登入或 Token 無效
403 禁止存取 權限不足
404 找不到資源 查無資料
409 資料衝突 重複註冊、資源狀態衝突
500 伺服器內部錯誤 程式異常、資料庫錯誤
4、分頁設計
 支援分頁避免一次回傳大量資料。
336
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
 常用參數 page(頁碼)、limit(每頁筆數)。
 回傳結果應包含分頁資訊，如總筆數、總頁數。
(八) 後端開發環境
1、開發工具
(1) Visual Studio Code 最新版
(2) 延伸模組
 ESLint
 Prettier
2、程式語言與架構
(1) Node.js v22.18.0 LTS
(2) Express v4.21.2
3、可用第三方套件
原則使用下列套件，各專案應保持套件一致性以利維護整
合，如專案需使用其他套件，應與系統架構師申請，並確認相
關套件為開源授權，避免付費爭議等議題，最終視架構程式碼
為準。
(九) 單元測試
1、單元測試註解加註說明
利用 AI 成生單元測試程式碼，必須在程式碼加註說明，
但非 AI 成生單元測試程式碼不在此限，但須依必須內容加註
解說明。
2、測試工具
套件：jest、supertest
3、測試流程
 安裝套件：npm install --save-dev jest supertest
各元件版本請參考使用程式庫白名單。
337
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
 設定 Jest：新增 jest.config.js 填寫以下內容
module.exports = {
testEnvironment: "node", // 適合後端測試
collectCoverage: true, // 啟用覆蓋率
collectCoverageFrom: ["src/**/*.js"], // 想收集的檔案
範圍
coverageReporters: ["text", "lcov"], // 輸出格式
coveragePathIgnorePatterns: ["/node_modules/"] // 忽
略資料夾
}; "test": "jest src/tests"
 新增測試指令：於 package.json 的 scripts 加入以下內容
 測試配置：於 src/tests 新增測試程式，範例如下
describe('Sample Test', () => {
it('should test that true === true', () => {
expect(true).toBe(true)
})
})
 啟動測試：npm test
338
<!-- page 11 · picture: 2026-09-21-nhia-his3-dev-standard-v2-nodejs-p337-348.pdf.p11.jpg -->
「第三代醫療資訊系統建置案」開發規範
4、測試說明
(1) File：
 顯示被分析的檔案，All files 是整體摘要。
 如果有啟用 collectCoverageFrom，就會列出符合條件的檔
案。
(2) % Stmts (Statements 覆蓋率)
 所有可執行的敘述 (statements) 有多少被測試執行到。
 例如：
const x = 1; // 這是一個 statement
console.log(x); // 這也是一個 statement
(3) % Branch (Branches 覆蓋率)
 判斷分支 (if / else / switch / 三元運算子) 的覆蓋情況。
 例如：
if (a > 0) { ... } else { ... }
這裡就有 2 個 branch：a > 0 和 else。
測試有沒有涵蓋兩條路徑。
(4) % Funcs (Functions 覆蓋率)
339
<!-- page 12 -->
「第三代醫療資訊系統建置案」開發規範
 有多少 function 被呼叫過。
 例如：
function add(a, b) { return a + b; }
如果測試沒有呼叫 add()，Funcs 覆蓋率就會是 0%。
(5) % Lines (Lines 覆蓋率)
 有多少程式行被執行到。
 和 Statements 類似，但更偏向「實際程式碼行數」。
(6) Uncovered Line #s
 哪些行號沒有被測試覆蓋。
 例如：
src/app.js | 60 | 50 | 70 | 65 | 12, 27-30
代表 app.js 的第 12 行，還有 27~30 行沒有被測試執
行到。
340
