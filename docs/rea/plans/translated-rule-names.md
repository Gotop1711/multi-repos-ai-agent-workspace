# rea — translated-rule-names：群組名稱造成的規則名稱後綴，kernel 自己的結果解析器不接受

Status: draft

## 目標（Goal）
**一句話：** kernel 的三條規則彼此矛盾——leaf 必須有名稱 → 翻譯器因此一律在規則名稱加上後綴 → 結果解析器卻只認得沒有後綴的名稱。今天沒有東西壞掉，但規則執行一接上就會失敗。這是 kernel 端的問題，要由 kernel 擁有者決定怎麼修。

在 `REA_kernel@458e663` 看到的三件事（2026-09-17 回答「kernel 會不會儲存群組名稱？」時發現）：
1. **名稱必填。** 每個 leaf 都必須有非空白的 `Name`（`Validation/StructureValidator.cs:70-73`）。
2. **所以翻譯器一律加後綴。** 根規則成為 `Rule_<code>_<name>`，子規則成為 `Rule_<code>_Skip_<name>` / `Rule_<code>_Main_<name>`，更下層的子規則也遞迴加上後綴（`Translator/V1.0/RuleSetTranslator.cs:58-115`）。
3. **解析器只收沒有後綴的名稱。** `RuleResultAttributionParser.Parse` 要求根規則名稱**恰好**是 `Rule_<code>`，否則拋出「預期結果節點為 …，實際為 …」；並直接找名為 `Rule_<code>_Skip` / `_Main` / `_Guard` 的子規則（`Translator/RuleResultAttributionParser.cs:22-27,34-47,54`）。因此根規則和子規則都永遠對不上。兩邊放後綴的位置也不同（翻譯器是 `Rule_201_Skip_群組1`，解析器預期的形式是 `Rule_201_群組1_Skip`），照現在的寫法，沒有任何一種命名能同時滿足兩者。

**為什麼今天不會壞：**
- `src` 從未建立 `Workflow`，也從未執行規則引擎；只有 `test/` 會執行（`RuleSetTranslatorClaimDepartmentTests.cs:64-79`）。
- `TranslatedRules` 只寫入、從未被讀取（`Implementation/V1/RuleSetSL.cs:119-129`）。
- 翻譯器的測試傳入的 `RuleNode` 都沒有 `Name`，所以加後綴的路徑從未被測到。

## 寫入範圍（Writes）
無。`REA_kernel` 在此工作區是唯讀的——本計畫是**向 kernel 擁有者提出的請求**，不需要簽署。選擇權在他們：
- 讓 `Parse` 接收群組名稱（或後綴）作為參數，並據此組出預期的規則名稱；或
- 改用翻譯器已經寫入、但目前沒人讀取的 `Properties["Name"]` 與 `SuccessEvent` 來對應結果，不再解析規則名稱字串；或
- 拿掉後綴，只由 `Properties["Name"]` 攜帶群組名稱。

無論選哪一種，都應同時補上一個測試：以帶有名稱的 leaf 經翻譯器翻譯後，再通過 `Parse` 驗證——這個測試本來就能抓到此問題。

## 步驟（Steps）
1. 把上述三件事整理成一個問題交給 kernel 擁有者：當每個 leaf 都有名稱之後，結果對應要以哪個名稱為準？
2. 將他們的回覆寫進 rea-kernel；若回覆會改變 `REA_UI` 送出的內容，另開一份新計畫（本計畫不寫入任何 repo）。

## 完成條件（Done when）
kernel 擁有者已做出決定、決定已寫進 rea-kernel；若他們選擇修正，已有一個翻譯器測試讓帶名稱的 leaf 完整通過 `Parse`。若他們打算在規則執行上線前重寫結果對應、此衝突不會進入運行中的系統，則以 `Abandoned: <YYYY-MM-DD> — decided: <決定>` 結案。
