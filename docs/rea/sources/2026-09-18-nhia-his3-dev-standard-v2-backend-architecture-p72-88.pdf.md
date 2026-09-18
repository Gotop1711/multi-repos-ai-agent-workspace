---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-backend-architecture-p72-88.pdf
sha256: bf917519dbd28a4ecfb891931f39ef5b4a5313fd35ff7f6479237da1f139873f
bytes: 752465
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-backend-architecture-p72-88.pdf
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
二、後端整體架構治理
(一) .Net Core WebAPI 架構
1、 統一架構原則
第三代醫療資訊系統後端服務，統一採用：
 .Net Core WebAPI
 RESTful API
作為標準後端架構。
除特殊經架構審核核准外：
不得自行使用：
 MVC Server Render
 WCF
 WebForm
 gRPC（非特殊需求）
 Minimal API
 非標準 REST 架構
避免不同系統產生不同開發模式。
2、 架構目標
.Net Core WebAPI 架構須達成：
項目 目標
模組化 降低耦合
可維護性 易修改
可測試性 易 Mock
可觀測性 易監控
可擴充性 易新增功能
安全性 API 安全治理
容器化 Kubernetes 部署
高可用性 支援擴充
64
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
3、 標準後端架構
標準後端架構如下
Vue3前端
Gateway/BFF
Web API
Application Layer
Domain Layer
Repository Layer
Database/Extermal
Services
圖、標準後端架構
4、 Controller 職責限制
Controller 僅負責：
 Request 接收
 DTO 驗證
 呼叫 Application Service
 Response 回傳
不得：
 撰寫 SQL
 撰寫商業邏輯
65
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
 控制 Transaction
 呼叫 Database
5、 API 統一規範
所有 API：
必須：
 使用 RESTful API
 使用統一 ApiResponse
 使用 Swagger/OpenAPI
 使用統一 ErrorCode
 使用統一 Validation
6、 API Version 治理
所有對外 API：
必須支援：
 API Version
 向前相容
不得：
 任意移除欄位
 任意變更 Response 格式
(二) Layered Architecture（分層架構）
1、 分層設計原則
所有後端系統：
必須採用分層架構。
目的：
 降低耦合
 提升可維護性
 提升可測試性
66
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
 明確責任邊界
2、 標準分層
標準分層如下：
Layer 職責
API Layer 對外 API
Application Layer Use Case / Service
Domain Layer 業務模型
Repository Layer 資料存取
Infrastructure Layer Integrations Layer DB / Framework
外部系統
Shared Layer 共用元件
3、 分層依賴方向
API
Application
Domain
Infrastructure
不得反向依賴。
4、 禁止跨層操作
禁止
 Controller 直接操作 DB
 Repository 呼叫 API
67
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
 Domain 存取 Infrastructure
 Application 直接寫 SQL
5、 分層責任明確化
各層：
必須：
 明確責任
 明確邊界
 明確依賴
避免：
 巨型 Service
 巨型 Repository
 多責任 Class
(三) DDD（Domain Driven Design）原則
1、 DDD 使用目的
DDD 用於：
 強化業務模型
 降低業務複雜度
 建立清楚 Domain 邊界
2、 Domain 為核心
系統核心：
應以：
 Domain
 Business Rule
為中心。
不得：
 以資料表為中心設計
68
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
 以 UI 為中心設計
3、 Bounded Context 原則
不同子系統：
必須：
 有獨立 Domain
 有獨立邊界
避免：
 Domain 污染
 共用錯誤模型
4、 Entity 與 DTO 分離
不得直接：
 Entity 回傳 API
 Entity 當 Request DTO
避免：
 Domain 污染
 API 耦合
5、 Business Rule 集中化
業務規則：
必須集中於：
 Domain
 Application Service
不得：
 分散於 Controller
 分散於 Repository
(四) CQRS 原則
1、 CQRS 使用目的
69
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
系統應採：
 Command
 Query
責任分離模式。
2、 Query 與 Command 分離
Query：
僅負責：
 查詢
 Read
Command：
 負責：
 新增
 修改
 刪除
 Transaction
同一 Function 儘量不用，以符合單一職責
3、 禁止 Query 修改資料
Query：
不得：
 Update
 Insert
 Delete
4、 複雜查詢可獨立 QueryService
大型查詢：
可建立：
 QueryService
 集中管理。
70
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
(五) Dependency Injection（DI）原則
1、統一使用 DI
所有：
 Service
 Repository
 ApiClient
 MQ Client
必須使用：
 Dependency Injection
管理。
2、禁止直接 new
禁止：
 new UserRepository()
3、Constructor Injection 為標準
統一使用：
 Constructor Injection
不得：
 Property Injection
 Service Locator
4、必須使用 Interface
Service：
必須：
 Interface + Implementation
模式。
5、DI 生命週期規範
類型 使用
Scoped Repository / DB
71
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
Singleton Transient Cache / Config
特殊 Stateless Service
(六) Service Layer 原則
1、Service 為業務核心
Application Service：
負責：
 Use Case
 業務流程
 Transaction
 Validation 協調
2、禁止巨型 Service
單一 Service：
不得：
 過多責任
 過多方法
 過大檔案
3、Service 不得直接依賴 UI
Service：
不得：
 依賴 HttpContext
 依賴前端欄位格式
4、Service 不得直接寫 SQL
SQL：
必須透過：
72
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
 Repository
管理。
(七) Repository Layer 原則
1、Repository 為唯一 DB 存取層
所有 DB 操作：
必須經由：
 Repository
