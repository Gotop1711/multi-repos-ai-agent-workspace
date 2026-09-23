# rea — rea-proto-data-creator-acceptance

Writes: REA_PROTO_DATA_CREATOR (main)
Status: draft

## 目標
工具已經出貨。2026-09-23 你給的三份文件（定義、資料採集規則、產出規則）已 ingest 進
workspace，其中定義了的 12 個 rule 模組已照著寫進程式，真實匯出檔跑出 5 275 筆 body，validate
零錯誤（[rea-proto-data-creator-setup](rea-proto-data-creator-setup.md)、`REA_PROTO_DATA_CREATOR@369fbfc`）。
剩下的都在你手上：貼上伺服器驗收，以及四個規則本身需要你裁定的問題。這份 plan 就是那張清單。
第 1 到 4 步是你自己的操作，不需要簽名，做完會落在 setup plan 的 `Verified:`；第 6 到 9 步的
裁定一到，對應的程式改動才是這份簽名蓋住的工作。

## Writes
`REA_PROTO_DATA_CREATOR (main)`：`rules/r202.js`、303–307 與 401 的 rule 模組，以及 205/206 或
101–104 若裁定要改時的修正。`Signed:` 出現之前不寫任何 child；就算簽了，每一件都要等你的裁定。
`catalog/repos.yaml` 的 remote 和所有文件屬於 workspace 的工作，不在這道閘門內。

## 步驟 — 驗收，在 Azure host 上
Host `https://rea-api-dea9h4bbbvf9bpch.eastus2-01.azurewebsites.net`，Swagger 在
`/swagger`（`REA_UI@a024004 .env.development:6`）。指令在 `projects/rea_proto_data_creator` 下執行。

1. **先問 host 這個醫令已經有什麼，再決定要測哪一筆、起日填多少。** build 是純本機的，任何
   合法日期都會成功；起日要到 host 才會被檢查，`rule` 和 `workflow` 兩個 collection 各自獨立：
   新起日必須大於等於該醫令在那個 collection 裡所有版本的最大起日，否則 `Rule/Save` 回 500、
   `Rule/SaveWork` 只安靜地回 `success: false`（`REA_PROTO_BE@ba161ff Services/RuleService.cs:261-274`、
   `:424-437`、`:55-64`）。問法：`POST /api/v1/Payment/Detail/Get`，body
   `{"itemCodes":["01023C"],"pageNumber":1,"pageSize":10}`；`ruleStartDate` 與 `ruleDateHistory` 是
   `rule` 這邊的既有版本（`Services/PaymentService.cs:243-268`），`0001-01-01` 表示還沒有規則；
   `workflow` 那邊沒有 endpoint 可查。最保險是挑一個回 `0001-01-01` 的醫令。已有規則的醫令：
   起日相同會覆蓋現行版本、更晚會把它關在新起日前一天（`:283-298`、`:307-318`）。起日在未來
   不影響驗收：檢核永遠取訖日為 `MaxValue` 的 workflow（`Services/ValidationJobService.cs:572-578`）。
   日期定了才需要重跑 `node src/cli.js build --in data/in --out data/out --start-date
   <YYYY-MM-DD> --split`；`data/out/` 目前是 `2026-10-01` 的那一份。
2. **同一筆 body 貼兩次。** 貼第 1 步挑定的那一筆（`data/out/items/<醫令>.json`）。現在每一筆都
   帶 205 且 206，所以最單純的 body 是只有這兩個的（4 372 筆）；`01023C` 是 205且206且302。先
   `POST /api/v1/Rule/Save`，再把同一份貼到 `POST /api/v1/Rule/SaveWork`，兩支都要回
   `success: true`；只有 `SaveWork` 會寫出檢核讀得到的 `workflow`（`Controllers/RuleController.cs:26-44`）。
3. **對那個醫令跑一次 validation job。** `POST /api/v1/ValidationJob/Batch`，帶一個真實申報批次：
   `HospId`、`HospDataType`、`FeeYearMonth`、`ApplyType`、`ApplyDate`，`OrderCode` 填該醫令；輪詢
   `ValidationJob/Status` 到結束。必須是 `Completed`：`Failed` 是空的 rule 單元會有的樣子
   （declare-verify › What will surprise you）；沒接到 Oracle 的 host 也會 `Failed`，用訊息分辨。
   個別申報被 205/206 判不通過是正常的，那是第 7 步的問題，不是 payload 格式的問題。
4. **在 setup plan 補上 `Verified:`。** 第 1 到 3 步都成立之後才寫；這一行只有人能寫。

## 步驟 — 需要你裁定的事
5. **給 child 一個 remote。** `catalog/repos.yaml` 還是 `remote: none`，這台磁碟是唯一副本。
6. **202 的 `employmentType`。** 產出規則給了 `mainSetting`（LMT_ITEM）和 `doctorTypes`（ENAME 補
   0），但 generator 還要 `employmentType`（`Services/Rules/SpecialistRuleGenerator.cs:47-52`）：
   `01` 專任、`02` 不限專任，prototype 表單預設 `01`（`REA_PROTO@3fdf47c
   tests/mock/api/rulesSpecificSetting.json` 202 區塊）。這是實質選擇，程式不猜；裁定後 `r202.js`
   一個 commit，匯出檔裡 type 7 有 383 個醫令。
7. **205/206 對「所有項目」。** 採集規則讓 5 275 個醫令每一個都帶 205 和 206；產出規則把
   `FULL_TIME_DOC` / `FULL_TIME_EXEC` 對到 `mainSetting` 1/2，但 generator 不讀 `mainSetting`，
   只要 `doctorTypes` 02/01 加 `employmentType` 01 就對每個醫令編出 專任 檢核
   （`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`、`FullTimeDoctorExecutionRuleGenerator.cs:24-38`）；
   表單上 1/2 的意思是 無限制 / 除山地離島地區之外基層院所。請確認是否只有旗標為 `1` 的醫令
   （64 / 41 個）才該有 205 / 206。程式目前照規則寫。
8. **101–104 的群組碼。** 規則寫 001–004，匯出檔裡 type 13 只有 01–04（現行列與已結案列都是）；
   type 1 兩種寫法都有。程式以數值比對，101–104 各取到 185 / 145 / 199 / 8 個醫令。請確認。
9. **303–307、401。** 三份文件裡都還是空的；補上後各一個 commit。

不列為步驟，但長期成立：`main` 和 `rea` 由你的 shell 推送。

## 完成條件
setup plan 帶有 `Verified:`；child 有 remote 也推上去了；第 6 到 9 步各有裁定並落地，或由你裁定
不做，並把裁定寫進 repository doc。
