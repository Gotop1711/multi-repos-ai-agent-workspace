---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-naming-p130-141.pdf
sha256: 3c42e78bbbe030a4d6d38c16a66a3af44659c2310c42e59f22b7c41b7a25faa7
bytes: 4607670
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-naming-p130-141.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-naming-p130-141.pdf.p4.jpg
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
2、Bootstrapper 必須模組化
應拆分：
 ServiceBootstrapper
 RepositoryBootstrapper
 LoggingBootstrapper
 SwaggerBootstrapper
3、禁止 Program.cs 巨型化
Program.cs 不得：
 超大型
 混雜邏輯
 大量 Register
4、Bootstrapper 必須統一
所有系統應維持：
 一致初始化流程
 一致 Middleware 順序
 一致 Logging
5、Bootstrapper 必須集中治理
不得：
 各系統自行改造初始化流程
 各系統自行插 Middleware
避免：
 系統不一致
 架構失控
五、命名規範
(一) 通用命名規範
1、命名治理目的
命名規範（Naming Convention）為第三代醫療資訊系統最重
122
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
要之基礎治理規範之一。
統一命名目的如下：
 提升程式可讀性。
 提升程式可維護性。
 降低跨團隊理解成本。
 降低新人學習成本。
 提升 Code Review 效率。
 提升審查單位查核一致性。
 提升 AI 文件生成與程式分析能力。
 避免不同子系統產生不同命名文化。
 避免縮寫與個人化命名造成維護困難。
2、命名基本原則
所有命名必須：
 清楚
 可讀
 可理解
 可搜尋
 可推測用途
不得：
 過度縮寫
 無意義名稱
 個人習慣命名
 拼音命名
 模糊命名
3、統一使用英文命名
所有：
 Class
 Method
123
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
 Property
 Variable
 DTO
 Table Alias
 API
一律使用英文命名。
禁止中文拼音
範例：
 ❌ GetBingRen()
 ❌ ChuLiData()
 ❌ YiZhuService()
正確：
 ✅ GetPatient()
 ✅ ProcessData()
 ✅ OrderService()
4、命名必須具描述性
名稱需能直接表達用途，。
禁止：
 ❌ data
 ❌ obj
 ❌ temp
 ❌ x
 ❌ service1
正確：
 ✅ patientInfo
 ✅ orderItems
 ✅ loginResponse
 ✅ batchRetryService
5、禁止無意義縮寫
禁止：
 ❌ usr
124
<!-- page 4 · picture: 2026-09-18-nhia-his3-dev-standard-v2-naming-p130-141.pdf.p4.jpg -->
「第三代醫療資訊系統建置案」開發規範
 ❌ cfg
 ❌ mgr
 ❌ proc
 ❌ tmp
125
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
除非為業界標準縮寫：
可接受 說明
API DTO URL Application Programming Interface
Data Transfer Object
Uniform Resource Locator
SQL Structured Query Language
ID Identifier
JSON JavaScript Object Notation
6、禁止底線連接字彙
一般命名禁止：
 patient_name
 user_service
必須使用：
 PatientName
 UserService
或：
 patientName
 userService
7、DI Private Field 允許底線前綴
為符合 .NET DI 慣例：
DI 注入之 private readonly field 允許：
 private readonly IUserService _userService;
 private readonly ILogger _logger;
但僅限 private field
DI 注入欄位不得擴散至：
 local variable
 property
 parameter
126
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
8、Boolean 命名規範
Boolean 必須使用：
前綴 用途
is 狀態
has 是否存在
can 是否允許
should 是否應該
enable 是否啟用
範例：
 isActive
 hasPermission
 canDelete
 shouldRetry
 enableCache
 禁止：
 flag
 status
 check
9、避免過長命名
命名需具描述性，但避免：
GetPatientOrderDetailInformationByHospitalCodeAndDepartme
ntCodeService
應適度拆分。
10、禁止同義不同名
同一概念，全系統必須一致。
例如：
正確統一 禁止混用
Patient User / Person / Human
Order Ticket / Request
Department Dept / Dep
127
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
11、縮寫必須統一
所有縮寫必須，
 有定義
 有文件
 全系統一致
