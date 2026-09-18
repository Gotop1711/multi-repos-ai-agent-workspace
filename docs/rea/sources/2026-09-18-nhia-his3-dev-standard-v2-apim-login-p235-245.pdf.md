---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf
sha256: 4f6ec07a3d83bf95e7618370278fa84081c7c25742c420918139a47f38158e24
bytes: 798295
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.p5.jpg 2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.p6.jpg 2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.p9.jpg
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
柒、Web API 管理(APIM)
一、有效管理 API
為有效管理 API 以達到驗證、管理、流量控管、監控等目
的，三代導入 Keycloak、Kong 達到 APIM 管理。
二、身分認證與授權管理。
(一) Keycloak 是一個開源的身分和訪問管理(IAM)解決方案。它可以
管理使用者、角色、群組，並支援 OAuth2、OpenID Connect 等協
議。用於 API 場景時，Keycloak 負責驗證使用者身分並發放存取
令牌(Access Token)。
(二) 當 API 需要訪問控制時，可以將 Keycloak 做為 OAuth2 的授權伺
服器，API Client(例如前端、行動 App)登入後取得 Token，往 API
請求時附帶此 Token。
(三) API 閘道管理與串接
1、Kong 是一個高效能 API 閘道，負責 API 流量的路由、負載
平衡、速率限制、安全防護等。
2、Kong 可以整合 Keycloak，透過擴充功能(如 Kong-oidc)驗證
API 請求中的 Token 是否合法。只有通過 Keycloak 驗證的
請求才可存取後端 API。
(四) 集中式政策與安全性
1、結合兩者可統一 API 存取政策，例如只允許特定角色或權限
的使用者訪問特定 API。
2、可以集中管理 API 的身分驗證、授權、日誌紀錄與稽核，減
少重複設計與潛在安全漏洞。
(五) 易於擴充與整合
1、Keycloak 支援多種身分來源(LDAP、AD、社群登入)，Kong
227
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
則可輕鬆擴充 API 管理功能。
2、企業可以靈活擴展 API 數量與存取政策，而不需手動在每個
API 服務單獨實作身分驗證。
三、APIM 管理機制
若有一個提供用戶資訊的 API，希望對這個 API 進行身分
驗證、流量限制和監控。步驟如下：
1、在服務器上安裝 Kong，並設置好它作為 API Gateway。
2、註冊 API
將用戶資訊 API 註冊到 Kong，這樣所有的請求將經由
Kong 處理。
3、設置身分驗證
配置 Kong 使用 JWT 或 API 密鑰來進行身分驗證。
4、設置流量限制
配置對 API 請求設置 QPS 限制，防止濫用。
5、監控和報告
將 API 使用數據發送到 Prometheus 進行監控並保留日誌
(CLM)，使用 Grafana 顯示視覺化報告。
四、Keycloak 運用機制
(一) 企業內部應用的單點登錄 (SSO)
在企業內部許多應用需要集中管理用戶身分與訪問權限，
Keycloak 可以整合所有這些應用，並提供統一的登錄界面。
(二) 多租戶應用
使用 Keycloak 管理不同租戶的用戶，並且設定每個租戶
的獨立認證與授權機制。
228
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
(三) Web 應用與 API 的身分認證(優先導入)
用來保護 Web 應用和 RESTful API，確保只有經過認證
的用戶才能訪問。
(四) 雙因子登錄系統
證提供者。
提供雙因子登錄機制如 Google 登錄可以輕鬆集成這些認
(五) 移動應用的身分認證
用統一的身分登錄。
將 Keycloak 用於移動應用的認證需求，確保移動用戶使
(六) 開發內部的企業管理系統(單點登錄 SSO)
這個系統包含多個子應用，這些應用提供單點登錄
(SSO)，並確保只有具有某些角色(如"Admin"、"User")的用戶
能夠訪問對應的功能。
(七) 建立 Keycloak 步驟
(如 Docker)。
安裝並啟動 Keycloak。可以是本地環境或是容器化部署
(八) 創建客戶端 (Client)
1、在 Keycloak 中，為每個應用創建一個客戶端。這樣
Keycloak 就能管理每個應用的認證和授權。
2、設定角色與授權
(1) 為應用系統定義角色，並將這些角色分配給不同的
用戶。例如，將"管理員"角色分配給具有管理權
限的用戶。
(2) 配置 SSO。
 配置 Keycloak，所有子應用系統都使用相同的 Keycloak
