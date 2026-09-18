---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf
sha256: fc922c1b9b1dbb5b389cdf2dd61ae69ad39e864e156983c864ba8882cff974b1
bytes: 683658
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p1.jpg 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p2.jpg 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p3.jpg 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p4.jpg 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p5.jpg 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p6.jpg 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p7.jpg
---
<!-- page 1 · picture: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p1.jpg -->
「第三代醫療資訊系統建置案」開發規範
六、JavaScript 開發規範
(一) 代碼格式化
1、縮進
(1) 使用 2 個空格進行縮進，避免使用 tab
(2) 保持一致的縮進風格
2、分號使用
每個語句結束後必須使用分號
3、引號使用
(1) 字符串統一使用單引號，除非字符串內包含單引號
(2) 模板字符串使用反引號
341
<!-- page 2 · picture: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p2.jpg -->
「第三代醫療資訊系統建置案」開發規範
(二) 變數聲明
1、使用 const 和 let
(1) 優先使用 const，只有在需要重新賦值時使用 let
(2) 避免使用 var
2、變數命名
(1) 使用 camelCase 命名法
(2) 變數名要具有描述性
(3) 常量使用 UPPER_SNAKE_CASE
(三) 函數定義
1、函數命名
342
<!-- page 3 · picture: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p3.jpg -->
「第三代醫療資訊系統建置案」開發規範
(1) 使用 camelCase
(2) 函數名應該是動詞或動詞短語
(3) 返回布爾值的函數使用 is/has/can 等前綴
2、箭頭函數 vs 普通函數
(1) 簡短的回調函數使用箭頭函數
(2) 需要 this 綁定時使用普通函數
(3) 函數聲明優於函數表達式
(四) 對象和數組
1、對象字面量
(1) 使用簡寫語法
(2) 保持一致的屬性排列
343
<!-- page 4 · picture: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p4.jpg -->
「第三代醫療資訊系統建置案」開發規範
2、解構賦值
適當使用解構賦值提高代碼可讀性
(五) 錯誤處理
1、使用 try-catch
(1) 對可能出錯的代碼使用 try-catch
(2) 提供有意義的錯誤信息
344
<!-- page 5 · picture: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p5.jpg -->
「第三代醫療資訊系統建置案」開發規範
(六) 非同步程式設計
1、Promise 和 async/await
(1) 優先使用 async/await 而不是 Promise 鏈
(2) 正確處理非同步錯誤
(七) 註解和文件說明
1、JSDoc 註解
345
<!-- page 6 · picture: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p6.jpg -->
「第三代醫療資訊系統建置案」開發規範
(1) 為公共函數添加 JSDoc 註釋
(2) 描述參數類型和返回值
2、行內註釋
(1) 解釋複雜的邏輯
(2) 避免顯而易見的註釋
(八) 效能優化
1、避免全域變數
(1) 使用模塊化組織代碼
(2) 避免污染全域命名空間
346
<!-- page 7 · picture: 2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.p7.jpg -->
「第三代醫療資訊系統建置案」開發規範
(九) 程式碼結構
1、模組化
(1) 使用 ES6 模組化語法
(2) 合理組織導入和導出
(十) 安全性
2、文件結構
src/
├── components/
├── services/
├── utils/
├── constants/
└── types/
1、避免常見安全問題
347