進行。
2、禁止跨層 DB 操作
禁止：
 Controller 寫 SQL
 Service 開 Connection
 Domain 存取 DB
3、Repository 職責
Repository：
僅負責：
 SQL
 DB Mapping
 Transaction 配合
不得：
 寫業務規則
 寫流程控制
4、Repository 不得互相呼叫
避免：
 Repository Chain
 DB 邏輯污染
73
<!-- page 11 -->
「第三代醫療資訊系統建置案」開發規範
5、Repository Base 治理
共用：
 ExecuteAsync
 QueryAsync
 Transaction
應統一於：
 BaseRepository
(八) Integrations Layer 原則
1、外部系統整合統一管理
所有：
 外部 API
 MQ
 FTP
 SFTP
 第三方系統
必須集中於：
 Integrations Layer
2、禁止 Service 直接呼叫外部 API
不得：
new HttpClient()
直接呼叫。
3、統一 ApiClient
所有外部 API：
必須建立：
ApiClient
封裝。
4、Retry 與 Timeout 治理
74
<!-- page 12 -->
「第三代醫療資訊系統建置案」開發規範
所有外部呼叫：
必須：
 Timeout
 Retry
 Circuit Breaker
避免外部系統拖垮主系統。
5、外部 DTO 分離
外部 API DTO：
不得直接：
 當內部 DTO
 當 Domain Model
必須進行 Mapping。
(九) Shared Layer 原則
1、Shared Layer 使用目的
Shared Layer：
用於：
 共用元件
 共用 Utility
 共用 Constants
 共用 Extensions
 共用 Logging
 共用 Validation
2、禁止 Shared 污染
不得將：
 業務邏輯
 特定子系統邏輯
75
<!-- page 13 -->
「第三代醫療資訊系統建置案」開發規範
放入 Shared。
3、Shared 必須可重用
Shared 元件：
必須：
 可獨立使用
 可測試
 無特定系統依賴
4、Shared 版本治理
Shared：
必須統一版本。
不得：
 各系統自行修改
 各系統自行複製
(十) Bootstrapper 原則
1、Bootstrapper 使用目的
Bootstrapper：
負責：
 DI 註冊
 Config 初始化
 Middleware 初始化
 Logging 初始化
2、禁止 Program.cs 過大
Program.cs：
不得包含：
 大量 Service Register
 Business Logic
76
<!-- page 14 -->
「第三代醫療資訊系統建置案」開發規範
 大量 Middleware Logic
3、Bootstrapper 模組化
應拆分：
 ServiceBootstrapper
 RepositoryBootstrapper
 LoggingBootstrapper
 SwaggerBootstrapper
 AuthenticationBootstrapper
4、統一初始化流程
所有系統：
應維持一致初始化流程：
 Config
◼ → Logging
◼ → DI
◼ → Middleware
◼ → Swagger
◼ → Authentication
◼ → API
5、Middleware 治理
Middleware：
必須集中管理。
避免：
 各系統自行新增
 Middleware 順序錯亂
 Exception Middleware 衝突
(十一) 可觀測性（Observability）架構治理
1、所有系統必須支援 Observability
必須支援：
77
<!-- page 15 -->
「第三代醫療資訊系統建置案」開發規範
 Logging
 Tracing
 Metrics
 Monitoring
2、統一 OpenTelemetry
系統統一使用：
 OpenTelemetry
進行：
 Trace
 Metrics
 Correlation
3、統一 TraceId
所有：
 API
 Batch
 MQ
 Integration
必須支援：
 TraceId
 CorrelationId
4、統一 Log 格式
所有 Log：
必須統一格式。
避免：
 無法查詢
 無法關聯
 無法追蹤
5、Log 資料安全性
(1) 不在日誌中記錄敏感信息，例如資料庫密碼、個資
等具安全性資料。
78
<!-- page 16 -->
「第三代醫療資訊系統建置案」開發規範
(2) 資料庫連線字串記錄在 Keycloak 的 Hardcoded
claim 內。而取出內容需使用的 key 要先以 KMS
進行加密再以 Base64 方式存放在 Secret.yaml 內。
6、針對敏感性資料處理方式
針對敏感性資料，於後端處理所有呈現在應用系統所產製
之報表及應用系統畫面，預設顯示方式皆採部分遮蔽方式處理
如下
(1) 身分證字號於系統畫面與報表預設顯示方式：
顯示方式 欄位顯示值 說明
部分遮蔽：解密後遮掩後
4 碼(身分證最後一碼為檢
查碼故無需遮掩)
A12345**** 部分畫面或程式可選擇明
文顯示功能，並保留執行
記錄
(2) 姓名於系統畫面與報表預設顯示方式：
採取中文名字中間字以○代替、英文名字則在第 3~8 碼以*代替
姓名組合 欄位顯示值
姓名為中文 2 個字 黃○
姓名為中文 3 個字 黃○明
姓名為中文 4 個字 黃○○明
姓名為英文字 第 3~8byte 以半型*顯示
(十二) 容器化（Containerization）架構治理
1、所有系統必須支援 Container 化
後端系統：
79
<!-- page 17 -->
「第三代醫療資訊系統建置案」開發規範
必須支援：
 Docker
 Kubernetes
部署。
2、禁止依賴本機環境
不得依賴：
 本機路徑
 本機 Registry
 本機排程
3、設定檔外部化
所有：
 ConnectionString
 Token
 Secret
必須外部化。
不得 Hard Code。
80
