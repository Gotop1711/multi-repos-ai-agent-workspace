# rea / nhia-regulation

「第三代醫療資訊系統建置案」開發規範 V2.0 as a whole: which of its chapters bind `REA_UI` and its BFF, where
its figures contradict its text, and how the workspace holds it. Cited as `R` =
`docs/rea/sources/2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md@b3e81e38baa5`; `R L<n>` is a
line of the text layer, `R.p<N>` the picture of PDF page N. Chapter 肆 itself is nhia-frontend-standard.

## The whole regulation: what a review of the ui needs
Its table of contents gives wrong page numbers: the owner confirms the original carries them, and 肆
prints on page 22 where the contents say 17 (R L615–618). Page numbers below are PDF pages, and line
numbers are lines of `R`. 肆 runs from page 30 to 58, 伍 starts on 59.

Needed, because 肆 points to them or the ui is written under them:
- **肆 前端(Vue3)開發規範** (p30–58): R L618–1209, module nhia-frontend-standard.
- **陸 二 前端單元測試** (p212–225): R L5525–5990. 肆 六 defers to it, and unit tests are on the mandatory list (R L906, L923). Its login test
  fixture carries a user and password; the owner confirms both are samples (2026-09-18).
- **壹拾參 二 三代醫療系統介面設計規範** (p307–315): R L7311–7504.
  This is the 附件二 that 肆 defers to for style (R L946).
- **壹拾參 六 JavaScript 開發規範** (p349–356): R L8426–8517. Its last rule: unit tests are written in Vue 3, not separately in JavaScript (L8515–8517).
- **壹拾參 四 錯誤及返回代碼規劃** (p333–336): `2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md` L8029–8131. These are the codes
  the ui shows, and 肆 三 (9) sets how (R L865–872).
- **壹拾參 三 日誌 Log 規範** (p316–332): R L7505–8028. Its 適用對象 is back-end developers,
  architects, SRE and log analysts (R L7509–7510), and it is written around NLog inside a WebAPI
  project. It binds the BFF, not the ui.
- **壹拾參 一 開發環境安裝** (p297–306): `2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md` L7243–7310. It holds the Vue 3 setup and
  the VS Code extension list that 肆 九 3 names and leaves empty (L7247, L7258; R L938).
- **伍 四 (一) 8 API 命名** (p114–118): R L2801–2864. RESTful methods, nouns not verbs, and one screen's front end against one backend controller
  (L2811–2814) — the shape a BFF route inherits.
- **伍 七 DTO / Validation / ViewModel** (p169–184):
  R L4293–4530. A response
  DTO returns only the fields the front end needs (L4424–4428), and back-end validation must mirror the
  front end's (L4502–4508). Both bind what the BFF returns.
- **The document itself** (p1–3): R L12–51. Document number `K1130690496-PDG-11506V2.0`, 資拓宏宇國際股份有限公司, 115/6/29 (2026-06-29),
  and the revision history from V0.1 to V2.0. This is what dates the version in force.
- **貳 三 版本管理(Git)** (p18–22): R L373–495.
- **壹 四 開發文件規範** (p12–17): `2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md` L203–353.
- **The 程式庫白名單** is a separate document, not part of the regulation. 肆 and 附件一 defer to it (R
  L941; `2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md` L7245), and so does 附件五
  Node.js on p345. The owner supplied it: `2026-09-18-nhia-his3-library-whitelist.md.md@e97c76a4c25f`,
  its own date 2026-06 (L3). The front end is a table (L14–2790) and a machine list of `<name> <=<max
  version>` lines (L2791–5560); the back end follows (L5563–6768), then a back-end blacklist (L6771–6782).
  Rows the ui review checks first: `vue <=3.5.32`, `vite <=7.1.12`, `vitest <=4.0.5`, `element-plus
  <=2.11.8`, `axios <=1.18.0`, `pinia <=3.0.4`, `vue-router <=4.6.3`, `typescript <=4.5.5`, `eslint
  <=9.39.1`, `@originjs/vite-plugin-federation <=1.4.1` (L5470, L5462, L5468, L4193, L3876, L4967, L5482,
  L5387, L4227, L3143). Two conflicts with 肆: the list admits `jquery <=3.7.1` (L4600), which 肆 bans
  (R L928); and it admits Vite up to 7.1.12, where 肆 names 6.0.0 (R L937).
