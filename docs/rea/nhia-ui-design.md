# rea / nhia-ui-design

附件二「三代醫療系統介面設計規範」of the NHIA development regulation V2.0: the screen-level rules the
front-end chapter defers to for style (nhia-frontend-standard › The whole regulation). Thirty-nine
numbered items, PDF pages 307–315, cited as `R` =
`docs/rea/sources/2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md@2bfefa3770d5` L7311–7500. The
pictures `R.p307` … `R.p315` beside it hold the 圖例, and items 32, 34, 35 and 39 exist only as pictures.
It rests on three 2025 meetings about the 署內 (INTRA) screen template (R L7312–7318). Owner's
ruling, 2026-09-21: in scope for `REA_UI`, after the BFF; the comparison is plan ui-design-conformance.
Whether `REA_UI` meets any item is not assessed here.

## Shared rules and the frame (items 1–8, R L7320–7357)
- 1–2. Button names are governed: they come from a data dictionary; a new name is applied for, with a
  screenshot, and approved by the 科長 before use.
- 3. At browser zoom up to 150 %, field labels still do not wrap.
- 4. The header shows the login line: 日期：[系統日期] | [單位] | [姓名] | 執行主機：[設備代號].
- 5. The header names the environment, such as UAT, in red `#FF0000`.
- 6. The menu shows long function names in full: user-resizable width, a horizontal scrollbar, or
  wrapping.
- 7. The function in use is marked in the menu by text colour or background.
- 8. Clicking a sub-function in the breadcrumb expands its tree in the menu and scrolls it to the top.
- Items 4–8 describe the header, menu and breadcrumb. They are the shell's, not `REA_UI`'s: the owner
  ruled on 2026-09-21 that the ui is a subsystem the shell loads (nhia-frontend-standard › Rulings).
  The ui's own `DefaultLayout.vue` frame is what that ruling makes redundant.

## Work area (items 9–22, R L7358–7395)
- 9. Background white `#FFFFFF`. 10. Three-column layout as the principle. 11. Labels do not wrap.
  12. One half-width space between label and field.
- 13. Optional label dark grey `#666666`. 14. Required label with a leading half-width `*`, label and
  `*` red `#FF0000`. 15. Field content black `#000000`.
- 16. Placeholder grey `#909090`, shown only while the field is empty.
- 17. A button the user may use but the work stage forbids is locked; one the user has no right to is
  not shown.
- 18. A button that opens a small window ends in three half-width dots: 【查詢...】.
- 19. 「分局」「作業組」「分區」 are all written 「分區」. 20. 「院所代號」 is written 「醫事機構代號」.
- 21. Years are ROC years. 22. Deleting asks first, 【確認】 deletes and 【取消】 cancels. The text says
  「alert 確認視窗」; the front-end chapter bans `alert()`, so this is the dialog of item 38.

## Buttons (items 23–25, R L7396–7420; R.p310, R.p311)
- All: rounded rectangle, 142 × 42 px by default.
- 23. Enabled: white `#FFFFFF`, border and text `#16858D`, text only, no icon.
- 24. Focused: fill and border `#16858D`, text `#FFFFFF` bold, no icon.
- 25. Disabled: fill `#E2E4E5`, border and text `#8C8E90`, a padlock icon left of the name.

## Date and time (items 26–31, R L7421–7446; R.p312)
- 26. Dates display `YYY/MM/DD`, zero-padded: `097/02/01`. 27. Times display `HH:MM:SS`, 24-hour.
- 28. A date field takes the picker or typing `YYYMMDD`, then shows `YYY/MM/DD`. The picture is an ROC
  calendar headed 「民國 114年 七月」.
- 29. A year field takes the picker or typing `YYY`. 30. A month field takes the picker or typing `MM`.
- 31. A time field has no clock picker; input `HH:MM`, 24-hour, with a placeholder.

## Inputs, selects, dialogs, paging (items 32–39, R L7447–7500; R.p312–R.p315)
- 32. Input: picture only, a plain rounded box.
- 33. The select arrow always points down, open or closed.
- 34. Radio, picture only: a filled teal circle, labels to the right, options in a row.
- 35. Checkbox, picture only: a teal filled box with a white tick.
- 36. Information or success dialog: 450 px wide, border `#1A875454`, text 22 px, full-width
  punctuation.
- 37. Error or failure dialog: the same size and text, border `#DC354569`, warning icon `#FF0000`.
- 38. Confirm dialog: as item 36, buttons per items 23–25 in the order 【確認】【取消】, and focus on the
  dialog itself, never on a button. The picture's buttons read 「確定」「取消」, against the text.
- 39. Paging, picture only: numbered page buttons with next and last, the current page filled teal, a
  「筆數/頁」 select offering 5, 10, 20, 30, 40, 50, and the text 「共57筆，現在是第1頁」.

## Against the front-end chapter
Items 9–17 repeat the chapter's colour, layout and permission rules (nhia-frontend-standard › Project
layout and conventions), and items 21, 26–30 its ROC date formats; both must hold together. The eight-
digit border colours of items 36–38 carry an alpha channel.