不得：
 各系統各自縮寫
(二) 類別命名規範
1、Class 使用 PascalCase
所有 Class 必須使用：
 PascalCase
範例：
 PatientService
 OrderRepository
 BatchMonitoringService
2、Class 名稱必須為名詞
Class 應為：
 名詞
 名詞片語
禁止：
 DoProcess
 HandleData
3、Service 類別需加 Service
範例：
 PatientService
 LoginService
 BatchRetryService
4、Repository 類別需加 Repository
128
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
範例：
 PatientRepository
 OrderRepository
5、Validator 類別需加 Validator
範例：
 LoginRequestValidator
 PatientQueryValidator
6、Exception 類別需加 Exception
範例：
 BusinessException
 ValidationException
7、禁止 Generic 命名
禁止：
 Manager
 Helper
 Processor
 CommonService
除非確實為共用基底。
8、Batch 類別命名規範
Batch 必須明確表達用途。
範例：
 PatientSyncBatchService
 ClaimSettlementBatchService
禁止：
 Batch1
 SyncProcess
(三) Interface 命名規範
1、Interface 必須以 I 開頭
範例：
 IUserService
129
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
 IPatientRepository
 ILoginValidator
2、Interface 名稱必須與實作一致
範例：
Interface Implementation
IUserService UserService
OrderRepository
IOrderRepository 3、禁止無意義 Interface 名稱
禁止：
 IManager
 IHelper
 IProcessor
4、Repository Interface 規範
範例：
 IPatientRepository
不得：
 IPatientDao
(四) Service 命名規範
1、Service 必須明確責任
Service 名稱需能表達，Use Case 業務責任。
2、禁止過度通用命名
禁止：
 DataService
 CommonService
 MainService
3、業務型 Service 範例
 PatientRegistrationService
 ClaimSettlementService
 MedicalOrderService
4、Batch Service 必須明確標示
130
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
範例：
 FileImportBatchService
 ClaimRetryBatchService
5、Background Service 規範
範例：
 CacheSyncBackgroundService
 KafkaConsumerBackgroundService
(五) Repository 命名規範
1、Repository 必須對應 Domain
Repository 應對應：
 Aggregate
 Entity
 Use Case
2、Repository 使用 PascalCase
範例：
 PatientRepository
 ClaimRepository
3、禁止 Table 導向命名
禁止 TB_PATIENTRepository
4、Repository 不得使用 DAO
統一使用 Repository
禁止：
 DAO
 DAL
5、Query Repository 規範
大型查詢可使用：
PatientQueryRepository
(六) DTO 命名規範
131
<!-- page 11 -->
「第三代醫療資訊系統建置案」開發規範
1、DTO 必須加 DTO 後綴
範例：
 PatientDTO
 LoginResponseDTO
2、Request/Response DTO 規範
範例：
 LoginRequestDTO
 LoginResponseDTO
3、Query DTO 規範
範例 PatientQueryDTO
4、禁止 Entity 當 DTO
禁止 Entity 直接回 API
5、DTO 命名需對應 Use Case
避免：
 DataDTO
 CommonDTO
(七) Query 命名規範
1、查詢物件需加 Query
範例：
 PatientQuery
 OrderQuery
2、查詢 Handler 命名
範例 PatientQueryHandler
3、QueryService 規範
複雜查詢可使用：
PatientQueryService
(八) Enum 命名規範
132
<!-- page 12 -->
「第三代醫療資訊系統建置案」開發規範
1、Enum 必須加 Enum 後綴
範例：
 OrderStatusEnum
 GenderEnum
2、Enum 使用 PascalCase
範例：
public enum OrderStatusEnum
{
Pending,
Processing,
Completed
}
3、Enum 值禁止縮寫
禁止：
 Proc
 Comp
4、Enum = 0 規範
必須：
None = 0 代表：
 未選擇
 未設定
5、前端必填 Enum 驗證
若為必填 0 必須視為：未選擇，需 Validation。
(九) Controller 命名規範
1、Controller 必須加 Controller
範例：
 PatientController
 LoginController
133
