# rea — rea-proto-data-creator-acceptance

Writes: REA_PROTO_DATA_CREATOR (main)
Status: draft

## 目標
工具已經出貨，也能在真實匯出檔上重現 71 筆 302 body
（[rea-proto-data-creator-setup](rea-proto-data-creator-setup.md)、
`REA_PROTO_DATA_CREATOR@9b89624`），但還沒有任何一筆貼上伺服器，
而後續每一條 資料採集規則 都卡在只有你手上才有的對照。
這份 plan 就是那張清單：先驗收，讓 payload 真的跑出一個 `Completed` 的
validation job，再處理四件解除封鎖的事。
第 1 到 4 步是你自己的操作，不需要簽名，做完會落在 setup plan 的 `Verified:`；
第 5 到 8 步才是這份簽名蓋住的工作。

## Writes
`REA_PROTO_DATA_CREATOR (main)`：`rules/r301.js`、你對照出來的每一種
`MHCT_PAYLTYPE` limit type 各一個 rule 模組、以及 README 的名詞表。
`Signed:` 出現之前不寫任何 child；而且就算簽了，這些 commit 仍要等對照。
`catalog/repos.yaml` 的 remote 和所有文件屬於 workspace 的工作，不在這道閘門內。

## 步驟 — 驗收，在 Azure host 上
Host `https://rea-api-dea9h4bbbvf9bpch.eastus2-01.azurewebsites.net`，Swagger 在
`/swagger`（`REA_UI@a024004 .env.development:6`、`frontend.conf:14`）。
指令都在 `projects/rea_proto_data_creator` 下執行。

1. **挑一個 host 會接受的起日，跑 build。**
   `node src/cli.js build --in data/in --out data/out --start-date <YYYY-MM-DD> --split`。
   後端拒絕比該醫令現存版本更早的起日：`Rule/Save` 回 500，`Rule/SaveWork` 只安靜地
   回 `success: false`（`REA_PROTO_BE@ba161ff Services/RuleService.cs:261-274`、`:55-64`），
   所以要挑在 host 既有版本之後的日期。
2. **同一筆 body 貼兩次。** `data/out/items/01023C.json` 是最單純的一筆，0 到 2 歲、
   unit `Y`：先 `POST /api/v1/Rule/Save`，再把同一份貼到 `POST /api/v1/Rule/SaveWork`。
   兩支都要回 `success: true`。只有 `SaveWork` 會寫出檢核讀得到的 `workflow`
   （`Controllers/RuleController.cs:26-44`）。
3. **對那個醫令跑一次 validation job。** `POST /api/v1/ValidationJob/Batch`，帶一個真實
   申報批次：`HospId`、`HospDataType`、`FeeYearMonth`、`ApplyType`、`ApplyDate`，
   `OrderCode` 填該醫令；然後輪詢 `ValidationJob/Status` 到結束。它必須結束在
   `Completed`：`Failed` 正是空的 rule 單元會有的樣子（declare-verify › What will
   surprise you）。job 會去 Oracle 讀申報資料，所以沒接到 Oracle 的 host 同樣會
   `Failed` — 用 job 的訊息分辨是哪一種。
4. **在 setup plan 補上 `Verified:`。** 第 1 到 3 步都成立之後才寫。這一行只有人能寫，
   在它出現之前 `check` 會一直把那份 plan 列為等待中。

## 步驟 — 解除封鎖
5. **給 child 一個 remote。** `catalog/repos.yaml` 現在還是 `remote: none`，這台磁碟是
   這個專案唯一的副本。給出 URL，接上 `origin` 和推送就跟著做。
6. **301 的對照。** `MHCT_PAYLIMIT.LMT_SEX` 在 19 筆現行列上只有 `1` 和 `2`，正是 301
   適用性別吃的兩個值（`Services/Rules/SexRuleGenerator.cs:17-37`）。確認這個讀法，
   `rules/r301.js` 就能一個 commit 寫完，`description` 比照 302。
7. **`MHCT_PAYLTYPE` 的對照。** 它的 19 種 `LMT_TYPE_CODE` 是 limit type 的代號；每一種
   對應哪個 rule 模組、`LMT_ITEM` 要填進 `specificConfig` 的哪個欄位，磁碟上沒有任何
   資料推得出來。你對照出幾種就寫幾個 commit，不猜。
8. **README 的名詞用語。** 目前用的是 setup plan 的措辭並已註明，因為你原本的定義隨
   一次 session 的 context 遺失。換成你自己的寫法。

不列為步驟，但長期成立：`main` 和 `rea` 由你的 shell 推送，agent 的 shell 不能推。

## 完成條件
setup plan 帶有 `Verified:`；child 有 remote 也推上去了；`rules/r301.js` 已進版，而且它
產出的 body 通過同樣三個驗收呼叫；`MHCT_PAYLTYPE` 則是有了第一個 rule 模組，或由你裁定
沒有任何 rule 模組讀它，並把這個裁定寫進 repository doc。
