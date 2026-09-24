# rea — rea-proto-data-creator-acceptance

Writes: REA_PROTO_DATA_CREATOR (main)
Status: draft

## 目標
工具已經出貨：你給的文件已 ingest，其中定義的 15 個 rule 模組都寫進程式，兩份資料表檔跑出 12 個
檔案、12 140 筆 body（[setup](rea-proto-data-creator-setup.md)、`REA_PROTO_DATA_CREATOR@63005f8`）。
401 是第 16 個，但照規則產出的值後端讀不懂，被擋下，見第 5 步。本文件的「伺服器」一律指那台已
部署、`REA_UI` 連的站台 `https://rea-api-dea9h4bbbvf9bpch.eastus2-01.azurewebsites.net`，Swagger 在
`/swagger`（`REA_UI@a024004 .env.development:6`）。2026-09-23 你貼 `01023C` 上去，兩支 endpoint 都回
`success: true`：驗收的前兩件事已成立。剩下的是第 3 步（缺申報資料，不在你手上）與第 5 到 8 步。

## Writes
`REA_PROTO_DATA_CREATOR (main)`：401 依裁定修正、307 依裁定修正、每一種對照出來的 `MHCT_PAYLTYPE`
limit type 各一個 rule 模組、303–306 的 rule 模組。`Signed:` 之前不寫任何 child，簽了也仍要等對照。
文件與 `catalog/` 不在這道閘門內。

## 已成立 — 2026-09-23 你的驗收
1. **起日過關，兩支都收了。** 貼的是當時 `--start-date 2026-10-01` 的 `01023C`。`Rule/Save` 回
   「儲存成功！」、同一份貼 `Rule/SaveWork` 也回 `success: true`；`rule` 和 `workflow` 兩個
   collection 各自檢查起日（`REA_PROTO_BE@ba161ff Services/RuleService.cs:261-274`、`:424-437`），
   兩支都過。但這**還不代表** workflow 是活的：條件被產生器整條丟掉時 `SaveWork` 一樣回 `true`
   （declare-verify › What will surprise you），要證明它活著只有第 3 步。
2. ⚠ **起日改成 2026-01-01 之後，`01023C` 會被拒。** 它比伺服器上那筆 2026-10-01 早，`Rule/Save`
   會回 500、`Rule/SaveWork` 安靜地回 `success: false`。要再貼請換一個沒貼過的醫令：
   `POST /api/v1/Payment/Detail/Get`（body `{"itemCodes":["…"],"pageNumber":1,"pageSize":10}`）回
   `ruleStartDate` `0001-01-01` 的就是還沒有規則的（`Services/PaymentService.cs:243-268`）。同一個
   醫令、同一個起日再貼會整個取代先前的 `rules[]`（`:283-298`），所以一次只測一個 rule 模組。

## 步驟
3. **跑一次檢核工作——要有申報資料，所以不是你能收尾的。** `ValidationJob/Batch` 拿 `HospId`、
   `HospDataType`、`FeeYearMonth`、`ApplyType`、`ApplyDate` 去 Oracle 撈明細，再**只對撈到的那些
   醫令**建 workflow 跑（`Services/ValidationJobService.cs:336`、`:354-387`）：撈不到資料的 job 會
   以 `Completed`、0 筆結束，什麼也沒驗到；沒接上 Oracle 的站台則是 `Failed`。請跟後端／資料方要
   一組**真的撈得到明細**的批次五欄，以及那批裡有哪些醫令；然後對那個醫令貼兩支 endpoint、送 job，
   輪詢 `ValidationJob/Status` 到 `Completed`，並確認驗到的筆數不是 0。
4. **setup plan 補 `Verified:`。** 等第 3 步有結果才寫；只有人能寫。

