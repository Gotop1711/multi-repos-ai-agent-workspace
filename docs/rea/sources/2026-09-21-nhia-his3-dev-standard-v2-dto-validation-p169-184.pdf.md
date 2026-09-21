---
source: docs/assets/rea/2026-09-21-nhia-his3-dev-standard-v2-dto-validation-p169-184.pdf
sha256: 101a9be1f2cc0dbbb6a2d810c6ea5a91f9ee40e8a3fb3b36dadc9c58a83d9745
bytes: 596193
extractor: pdfkit
status: ok
received: 2026-09-21-nhia-his3-dev-standard-v2-dto-validation-p169-184.pdf
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
七、DTO / Validation / ViewModel (一) DTO 規範
1、DTO 使用目的
DTO（Data Transfer Object）：
用於：
 API Request
 API Response
 Service 間資料傳遞
 MQ Message
 External API Mapping
目的如下：
 隔離 Domain Model。
 避免 Entity 外洩。
 避免 API 與 DB 耦合。
 統一資料格式。
 提高 API 穩定性。
 提升向前相容性。
2、禁止 Entity 直接對外
禁止：
return patientEntity;
原因：
 DB 結構外洩
 Domain 污染
 API 耦合
 欄位不可控
 安全性問題
3、所有 API 必須使用 DTO
所有：
規範
161
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
 Request
 Response
必須使用 DTO。
禁止：
 anonymous object
 dynamic
 Entity
4、DTO 必須明確責任
DTO：
應依用途拆分：
類型 用途
RequestDTO API 輸入
ResponseDTO API 回傳
QueryDTO 查詢條件
ResultDTO 查詢結果
MQDTO MQ Message
ExternalDTO 外部 API
5、DTO 必須加 DTO 後綴
範例：
 PatientDTO
 LoginRequestDTO
 OrderResponseDTO
禁止：
 PatientModel
 PatientData
6、DTO 必須為純資料物件
DTO 只能包含：
 Property
禁止：
 Business Logic
162
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
 DB Logic
 Validation Logic
 Service Call
7、DTO Property 必須明確型別
禁止：
public object Data { get; set; }
避免：
 型別不明
 Swagger 異常
 AI 文件困難
163
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
8、DTO 必須支援 Swagger
所有 DTO 需：
 XML Comment
 明確型別
 Nullable 規範
9、DTO 不得過大
DTO
應依 Use Case 切分。
避免：God DTO
10、DTO 必須考量向前相容
新增欄位允許。
刪除欄位需審核。
避免：
 API Break Change
(二) Request / Response 規範
1、Request DTO 與 Response DTO 必須分離
禁止：
同一 DTO 同時 Request/Response
原因：
 欄位責任不同
 安全需求不同
 Validation 不同
2、Request DTO 命名規範
範例：
 LoginRequestDTO
 CreatePatientRequestDTO
164
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
3、Response DTO 命名規範
範例：
 LoginResponseDTO
 PatientDetailResponseDTO
4、查詢 DTO 規範
範例：
 PatientQueryDTO
 OrderSearchDTO
5、Page Query 必須統一格式
所有分頁：
統一：
 PageIndex
 PageSize
 SortBy
 SortDirection
6、API Response 必須統一格式
統一：
{
"rtnCode": "0",
"rtnMsg": "",
"data": {}
}
7、禁止回傳 Exception Detail
禁止：
return ex.ToString();
8、Response DTO 必須最小化
只回傳：
前端需要欄位。
禁止：
165
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
 過度回傳
 DB 欄位全部外露
(三) Validator 規範
1、所有 Request DTO 必須 Validation
所有 API Request 必須 Validation。
不得：
不驗證直接進 Service
2、統一使用 FluentValidation
Validation Framework：
統一：
FluentValidation
禁止：
 DataAnnotation 為主
 Controller 手寫驗證
3、Validator 必須獨立 Class
範例：
 LoginRequestValidator
 PatientCreateValidator
4、Validator 命名規範
格式：
{DTOName}Validator
5、Validation 不得寫於 Controller
禁止：
if (string.IsNullOrWhiteSpace(name))
寫於 Controller。
6、Validation 不得寫於 Repository
166
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
Repository：
不得：
 驗證欄位
 驗證商業規則
7、Validation 錯誤需統一格式
所有 Validation Error：
必須：
 ErrorCode
 FieldName
 ErrorMessage
統一。
8、Validation 必須支援多語系
Error Message：
應支援：
 中文
 英文
(四) FluentValidation 規範
1、Validator 必須繼承 AbstractValidator
範例：
public class LoginRequestValidator
: AbstractValidator<LoginRequestDTO>
{
}
2、Validation Rule 必須集中
所有規則：
集中於：
 Validator
167
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
禁止分散。
3、必填欄位必須明確
範例：
RuleFor(x => x.UserId).NotEmpty();
4、字串長度必須限制
所有自由輸入欄位：
必須：
 MaxLength
 特殊字元限制
避免：
 DB Overflow
 WAF Blocking
5、必須呼應前端驗證機制
例如：
 長度
 型別
 大小寫
 特殊驗證(身份證、Email、統一編號等)
6、Free Style 欄位治理
例如：
 備註
 說明
 Note
 Remark
必須：
 長度限制
 特殊字元限制
 Regex 驗證
168
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
7、Regex 必須集中管理
通用 Regex 必須集中：
BaseRegex 管理。
例如：
 Email
 Phone
 Identity
 IP
