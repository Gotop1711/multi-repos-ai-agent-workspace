---
source: docs/assets/rea/rea-proto-data-creator/2026-09-23-data-creation-definitions.txt
sha256: aec381f24351474f9e18943e6873b62ca37796b2d53778c3d827f9688608deea
bytes: 1235
extractor: verbatim
status: ok
received: 後端驗測資料生產__定義.txt
---
- 醫令：REA_PROTO/REA_PROTO_BE 所要處理的資料項目們。
- rule模組：REA_PROTO/REA_PROTO_BE 中，用來規範每筆 [醫令] 的規則模組。
- 資料表檔：是 Oracle SQL developer 匯出的資料表 .csv 檔，是 [醫令] 為主要欄位的各種欄位資料組合。
- 資料採集規則：在 [資料表檔] 中，如何找出含有各 rule 模組檢驗需要的欄位的 [醫令] 資料項目的規則。資料的採集規則目前沒有紀錄在本機的檔案上，需要另外建立。
- rule模組欄位資料檔：[資料表檔] 經由 [資料採集規則] 整理後的，以 [醫令] 為主要欄位的各種欄位資料組合。
- 一筆rea資料：在 REA_PROTO 上，儲存單筆資料 (對各 [醫令] 的 [rule模組] 設定)。
- RuleSave_API：[一筆rea資料] 儲存 (POST request) 到 REA_PROTO_BE 使用的 api。
- RuleSave_Schema：正確的 [RuleSave_API] 的 Request body。請參考 `https://rea-api-dea9h4bbbvf9bpch.eastus2-01.azurewebsites.net/swagger/index.html`。
- RuleSave_payload_item：真正符合 [RuleSave_Schema] 的單筆資料物件。
- RuleSave_batch_payload：[RuleSave_payload_item] 的陣列集合。也是 我們的 DATA CREATION 的最後產出物。為 json 檔。