229
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
實例來管理認證。這樣用戶只需登錄一次，即可無縫訪問
所有應用。
(3) 使用雙因子 Google 登入
(九) 如果希望提供 Google 登錄，可以在 Keycloak 中配置 Google
作為身分提供者，用戶可以選擇使用 Google 帳號登錄。
五、APIM 作業流程
(一) Kong 註冊
提供給其他應用程式(後端 API)使用的 API 要先在 Kong 進
行註冊，目前規劃是由 IPD 進行 Kong 註冊。
(二) 建立 Keycloak clientID
應用程式要先至 Keycloak 建立 client，及 scope 並取得
ClientSecret，並轉為 Base64 方式存放在 Secret.yaml 內。
(三) 呼叫外部 API
1、當需要呼叫外部 API 時，需取出 ClientSecret(Base64 轉回)，
在 Body 用 x-www-form-urlencoded 傳入
grant_type:client_credentials、scope:申請的
ClientSecret(Base64 轉回) scope、client_id: 申請的
client_id、client_secret:
2、呼叫 Dev 環境
https://med3Keycloakdev.intra.nhi.gov.tw/realms/NHI/protocol/o
penid-connect/token，取回 System Access_Token。
3、傳至 Kong
再把 System Access_Token 放在 Headers 內傳至 Kong，Url
內容依 Kong 註冊 API 時的內容傳送，此時 Kong 會依傳來的
System Access_Token 進行驗證，驗證通過時會呼叫後方 API，
回傳依原 API 規範處理，如驗證未通過會回驗證不通過。
230
<!-- page 5 · picture: 2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.p5.jpg -->
「第三代醫療資訊系統建置案」開發規範
圖 15、APIM 作業流程圖
231
<!-- page 6 · picture: 2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.p6.jpg -->
「第三代醫療資訊系統建置案」開發規範
捌、三代登入機制
一、IAM(Intranet)登入機制
圖 16、IAM 登入機制流程圖
(一) 使用者多因素登入頁面
1、署內人員以 AD 方式、公文卡及一次性 mail 驗證登入。
2、審查醫師以醫事人員卡或健保卡刷卡。
3、署外廠商以帳號、密碼及 TOTP 雙因子驗證(Google 驗證)
(二) 提供使用者帳號來取 Token
經由驗卡機制審查通知，先以 client_id、scope、
client_secret 呼叫 Keycloak 取得 token。再以帳號、密碼或憑證
ID，及 token 呼叫 Keycloak。
(三) Med3 Web API
232
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
1、經由 Keycloak 呼叫 Med3 Web API，驗證傳入帳號、密碼或
憑證 ID 是合法性。
2、如果是合法的，則回傳該帳號所屬的角色及選單權限 json 內
容。
(四) 回傳 JWT Token
Keycloak 將角色及選單權限包在 claim 裡，產生具有角色
及選單權限的 JWT User Token 回給 IAM 登入作業。
(五) Med3 Intranet 醫療系統產生選單
Med3 Intranet 醫療系統依接收到的 User Token，再用
client_secret 解開 User Token 內容而產生該用戶的選單。
(六) User Token 生命週期
1、Keycloak 本身可以設定其生命週期，可依需求進行設定。
2、在 Med3 Intranet 醫療系統會使用 Cookies 計算其生命週期，
Cookies 生命週期會在環境變數進行設定，當使用者操作每
一項功能時會檢查 Cookies 是否過期，如果尚未過期
Cookies 生命週期會重新計算。如果 Cookies 生命週期已經
過期會強迫登出系統，回到登入頁面。
(七) 進入子系統權限檢查
1、前端預防使用者跳過登入審查機制
前端會將 User Token 放置於 BFF 層，其一目的是使用者
用[開發者模式]是無法看到 Token 的，可避免 Token 外流。
前端會用 client_secret 解開 User Token 內容，檢查該用戶
是否具有執行目前要求的執行權限，如果沒有則擋掉並告知無
執行權限。反之則正常執行。
2、後端預防使用者跳過登入審查機制
233
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
後端也會用 client_secret 解開 User Token 內容，檢查該用
戶是否具有執行目前要求的執行權限，如果沒有則擋掉並告知
無執行權限。反之則正常執行。
(八) APIM Kong 流程，比照 APIM 作業流程，呼叫外部 API。
二、IWP(VPN)登入機制(流程圖如圖 17)
(一) 使用者多因素登入頁面(如圖 18)
234
<!-- page 9 · picture: 2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.p9.jpg -->
「第三代醫療資訊系統建置案」開發規範
圖 17、IWP 登入機制流程圖
圖 18、IWP 使用者多因素登入頁面圖
(二) 驗證登入憑證合法性
透過 IWP Web API 驗證登入憑證合法性。驗證通過回傳使
235
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
用者帳號及角色資訊。
因 IWP VPN 登入有多系統共同使用如大家醫、雲藥等，
在登入時多代入登入 Type 確定登入系統。
(三) 提供使用者帳號來取 Token
經由驗卡機制審查通知，先以 client_id、scope、
client_secret 呼叫 Keycloak 取得 token。再以帳號 ID，及 token
呼叫 Keycloak。
(四) IWP Web API
性。
1、經由 Keycloak 呼叫 IWP Web API，驗證傳入帳號 ID 是合法
2、如果是合法的，則回傳該帳號所屬的角色及選單權限 json 內
容。
(五) 回傳 JWT Token
Keycloak 將角色及選單權限包在 claim 裡，產生具有角色
及選單權限的 JWT User Token 回給 VPN 登入作業。
(六) VPN 產生選單
VPN 醫療系統依接收到的 User Token，再用 client_secret
解開 User Token 內容而產生該用戶的選單。
(七) User Token 生命週期
1、Keycloak 本身可以設定其生命週期，可依需求進行設定。
2、在 VPN 醫療系統會使用 Cookies 計算其生命週期，Cookies
生命週期會在環境變數進行設定，當使用者操作每一項功
能時會檢查 Cookies 是否過期，如果尚未過期 Cookies 生命
週期會重新計算。如果 Cookies 生命週期已經過期會強迫登
出系統，回到登入頁面。
236
<!-- page 11 -->
「第三代醫療資訊系統建置案」開發規範
(八) 進入子系統權限檢查
1、前端預防使用者跳過登入審查機制
前端會將 User Token 放置於 BFF 層，其一目的是使用者
用[開發者模式]是無法看到 Token 的，可避免 Token 外流。
前端會用 client_secret 解開 User Token 內容，檢查該用戶
是否具有執行目前要求的執行權限，如果沒有則擋掉並告知無
執行權限。反之則正常執行。
2、後端預防使用者跳過登入審查機制
後端也會用 client_secret 解開 User Token 內容，檢查該用
戶是否具有執行目前要求的執行權限，如果沒有則擋掉並告知
無執行權限。反之則正常執行。
APIM Kong 流程，比照 APIM 作業流程，呼叫外部 API。
237
