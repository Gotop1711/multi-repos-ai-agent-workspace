# rea / nhia-frontend-standard

The NHIA rule the ui must be built to: chapter 肆「前端(Vue3)開發規範」 of 「第三代醫療資訊系統建置案」開發規範
V2.0, the 30 pages the owner excerpted (printed pages 21–50). Sources: `S` =
`docs/rea/sources/2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.md@cbb064044d23` (PDFKit
text; pictures of its pages 14–21 and 24–27 sit beside it as `….p<N>.jpg`) and `C` =
`docs/rea/sources/2026-09-18-nhia-his3-dev-standard-v2-federation-config-screens-p52-55.pdf.md@0d1860065c57`
(those four pages OCR'd, each with its picture — code with OCR noise; read `wue` as `vue`, `remates` as `remotes`). The document's
own date is not in the excerpt; the file's is the ingest date. Whether `REA_UI` complies is not assessed here.

## The whole regulation: what a review of the ui needs
The full document has 367 PDF pages. Its table of contents gives wrong page numbers: the owner confirms
the original carries them, and the excerpt shows 肆 printed on page 22 where the contents say 17 (S
L13–16). The pages below are PDF pages, and each part's name carries its range. 肆 is PDF pages 30–58:
the owner's excerpt is complete, since 伍 starts on page 59. Every part below is under `docs/rea/sources/`. Pictures of its image pages sit
beside each part, and they matter here: 附件二 defines widgets by picture, and 附件六's examples are
code screenshots with no text layer.

Needed, because 肆 points to them or the ui is written under them:
- **肆 前端(Vue3)開發規範**: `S`, this module.
- **陸 二 前端單元測試** (p212–224): `2026-09-18-nhia-his3-dev-standard-v2-frontend-unit-tests-p212-224.pdf.md@93f137f4ed5c`
  L18–457. 肆 六 defers to it, and unit tests are on the mandatory list (S L304, L321). Its login test
  fixture carries a user and password; the owner confirms both are samples (2026-09-18).
- **壹拾參 二 三代醫療系統介面設計規範** (p307–315): `2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.md@2f916184d583` L81–274.
  This is the 附件二 that 肆 defers to for style (S L344).
- **壹拾參 六 JavaScript 開發規範** (p349–355): `2026-09-18-nhia-his3-dev-standard-v2-javascript-p349-355.pdf.md@49bf8e320d1b` L12–95.
- **壹拾參 四 錯誤及返回代碼規劃** (p333–336): `2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.md` L799–901. These are the codes
  the ui shows, and 肆 三 (9) sets how (S L263–270).
- **壹拾參 三 日誌 Log 規範** (p316–332): `2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.md` L275–798.
- **壹拾參 一 開發環境安裝** (p297–306): `2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.md` L13–80. It holds the Vue 3 setup and
  the VS Code extension list that 肆 九 3 names and leaves empty (L17, L28; S L336).
- **貳 三 版本管理(Git)** (p18–22): `2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.md@94b087e18a61` L190–312.
- **壹 四 開發文件規範** (p12–17): `2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.md` L20–170.
- **The 程式庫白名單** is a separate document, not part of the regulation. 肆 and 附件一 defer to it (S
  L339; `2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.md` L15), and so does 附件五
  Node.js on p345. The owner supplied it: `2026-09-18-nhia-his3-library-whitelist.md.md@e97c76a4c25f`,
  its own date 2026-06 (L3). The front end is a table (L14–2790) and a machine list of `<name> <=<max
  version>` lines (L2791–5560); the back end follows (L5563–6768), then a back-end blacklist (L6771–6782).
  Rows the ui review checks first: `vue <=3.5.32`, `vite <=7.1.12`, `vitest <=4.0.5`, `element-plus
  <=2.11.8`, `axios <=1.18.0`, `pinia <=3.0.4`, `vue-router <=4.6.3`, `typescript <=4.5.5`, `eslint
  <=9.39.1`, `@originjs/vite-plugin-federation <=1.4.1` (L5470, L5462, L5468, L4193, L3876, L4967, L5482,
  L5387, L4227, L3143). Two conflicts with 肆: the list admits `jquery <=3.7.1` (L4600), which 肆 bans
  (S L326); and it admits Vite up to 7.1.12, where 肆 names 6.0.0 (S L335).
- **The five-character subsystem code** is required, by 伍 四 (一) 2–3 (p110–111) and 伍 五 (十二)
  (p143): `2026-09-21-nhia-his3-dev-standard-v2-project-naming-p110-113-p143.pdf.md@e826f7067352`
  L48–73, L144–149. It names the front-end project, every Vue page and the BFF (module bff › The
  subsystem code).
- **壹拾參 五 Node.js 開發規範** (p337–348): `2026-09-21-nhia-his3-dev-standard-v2-nodejs-p337-348.pdf.md@987fa90cdd98`
  L12–301. It governs the BFF, not the ui (module bff › What 附件五 asks of a Node.js BFF).
- **The 命名原則 is 伍 五 命名規範** (p130–141): `2026-09-18-nhia-his3-dev-standard-v2-naming-p130-141.pdf.md@6071d9d8bdc5` L35–184 for 通用命名規範.
  It is written for C#. Its one front-end rule is that a required enum treats 0 as unselected and
  validates it (L357).

Context, read for the ui's place in the system rather than checked line by line:
- **壹 二 整合與部署架構** (p11): `2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.md` L12–19. **伍 二 後端整體架構治理** (p72–88):
  `2026-09-18-nhia-his3-dev-standard-v2-backend-architecture-p72-88.pdf.md@ef02788f2448` L11–487. Both bear on whether `REA_kernel` may stand as the
  BFF that 肆 requires every datum to come through (S L20–24).
- **柒 Web API 管理** and **捌 三代登入機制** (p235–245): `2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.md@00fecbfe35c6`. 柒 二
  身分認證 is L16–42, Keycloak L57–99, and 捌 L128–227. They cover the token that 肆 says the BFF holds
  (S L311).
- **玖 容器化與 CI/CD 之關連** (p246–260): `2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.md@be9db46b3ab5` L12–154. It covers
  how the ui is built and deployed.

Not needed for the ui: 參 微服務; the rest of 伍 (C#); 陸 三; 壹拾 批次; 壹拾壹 資料庫; 壹拾貳 Java; and
壹拾參 七–十 (JSP, Ruby, Go, Python).

## Rulings for the review of the ui
The owner's, in session 2026-09-21. They fix how `REA_UI` is read against this regulation.
- **Subject.** The review reads `REA_UI` on `develop`, at the commit `./workspace.sh cite` prints when
  it starts (`REA_UI@5721638` on 2026-09-21).
- **jQuery is banned for the ui.** The whitelist's `jquery <=3.7.1` covers the whole project's
  libraries; the front-end chapter's ban (S L326) governs a front-end project.
- **Versions follow the whitelist.** It is kept up to date, so where it is newer than the chapter, as
  with Vite (whitelist `<=7.1.12`, chapter 6.0.0, S L335), the whitelist decides.
- **The BFF is a separate rea project**, in its own repository, and `REA_kernel` is not it. Not built
  yet: module bff, plan bff.
- **附件二 is in scope**, second in priority to the BFF: module nhia-ui-design, plan
  ui-design-conformance.
- **REA_UI is a subsystem loaded by the shell** (2026-09-21). The shell owns login, header, menu and
  breadcrumb; the ui exposes its routes to it by Module Federation (› Architecture). So the Federation
  rules are the ui's to meet, and 附件二 items 4–8 are the shell's. Today the ui runs stand-alone
  instead: its own layout and router (`REA_UI@5721638 src/router/index.js:5-12`,
  `src/layouts/DefaultLayout.vue`) behind its own nginx; the federation plugin is a dependency
  (`package.json:33`) that `vite.config.js` never loads; and `src/router/subSystemRouter.js`, the file
  the regulation has a subsystem expose, is there from the first commit (`f7a2f0f`), lists the Payment
  view only, and is imported nowhere.
- **The BFF is written in Node.js** (2026-09-21), which brings 附件五 into force for it (module bff).

## Architecture (S L16–65, L456–605)
- The front end is a UI layer only: no core business logic, no direct call to a backend API; every
  datum comes through a BFF (Backend For Frontend) (S L20–24).
- API calls use relative paths `/api/**` only; no IP, domain or real backend address in code or in an
  environment file (S L53–55). The ui calls `/api/...`, uses axios or fetch with one error handler, and
  keeps BFF results in Pinia (S L548–550).
- The BFF (Node.js/.NET; Express, NestJS, .NET 8 Web API or Spring Boot named) aggregates, reshapes, checks
  permissions and caches (S L556–564). It is its own repository: for a subsystem `IMSNC` the repository
  `IMSNC-BFF`, project `Med3BFF.IMSNC` (S L602–605). Deployment: the SPA to a CDN, the BFF to its server,
  the backend services on their own (S L597–600).
- Micro-frontends by Module Federation (the prose says Webpack 5, S L460; the screens use
  `@originjs/vite-plugin-federation`, C L34, L103): the shell provides layout and shell functions only,
  subsystems build and deploy on their own and may not depend on each other (S L61–63).
- The wiring in the screens (C): a subsystem exposes `./src/router/subSystemRouter.js` — a route array
  the shell mounts under its `subSystem` path — not its vue-router (C L12–26, L44, S L498–500); shell
  name `Nhivue.main` on port 5100, the sample subsystem `hmai4000` on 5102 with `filename
  remoteEntry.js` (C L40–41, L49, L109, L121); `vue`, `vue-router`, `pinia` shared as singletons (C L45,
  L116); the shell also exposes `./store` and `./V1/components`, `./V2/components` (C L112–114).

## Project layout and conventions (S L25–141)
- `public/` holds images and icons; `src/` holds `api/modules/<name>/{types,index}.js`, `layouts/`,
  `router/`, `utils/` (S L25–42). `auth/`, `components/`, `composables/`, `helpers/`, `layouts/`,
  `router/`, `utils/` are shared and changed only by application and architecture review (S L45–51, L56–58).
- Naming: files kebab-case, components PascalCase, variables and methods camelCase (S L73–75). A
  standard CRUD is split into `edit`, `form`, `list`, `table` (S L80–85). Reused components are
  wrapped once under `components/` (S L76–79), shared ones in `components/common` and `components/base`
  (S L109–112).
- Element Plus is the UI kit: its layout and grid (`el-container`, `el-row`, `el-col`), its standard
  components (`el-table`, `el-form`, `el-dialog`, `el-tabs`), its Dialog for pop-up messages; no hand-made
  modal, select or pagination (S L59, L87–88, L105–108). Styles in SCSS under `styles/`; customise by SCSS
  or CSS variables, theme config or class extension, never by editing Element Plus or `node_modules`;
  SFC styles `scoped` with namespaced classes; no global override of the kit (S L89–103, L139–142).
- Composition API and one-way data flow; no direct DOM access (`document.getElementById`, jQuery) (S
  L113–119).
- Fields: a required field carries `class="required"` and a red `*` (S L121–122). Colours: label
  `#666666` optional, `#FF0000` required; content `#000000`; hint `#909090`; page background `#FFFFFF` (S
  L124–131). Layout: three columns; a label never wraps; one half-width space between label and field (S
  L133–135). Permission: allowed but not operable → locked; not allowed → not shown (S L137–138).

## Validation (S L143–270)
- Front and back validate the same; length, special-character and RegEx checks; one validation module in
  the shell (`src/utils/validate.js`) that subsystems take through Federation; no page re-implements a rule
  (S L144–151).
- Dates are ROC years, `YYY/MM/DD` or `YYYMMDD`, year-month `YYY/MM` or `YYYMM`; format, existence, leap
  year and a system-date ceiling are checked; functions `validateDate`, `validateYearMonth`,
  `validateSysDate`, `validateSysMonth`, `isLeapYear`, `isValidRocDate` (S L153–175).
- Named functions also for email (`checkEmail`, typo and domain filters), password (`checkPassword`,
  6–15 alphanumerics), ID and residence numbers (`validateTaiwanId`, check digit), 統一編號 (`isValidGUI`,
  8 digits, the 7th-digit-7 rule), numbers (`isDigit`, `isDigitOnly`, `isInteger`, `isNumeric`,
  `checkNumber`, `checkTime`) and byte length (`getByteLength`, `validateByteLength`, `hasSpecialChar`,
  `isEnglish`; ASCII = 1, CJK = 2) (S L176–239).
- Field data types `C(n)` 中文, `S(n)` 特殊中文字, `A(n)` 英數, `P(n)` 純數字, `D` 日期, `ID` 身分證, `N(p,s)`
  數值, `M(p,s)` 金額, parsed by `parseDataType` and applied by a `vDataType` directive on mounted/updated,
  which focuses an invalid field; no directive written in a page, no page-level `keyup` validation (S
  L240–263).
- Error messages are centralised, shown with Element Plus components, never `alert()`; required, format,
  length and system-limit errors are distinguished (S L264–270).

## Tooling, tests, security (S L271–341)
- ESLint (`eslint-plugin-vue`) with Prettier; Pinia for state; Vue Router with dynamic `import()`;
  `v-memo`; import only the components used (S L272–287). Tests: the document's own unit-test chapter,
  not in this excerpt (S L304).
- Environment: Node.js v23.6.1, Vue 3 v3.5.13 + Vite 6.0.0, VS Code; no package installed without the
  architect (licensing); libraries from the whitelist (S L331–341).
- Security: no `eval()`, no `innerHTML` injection, every input validated, XSS and injection prevented,
  no sensitive data in LocalStorage, tokens held by the BFF (S L305–311).
- The mandatory list (S L312–329): BFF only; no hard-coded backend address; micro-frontends do not pollute
  each other; CSS scoped; front/back validation equal; no self-installed packages; the colour codes;
  permission control; unit tests; axios not AJAX; no jQuery; no page-level validation; the shared
  validate module; the `vDataType` directive.

## The shared UI frame (S L343–455)
Every screen is the shared frame (下載專區, 聯絡窗口, 網路地圖, 網路使用說明, 資安專區, a left menu, a footer)
around a subsystem work area; the excerpt shows the Internet, VPN and 醫事人員溝通平台 variants as mock-ups
(S L345–453). Where REA sits in this frame is not stated.
