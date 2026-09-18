# rea / nhia-frontend-standard

The NHIA rule the ui must be built to: chapter 肆「前端(Vue3)開發規範」 of 「第三代醫療資訊系統建置案」開發規範
V2.0, the 30 pages the owner excerpted (printed pages 21–50). Sources: `S` =
`docs/rea/sources/2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.md@cbb064044d23` (PDFKit
text; pictures of its pages 14–21 and 24–27 sit beside it as `….p<N>.jpg`) and `C` =
`docs/rea/sources/2026-09-18-nhia-his3-dev-standard-v2-federation-config-screens-p52-55.pdf.md@0d1860065c57`
(those four pages OCR'd, each with its picture — code with OCR noise; read `wue` as `vue`, `remates` as `remotes`). The document's
own date is not in the excerpt; the file's is the ingest date. Whether `REA_UI` complies is not assessed here.

## The whole regulation: what a review of the ui needs
Chapters and pages below are from the owner's table-of-contents screenshots (2026-09-18, not
ingested). Its page numbers are stale: 肆 is listed at 17 and 十一 at 40, but the excerpt prints them
on 22 and 48, and the drift grows from 5 to 8 inside the chapter (S L13–16, L520–543). So only headings,
not page numbers, locate a part. Whether 肆 ends on printed page 50, where the excerpt stops, is unconfirmed.

Needed, because 肆 points to them or the ui is written under them:
- **肆 前端(Vue3)開發規範** (listed p17–43): ingested; this module.
- **陸 二 前端單元測試** (p164–177): 肆 六 defers to it, and unit tests are on the mandatory list (S L304, L321).
- **壹拾參 二 三代醫療系統介面設計規範** (p246–253): 附件二, the front-end style 肆 defers to (S L344).
- **壹拾參 六 JavaScript 開發規範** (p281–287): the ui's code is JavaScript and TypeScript.
- **壹拾參 四 錯誤及返回代碼規劃** (p268–272): the codes the ui shows; 肆 三 (9) sets how (S L263–270).
- **壹拾參 三 日誌 Log 規範** (p253–268): whether front-end logging is ruled.
- **貳 三 版本管理(Git)** (p7–12): branches and commits, against the ui's `debug-ui` flow.
- **壹 四 開發文件規範** (p3–7): the documents a repository must carry.
- **Location unknown**: the 程式庫白名單 that 肆 requires libraries to come from (S L339), and the
  命名原則 that 肆 says unifies front and back naming (S L72). 壹 三 本機開發環境, 壹拾參 一 開發環境安裝
  and 伍 五 命名規範 are candidates by title only.

Context, read for the ui's place in the system rather than checked line by line:
- **壹 二 整合與部署架構** (p2), **伍 二 後端整體架構治理** (p53–67): whether `REA_kernel` may stand as
  the BFF 肆 requires every datum to come through (S L20–24).
- **柒 二 身分認證及授權管理** (p185), **捌 三代登入機制** (p189–194): the token 肆 says the BFF holds (S L311).
- **玖 容器化與 CI/CD 之關連** (p194–209): how the ui is built and deployed.

Not needed for the ui: 參 微服務, the rest of 伍 (C#), 陸 三, the rest of 柒, 壹拾 批次, 壹拾壹 資料庫,
壹拾貳 Java, and 壹拾參 一, 五, 七–十 (環境安裝, Node.js, JSP, Ruby, Go, Python) unless one holds the whitelist.

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
