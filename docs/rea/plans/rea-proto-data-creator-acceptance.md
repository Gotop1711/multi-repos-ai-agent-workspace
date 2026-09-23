# rea — rea-proto-data-creator-acceptance

Writes: REA_PROTO_DATA_CREATOR (main)
Status: draft

## 目標
工具已經出貨（[setup](rea-proto-data-creator-setup.md)、`REA_PROTO_DATA_CREATOR@9b89624`）。
本文件的「伺服器」一律指那台已部署、`REA_UI` 連的後端站台
`https://rea-api-dea9h4bbbvf9bpch.eastus2-01.azurewebsites.net`，Swagger 在 `/swagger`
（`REA_UI@a024004 .env.development:6`、`frontend.conf:14`）。2026-09-23 你把
`data/out/items/01023C.json` 貼上去，兩支 endpoint 都回 `success: true`：前兩步成立，第 3 步缺申報
資料、不在你手上。剩下的是把第 3 步交出去、簽名讓 301 落地，以及 `MHCT_PAYLTYPE` 的對照。

## Writes
`REA_PROTO_DATA_CREATOR (main)`：`rules/r301.js`、每一種對照出來的 `MHCT_PAYLTYPE` limit type 各一個
rule 模組。`Signed:` 之前不寫任何 child，簽了也仍要等對照。文件與 `catalog/` 不在這道閘門內。

## 已成立 — 2026-09-23 你的驗收（你在 session 裡的回報與截圖）
1. **起日過關。** 貼的是 `--start-date 2026-10-01` 那一份。`rule` 和 `workflow` 兩個 collection
   各自檢查新起日不得早於該醫令的現行版本，否則 `Rule/Save` 回 500、`Rule/SaveWork` 只安靜地回
   `success: false`（`REA_PROTO_BE@ba161ff Services/RuleService.cs:261-274`、`:424-437`、`:55-64`）。
   兩支都回 `true`，所以 01023C 在兩邊的起日都過了——原本要先用 `Payment/Detail/Get` 查的那件事，
   結果本身已經回答。
2. **兩支都收了。** `Rule/Save` 回「儲存成功！」，同一份貼 `Rule/SaveWork` 也回 `success: true`；
   只有後者會寫出檢核讀得到的 `workflow`（`Controllers/RuleController.cs:26-44`）。
   注意這**還不代表**那個 workflow 是活的：條件被產生器整條丟掉時 `SaveWork` 一樣回 `true`
   （declare-verify › What will surprise you）。要證明它活著只有第 3 步。

## 步驟
3. **跑一次檢核工作——這件事要有申報資料，所以不是你能收尾的。** `ValidationJob/Batch` 會拿
   `HospId`、`HospDataType`、`FeeYearMonth`、`ApplyType`、`ApplyDate` 去 Oracle 撈申報明細，再**只對
   撈到的那些醫令**建 workflow 跑（`Services/ValidationJobService.cs:336`、`:354-387`）：撈不到資料的
   job 會以 `Completed`、0 筆結束，什麼也沒驗到；沒接上 Oracle 的站台則是 `Failed`。
   要往下走，請跟後端／資料方要一組**真的撈得到明細**的批次五欄，以及那批裡有哪些醫令；然後對那個醫令
   重跑 `node src/cli.js build --in data/in --out data/out --start-date <YYYY-MM-DD> --split`、貼兩支
   endpoint、再送 job，輪詢 `ValidationJob/Status` 到 `Completed`。
4. **setup plan 補 `Verified:`。** 等第 3 步有結果才寫；只有人能寫，在它出現之前 `check` 會一直把那份
   plan 列為等待中。

## 對照
5. **301（適用性別）——對照齊了，只差 `Signed:`。** 你 2026-09-23 給的採集規則：`MHCT_PAYLIMIT` 現行列
   只要 `LMT_SEX` 有值就是一個項目，`1` = 限男性、`2` = 限女性。伺服器的 301 只看
   `specificConfig.mainSetting`，`["1"]`／`["2"]` 以外的值整條條件會被丟掉
   （`Services/Rules/SexRuleGenerator.cs:17-37`）；匯出檔這 19 個醫令的值也只有 1（12081C、27052C）
   和 2（其餘 17 個）。要寫的是 `rules/r301.js` 一個 commit：`description` 比照 302、scope 留空。
   這 19 個醫令沒有一個落在 302 的 71 個裡，所以 payload 會從 71 筆變 90 筆，每筆仍只帶一種規則。
6. **`MHCT_PAYLTYPE` 的 19 種 limit type——還沒有對照。** 這張表一列 = 一個醫令 + 一種 `LMT_TYPE_CODE` + 一個
   `LMT_ITEM`（現行列 28 517 筆），也就是「這個醫令在這種限制下的清單」。伺服器有 15 種規則種類，每種吃
   的都是一組代碼填在 `specificConfig` 的某個欄位（declare-verify › The fifteen rule kinds）。磁碟上沒有
   任何東西說哪個 `LMT_TYPE_CODE` 是哪一種——代碼對照表在你們那邊，我不猜。現行列的長相
   （代號 列數/醫令數 `LMT_ITEM` 樣本；★ 另帶 `RATE`，● 另帶 `CNT`）：
   ★23 13827/4609 HO·HP·HQ｜★11 7381/231 FG·FK·L5…(37 種)｜7 3668/383 A0300·A1000…(69)｜
   13 695/492 60·BZ·BK…(68)｜16 546/114 1·10·11…(29)｜★19 506/22 94201B·75020B…(23，醫令碼)｜
   ★12 444/211 A–F｜21 250/65 DE·EF·EK…(17)｜14 247/192 CH·05·AO…(53)｜★15 243/46 1·2·3｜
   1 210/194 AK·AB·AI…(29)｜★17 151/46 1·2·3｜●8 120/56 P8460C·P8461C…(56，醫令碼)｜
   20 107/65 A0900·A0204…(9)｜9 72/21 91014C·91020C…(62，醫令碼)｜●18 29/18 27008B·27016B…(14，醫令碼)｜
   22 12/4 L1001C·21+L1001C…(8)｜24 8/8 HP·HQ｜3 1/1 11
   每一種請給：中文名稱、對應哪個規則代碼（101–401）或「不對應任何規則」、以及 `LMT_ITEM`（必要時加
   `CNT`/`RATE`）要填進 `specificConfig` 的哪個欄位。你答幾種我就寫幾個 commit。

## 暫緩——你 2026-09-23 說不急
- **child 的 remote。** `catalog/repos.yaml` 仍是 `remote: none`：這台磁碟是唯一的副本。
- **README 的名詞用語。** 現在用的是 setup plan 的措辭，已註明。

## 完成條件
第 3 步有一次 `Completed` 且真的驗到那個醫令，setup plan 因此帶上 `Verified:`；`rules/r301.js` 已進版；
`MHCT_PAYLTYPE` 有了第一個 rule 模組，或由你裁定沒有任何 rule 模組讀它，並把這個裁定寫進 repository doc。