## 對照
5. ⚠ **401 的 `mainSetting` 要不要補 0——只有這一題擋住 `r401.json`。** 產出規則說把 `IOPD_LMT`
   拆成單一位數（`"23"` → `["2","3"]`），但後端只認 `"01"` 門診、`"02"` 住診、`"03"` 限急診、
   `"04"` 牙醫門診，其餘一概編不出東西（`Services/Rules/OutpatientInpatientRuleGenerator.cs:20-85`），
   623 筆會全部變成空的 Or 單元、讓檢核工作失敗。程式照規則寫了，驗證器擋下，`r401.json` 沒有
   產出，其他 12 個檔案不受影響。匯出檔的值是 1（429）、2（180）、4（4）、23（8）、13（2），補 0
   後正好對上那四個選項。要補 0 的話回一句，一個 commit；規則文件也請同步。
6. **307 的三個資料疑問——`r307.json` 已產出，這些值照抄，不影響其他檔案。** 114 個醫令、546 個
   rangeGroups 都照規則填（`CNAME`/`ENAME` 起迄、`CNAME_1`/`ENAME_1` 月數、`prefixRange` 取較長者）。
   三件事值得你確認：90 列 `ENAME` 空白，目前當「無上限」（generator 會略過上界，
   `IcdCodeRuleGenerator.cs:171`），若本意是「同 `CNAME`」請說；11 列的碼帶小數點（`64288B`、
   `64289B`，例 `Q65.8`），申報欄位若存無點格式就永遠比不中；`P8211B` 有一列起 `I67841` 迄
   `67848`，迄值少了 `I`，這個範圍恆不成立。
7. **`MHCT_PAYLTYPE` 還沒對照的 13 種 limit type。** 已對照：13（101–104）、1（106）、3（201）、
   7（202）、14（204）、16 群組 1（307）。其餘現行列的長相（代號 列數/醫令數 `LMT_ITEM` 樣本…
   (種類數)；★ 另帶 `RATE`，● 另帶 `CNT`）：
   ★23 13827/4609 HO·HP·HQ…(3)｜★11 7381/231 FG·FK·FU…(37)｜★19 506/22 94201B·75020B…(23)｜
   ★12 444/211 C·D·B…(6)｜21 250/65 DE·EF·EK…(17)｜★15 243/46 1·2·3…(3)｜★17 151/46 1·2·3…(3)｜
   ●8 120/56 P8461C·P8462C…(56)｜20 107/65 A0900·A0204…(9)｜9 72/21 91014C·91020C…(62)｜
   ●18 29/18 27008B·27016B…(14)｜22 12/4 21+L1001C…(8)｜24 8/8 HP·HQ…(2)
   每一種請給：中文名稱、對應哪個規則代碼（101–401）或「不對應任何規則」、以及 `LMT_ITEM`（必要時
   加 `CNT`/`RATE`）要填進 `specificConfig` 的哪個欄位。你答幾種我就寫幾個 commit。
8. **303–306。** 兩份規則文件裡這四個 rule 模組還是空的；補上後各一個 commit。

## 暫緩——你 2026-09-23 說不急
- **child 的 remote。** `catalog/repos.yaml` 仍是 `remote: none`：這台磁碟是唯一的副本。
- **README 的名詞用語。** 現在用的是你 2026-09-23 定義檔的原文。
- **205/206 對「所有項目」，僅紀錄不處理（你的裁定）。** generator 不讀 `mainSetting`，只要
  `doctorTypes` 02/01 加 `employmentType` 01 就對每個醫令編出 專任 檢核
  （`FullTimeDoctorPrescriptionRuleGenerator.cs:24-38`、`FullTimeDoctorExecutionRuleGenerator.cs:24-38`）；
  旗標為 `1` 的醫令只有 64 / 41 個。
- `main` 和 `rea` 由你的 shell 推送。

## 完成條件
第 3 步有一次 `Completed` 且真的驗到那個醫令，setup plan 因此帶上 `Verified:`；401 與 307 的疑問有
裁定並落地；`MHCT_PAYLTYPE` 其餘 limit type 有了對照，或由你裁定不對應任何規則並寫進 repository doc。