- **The five-character subsystem code.** Owner's question, 2026-09-21: the rule sits in 伍, the C#
  chapter, so is the ui exempt? For the ui's own names, yes; for its deployment and for the BFF, no.
  Checked against the whole document on 2026-09-21.
  - 伍 states its 適用範圍: back-end projects only — WebAPI, BFF, batch, schedule, queue worker,
    microservices, integration and shared components, API gateway and so on, in C#, ASP.NET Core and
    .NET 10 (R L1239–1260). A Vue project is not in that list, so 伍 四 (一) 2 (3) 「前端專案命名規則」,
    which gives `Med3Vue.IMSNC` and `IMSNC1001S01.vue` (R L2711–2713), is an aside in a chapter that
    does not claim the front end.
  - 肆, which does govern the ui, says front and back naming is settled by the 命名原則 (R L674) and
    then requires kebab-case files such as `user-profile.vue` (R L675). Reading 伍 四 as binding would
    contradict 肆 outright. So 肆 governs the ui's file and component names unless NHIA rules
    otherwise, and `REA_UI` already follows it (`Payment.vue`, `RuleEditorDialog.vue`).
  - The code is still needed twice. The Vue project is deployed by `bash deploy_vue.sh <namespace>
    <部門名稱> <子系統名稱(5 碼)> <route path>`, the example being `med3hi0 hi0 ihkwc IHKE300`
    (R L6539–6545); and the BFF's project `Med3BFF.<code>` is named by 肆 itself (R L1203–1206). REA's
    three letters are in the system table (R L261); the program-code rule makes the five `REANC`, to be
    confirmed with NHIA (bff › The subsystem code). It blocks plan bff, not the review.
  - Repository names follow none of this. The Git chapter gives the 署內 Intranet one shared
    `NHI3-intra-Frontend` and per-system `NHI3-intra-Backend-<3 letters>` (R L412–420), another project
    `INAE0000-*` (R L394–397), and says the layout will change (R L392–393). NHIA names repositories on
    its own GitHub; `REA_UI`'s name is theirs to confirm.
- **壹拾參 五 Node.js 開發規範** (p337–348): R L8134–8423. It governs the BFF, not the ui (module bff › What 附件五 asks of a Node.js BFF).
- **The 命名原則 is 伍 五 命名規範** (p130–141): R L3275–3424 for 通用命名規範.
  It is written for C#. Its one front-end rule is that a required enum treats 0 as unselected and
  validates it (L3597).

Context, read for the ui's place in the system rather than checked line by line:
- **壹 二 整合與部署架構** (p11): `2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md` L195–202. **伍 二 後端整體架構治理** (p72–88):
  R L1566–2042. Both bear on whether `REA_kernel` may stand as the
  BFF that 肆 requires every datum to come through (R L622–626).
- **柒 Web API 管理** and **捌 三代登入機制** (p235–245): `2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md@b3e81e38baa5`. 柒 二
  身分認證 is L6221–6247, Keycloak L6262–6304, and 捌 L6333–6432. They cover the token that 肆 says the BFF holds
  (R L913).
- **玖 容器化與 CI/CD 之關連** (p246–260): R L6435–6577. It covers
  how the ui is built and deployed.

Not needed for the ui: 參 微服務; the rest of 伍 (C#); 陸 三; 壹拾 批次; 壹拾壹 資料庫; 壹拾貳 Java; and
壹拾參 七–十 (JSP, Ruby, Go, Python).

## Figures that contradict the text
Found only once the pictures were searchable. The document's own figures describe an earlier design:
- 圖 2 (`R.p9`) lists the front end as Vue3 + Vite, HTML/CSS/TypeScript and **BootstrapVue**, the back
  end as .NET Core 8. 圖 7「前後端分離架構圖」(`R.p29`) draws the Vue 3 SPA — Vue Router, Pinia/Vuex,
  Axios, Vite, 「UI 框架(Bootstrap5)」 — talking through APIM (Kong, Keycloak) **straight to the .NET
  Core 8 Web API, with no BFF**. The Composition API sample in 肆 itself says `'Hello BootstrapVue!'`
  (`R.p33`).
- 肆's text says the opposite on both points: every datum through a BFF (R L622–626, first on the
  mandatory list, R L915) and Element Plus as the kit (R L661, R L689, R L707). The revision history
  records that V2.0 was 「依 115 年架構重新整理」 (R L50), which reads as the text having moved on while
  the figures stayed. Inferred, not stated: the text governs, being the newer and the mandatory part.
  A reviewer holding 圖 7 could still argue a ui without a BFF is the drawn design, so the architect's
  confirmation asked for in plan bff should name this too.

## Coverage of the regulation
The whole document is ingested, so nothing has to be chosen: 367 pages, `sha256
cf804534659a22d781ce0768c75784d8ed3b6d961b4d2b82e68d034dc9f630d2` — byte for byte the owner's
`第三代醫療資訊系統建置案_開發規範_V2.0.pdf`, only renamed (verified 2026-09-21). The text layer is R
L1–8811. Every page with an embedded figure or a thin text layer keeps a picture, 115 in all, and the
OCR of 98 of them follows from R L8813 as an index.

Until 2026-09-21 the workspace held fifteen excerpts instead, cut by heading. That failed three ways,
which is why the owner had it replaced: a section's tail ran onto the next page and was lost
(前端單元測試 to p225, JavaScript to p356); rules binding the front end sat inside back-end chapters
(API naming p114–118, DTO and validation p169–184); and reading the whole thing turned up what no
keyword sweep had asked for, including REA's own system code (bff › The subsystem code), the Git chapter's
repository layout, the container-port convention, the deploy scripts and 伍's 適用範圍. The excerpts were pruned; `git log -- docs/rea/sources`
keeps them and their blobs.

What a picture says is evidence only as the picture. The OCR block made pictures searchable — it is
how the figures above and the deployment template were found — and it is wrong in exactly the places
that matter: it drops `_` from `MAX_RETRY_COUNT`, swaps quote kinds, and scatters a flow chart's labels.
Pictures in git are downscaled to 1600 px and 200 KiB; the original PDF under `docs/assets/` is the
last resort for small print, and it exists on the ingesting machine only.
