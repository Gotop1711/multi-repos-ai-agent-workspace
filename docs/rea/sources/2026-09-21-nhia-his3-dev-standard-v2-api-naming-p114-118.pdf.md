---
source: docs/assets/rea/2026-09-21-nhia-his3-dev-standard-v2-api-naming-p114-118.pdf
sha256: 37f90faf32ab04da046baa6dee7dc0d78361a0232e4a6345b516526e6f0fa7c3
bytes: 626397
extractor: pdfkit
status: ok
received: 2026-09-21-nhia-his3-dev-standard-v2-api-naming-p114-118.pdf
pictures: 2026-09-21-nhia-his3-dev-standard-v2-api-naming-p114-118.pdf.p4.jpg 2026-09-21-nhia-his3-dev-standard-v2-api-naming-p114-118.pdf.p5.jpg
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
 VPN
 Med3Core.VC.功能集合.Service。
 例如：Med3Core.VC.Log.Service。
 WWW
 Med3Core.WC.功能集合.Service。
 例如：Med3Core.WC.Log.Service。
106
<!-- page 2 -->
「第三代醫療資訊系統建置案」開發規範
8、API 命名
(1) API 依 RESTFul API HTTP Method GET, POST,
PUT, DELETE, PATCH 規範
 依據 http request method 處理不同功能
 POST：查詢、新增資料；或是同時處理新增、修改、刪
除資料
 PUT：修改資料
 DELETE：刪除資料
(2) 以名詞方式命名
 API 命名不可使用動詞命名例如 Get，要使用名詞命名。
(3) 一個畫面前端對應一個後端 API Controller，處理
前端所有資料增、刪、改、查 需求。
例如：
 HMDWC0200S01 -> HMDWC0200N01，HMDWC0200S02
-> HMDWC0200N02
 若相同作業(同 9 碼)不同畫面，可呼叫同一個後端
controller 之 function(action)
 HMDWC0200S01 -> HMDWC0200N01/HospDataQuery
 HMDWC0200S02 -> HMDWC0200N01/HospDataAdd
 HMDWC0200S02 -> HMDWC0200N01/HospDataUpdate
 HMDWC0200S02 -> HMDWC0200N01/HospDataDelete
 HMDWC0200S02 -> HMDWC0200N01/HospDataLists
 HMDWC0200S02 -> HMDWC0200N01/HospDataLists
(3) Controller 下 function 命名
 使用大駝峰命名。
 開頭禁用 GetXXXX、PostXXXX、PutXXXX、
DeleteXXXX 與 http request method 相同字眼，動詞請放
最後。
107
<!-- page 3 -->
「第三代醫療資訊系統建置案」開發規範
 function 使用之參數命名為小駝峰，包含 input、output。
 參數資料型態為 Json。
(4) 使用複數型態
 資源如果是集合，所以要使用複數名稱。
(5) 命名定義須具有意思
 在三代儘量不要使用 Get，除非十分確認資料沒有安全性
問題，否則不可以使用 Get。
 不可使用無意義的名詞，必須與程式功能具有關係，應盡
可能識別出用途，不可過於簡易。
例如：
MemberData、DataList…，應改為 NhiMemberData，
HospDataList
(6) 正確範例說明
 正確範例，以同一個 API Controller 為例
 新增藥商資料
使用 POST，Function name DrugFirmDataAdd
 取得單一藥商資料
使用 POST，Function name DrugFirmDataQuery
 修改藥商資料
使用 PUT，Function name DrugFirmDataUpdate
 取得所有藥商資料
使用 POST，Function name DrugFirmDataList
 刪除藥商資料
使用 DELETE，Function name DrugFirmDataDelete
(7) 例外處理原則
108
<!-- page 4 · picture: 2026-09-21-nhia-his3-dev-standard-v2-api-naming-p114-118.pdf.p4.jpg -->
「第三代醫療資訊系統建置案」開發規範
 已提供給外部服務使用之 API，為確保其服務運作，API
的命名不需要遵守三代的命名原則。
例如：提供全民健保行動快易通 健康存摺 APP 之相關
API、讀卡機控制軟體 6.0、健保卡上傳 2.0、家醫大平
台、共同傳輸平台對外服務 API。
9、數據中台命名
(1) 中台程式命名
 Loader ：依照所使用語言，依照上一頁編碼處理
 Nifi：依上一頁規則如下範例
 Nifi Processor：類似共用函式概念，不編碼，依照實際功能
性命名
(2) 方法命名
(3) 變數命名
私有成員變數必須要以屬性(Property)方式開放給外部存
取，不可以單獨的宣告為 public。
類別中的方法(methods)名稱應以它要執行的動作來命
名，可以是動詞或是動作類的名詞。例如 Copy()、Create()、
FindArticle()或是 UpdateAuthorization()等等，若動作的對象是
複數時(例如回傳一份清單或是預期會多於一個的物件)，則應
以對象的複數方式來表示之。 例如 GetProducts()、
109
<!-- page 5 · picture: 2026-09-21-nhia-his3-dev-standard-v2-api-naming-p114-118.pdf.p5.jpg -->
「第三代醫療資訊系統建置案」開發規範
MoveFiles()或是 LookupCustomerList()。
方法應以執行單一動作(single action)為原則，除非必要，
不得用會跨越不同類別的方式來發展方法。
針對提取資料的方法，建議以 Get 開頭來命名提取單一
資料的方法，但不可用在 Controller，以 Lookup 開頭命名提
取多筆資料的方法，以 Search 或 Find 開頭命名搜尋資料的方
法。
(4) 常數命名
10、Controller 規範
Controller 僅負責：
 Request 接收
110