8、Enum Validation 規範
若：
Enum = 0
代表：
 未選擇
必填時必須 Validation。
9、自訂 Validation Message
禁止：
Invalid input 需具體。
10、Validation Rule 不得過度複雜
複雜規則應拆：
 Domain Rule
 Service Rule
11、Validation 必須可測試
所有 Validator 必須：
 Unit Test
 Boundary Test
(五) ViewModel 規範
169
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
1、ViewModel 使用原則
ViewModel 僅適用：
特殊畫面聚合
 BFF
 Dashboard
2、ViewModel 不得取代 DTO
ViewModel 不得：
 當 Domain
 當 Entity
3、ViewModel 命名規範
範例：
 PatientDashboardViewModel
 ClaimSummaryViewModel
4、ViewModel 應聚合多來源資料
適用：
 Dashboard
 查詢整合
 統計畫面
5、ViewModel 不得直接存 DB
禁止：
 Repository 回傳 ViewModel
(六) Mapper 規範
1、DTO 與 Entity 必須 Mapping
禁止：
 Entity 直接 assign DTO
2、Mapping 必須集中管理
170
<!-- page 11 -->
「第三代醫療資訊系統建置案」開發規範
集中於：
 Mappers/
3、Mapper 命名規範
範例：
 PatientMapper
 OrderMapper
4、禁止 Controller Mapping
 Controller：
不得：
 手動大量 Mapping
5、禁止 Repository Mapping API DTO
 Repository：
只處理：
 Entity
 DB Model
6、Mapping 邏輯需可測試
複雜 Mapping 必須 Unit Test。
7、禁止過度隱式 Mapping
避免：
 無法追蹤欄位
 AI 文件困難
(七) AutoMapper 禁用規範
1、原則上禁止 AutoMapper
2、禁止原因 AutoMapper：
容易造成：
 隱式 Mapping
171
<!-- page 12 -->
「第三代醫療資訊系統建置案」開發規範
 Debug 困難
 AI 分析困難
 欄位遺漏
 效能問題
3、必須顯式 Mapping
統一：
Explicit Mapping
4、大型 DTO 更禁止 AutoMapper
避免：
 欄位污染
 Mapping 不可控
(八) MappingGenerator 規範
1、允許使用 Mapping Generator
允許：
 Source Generator
 Roslyn Generator
 自動產生 Mapping。
2、Generator 必須可追蹤
產生程式必須：
 可閱讀
 可除錯
 可追蹤
3、禁止 Runtime Reflection Mapping
禁止：
Reflection Mapping
4、Generator 必須納入版本控管
172
<!-- page 13 -->
「第三代醫療資訊系統建置案」開發規範
不得：
 Build 時隨機產生
 不可追蹤
(九) 分頁 DTO 規範
1、統一分頁格式
所有分頁：
統一：
 PageIndex
 PageSize
 TotalCount
 Items
2、禁止各系統不同分頁格式
避免：
 前端複雜化
 BFF 難整合
3、PageSize 必須限制
避免：
 大量資料拖垮系統
(十) API 契約治理規範
1、DTO 為 API Contract
DTO：
即：
API Contract 不得任意修改。
2、API Contract 必須版本化
重大異動必須：
 API Version
 DTO Version
173
<!-- page 14 -->
「第三代醫療資訊系統建置案」開發規範
3、DTO 異動需影響分析
修改 DTO 需確認：
 Frontend
 BFF
 Batch
 MQ
影響。
(十一) MQ DTO 規範
1、MQ Message 必須使用 DTO
禁止：
 dynamic
 anonymous object
2、MQ DTO 必須版本化
避免：
 Consumer Break
3、MQ DTO 必須具 TraceId
必須：
 TraceId
 CorrelationId
(十二) Batch DTO 規範
1、Batch Input 必須 DTO 化
不得：
 Dictionary
 DataTable
直接流轉。
Batch Error DTO 規範
必須包含：
欄位 說明
174
<!-- page 15 -->
「第三代醫療資訊系統建置案」開發規範
BatchId 批次
RecordId 原始資料
ErrorCode 錯誤碼
ErrorMessage 錯誤訊息
2、Retry DTO 規範
必須：
 RetryCount
 RetryTime
 LastError
(十三) 安全性規範
1、DTO 不得包含敏感資料
禁止：
 Password 明碼
 Token
 ConnectionString
2、Response DTO 必須遮罩個資
例如：
 身分證
 電話
 Email
3、Validation 必須防 Injection
所有輸入必須：
 特殊字元檢查
 Regex
 Length Limit
(十四) AI 文件生成與審查規範
1、DTO 命名需可被 AI 理解
2、Validation Rule 必須可追蹤
175
<!-- page 16 -->
「第三代醫療資訊系統建置案」開發規範
3、Mapping 必須可分析
4、API Contract 必須穩定
5、DTO 必須支援 Swagger/OpenAPI
八、Repository 與資料庫規範
(一) Repository 架構治理原則
1、Repository 為唯一資料存取層
所有資料庫操作必須透過：
Repository Layer 進行。
禁止：
 Controller 直接查 DB
 Service 直接寫 SQL
 Domain 操作 DB
 Batch Main 直接操作 Connection
2、Repository 使用目的
Repository 負責：
 SQL 管理
 DB Mapping
 Transaction 配合
 Connection 管理
 Query 執行
目的：
 隔離 DB 細節
 降低耦合
 提升可測試性
 提升 SQL 可治理性
3、Repository 不得包含業務邏輯
176
