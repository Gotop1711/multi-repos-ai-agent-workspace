# rea — rea-proto-data-creator-acceptance

Writes: REA_PROTO_DATA_CREATOR (main)
Status: draft

## 目標
工具已經出貨。2026-09-23 你給的三份文件（定義、資料採集規則、產出規則）已 ingest 進
workspace，其中定義了的 13 個 rule 模組已照著寫進程式，兩份資料表檔跑出 13 個檔案、12 026 筆
body，每個檔案 validate 零錯誤（[rea-proto-data-creator-setup](rea-proto-data-creator-setup.md)、
`REA_PROTO_DATA_CREATOR@d52f321`）。產出形式依你 2026-09-23 的裁定：每個 rule 模組一個檔案，起日
訖日與 `specificConfig` 全欄位照產出規則的共通規則。
剩下的都在你手上：貼上伺服器驗收、child 的 remote、還沒寫規則的六個 rule 模組。這份 plan 就是
那張清單。第 1 到 4 步是你自己的操作，不需要簽名，做完會落在 setup plan 的 `Verified:`；第 7 步
的規則一到，對應的程式才是這份簽名蓋住的工作。

## Writes
`REA_PROTO_DATA_CREATOR (main)`：303–307 與 401 的 rule 模組，以及 205/206 若日後裁定要改時的修正。
`Signed:` 出現之前不寫任何 child；就算簽了，每一件都要等你的規則。`catalog/repos.yaml` 的 remote
和所有文件屬於 workspace 的工作，不在這道閘門內。

## 步驟 — 驗收，在 Azure host 上
Host `https://rea-api-dea9h4bbbvf9bpch.eastus2-01.azurewebsites.net`，Swagger 在
`/swagger`（`REA_UI@a024004 .env.development:6`）。指令在 `projects/rea_proto_data_creator` 下執行。

1. **先問 host 這個醫令已經有什麼。** 起日訖日不再由你挑：產出規則固定 `ruleStartDate` 2026-01-01、
   `ruleEndDate` 2910-12-31，build 不收日期，`data/out/` 已是目前規則的產出。要查的是 host 上該醫令
   有沒有比 2026-01-01 更晚的版本：有的話 `Rule/Save` 回 500、`Rule/SaveWork` 只安靜地回
   `success: false`（`REA_PROTO_BE@ba161ff Services/RuleService.cs:261-274`、`:424-437`；`rule` 和
   `workflow` 兩個 collection 各自檢查）。問法：`POST /api/v1/Payment/Detail/Get`，body
   `{"itemCodes":["01023C"],"pageNumber":1,"pageSize":10}`；回傳的 `ruleStartDate` 與
   `ruleDateHistory` 是 `rule` 這邊的既有版本（`Services/PaymentService.cs:243-268`），`0001-01-01`
   表示還沒有規則；`workflow` 那邊沒有 endpoint 可查。最保險是挑一個回 `0001-01-01` 的醫令。已有
   規則的醫令：起日同為 2026-01-01 會覆蓋現行版本、更早的會被關在 2025-12-31（`:283-298`、
   `:307-318`）。body 裡的 2910-12-31 不會被存下來，後端一律存 9999-12-31（`:339`、`:413`），檢核也
   只讀 9999-12-31 的版本（`Services/ValidationJobService.cs:572-578`）——這是對的，不必改。
2. **同一筆 body 貼兩次。** 從一個 rule 模組的檔案裡挑第 1 步定的那個醫令，例如
   `data/out/items/r302/01023C.json`（0 到 2 歲、unit Y，只含 302）。先 `POST /api/v1/Rule/Save`，
   再把同一份貼到 `POST /api/v1/Rule/SaveWork`，兩支都要回 `success: true`；只有 `SaveWork` 會寫出
   檢核讀得到的 `workflow`（`Controllers/RuleController.cs:26-44`）。注意：同一個醫令、同一個起日，
   後貼的 body 會整個取代先貼的 `rules[]`（`Services/RuleService.cs:283-298`），所以一次只測一個
   rule 模組；`validate` 看到同一個醫令出現在兩個檔案時會警告。
3. **對那個醫令跑一次 validation job。** `POST /api/v1/ValidationJob/Batch`，帶一個真實申報批次：
   `HospId`、`HospDataType`、`FeeYearMonth`、`ApplyType`、`ApplyDate`，`OrderCode` 填該醫令；輪詢
   `ValidationJob/Status` 到結束。必須是 `Completed`：`Failed` 是空的 rule 單元會有的樣子
   （declare-verify › What will surprise you）；沒接到 Oracle 的 host 也會 `Failed`，用訊息分辨。
   結果裡只有你貼的那個 rule 模組；個別申報不通過是資料的事，不是 payload 格式的事。
4. **在 setup plan 補上 `Verified:`。** 第 1 到 3 步都成立之後才寫；這一行只有人能寫。

## 步驟 — 其餘
5. **給 child 一個 remote。** `catalog/repos.yaml` 還是 `remote: none`，這台磁碟是唯一副本。
6. **205/206 對「所有項目」，僅紀錄，暫不處理（你的裁定，2026-09-23）。** 採集規則讓 5 275 個
   醫令每一個都帶 205 和 206；產出規則把 `FULL_TIME_DOC` / `FULL_TIME_EXEC` 對到 `mainSetting`
   1/2，但 generator 不讀 `mainSetting`，只要 `doctorTypes` 02/01 加 `employmentType` 01 就對每個
   醫令編出 專任 檢核（`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`、
   `FullTimeDoctorExecutionRuleGenerator.cs:24-38`）；表單上 1/2 的意思是 無限制 / 除山地離島地區
   之外基層院所。旗標為 `1` 的醫令只有 64 / 41 個。程式照規則寫；只在貼 `r205.json` / `r206.json`
   時才會碰到。
7. **303–307、401。** 採集規則與產出規則兩份文件裡這六個 rule 模組還是空的；補上後各一個 commit。

不列為步驟，但長期成立：`main` 和 `rea` 由你的 shell 推送。

## 完成條件
setup plan 帶有 `Verified:`；child 有 remote 也推上去了；第 6 到 9 步各有裁定並落地，或由你裁定
不做，並把裁定寫進 repository doc。
