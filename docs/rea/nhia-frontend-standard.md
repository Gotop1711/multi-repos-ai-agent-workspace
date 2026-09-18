# rea / nhia-frontend-standard

The NHIA rule the ui must be built to: chapter 肆「前端(Vue3)開發規範」 of 「第三代醫療資訊系統建置案」開發規範
V2.0, the 30 pages the owner excerpted (printed pages 21–50). Sources: `S` =
`docs/rea/sources/2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.md@d806bd3a4ab8` (PDFKit
text; its pages 24–27 are screenshots and came out empty) and `C` =
`docs/rea/sources/2026-09-18-nhia-his3-dev-standard-v2-federation-config-screens-p52-55.pdf.md@8ebd949dd61c`
(those four pages OCR'd — code with OCR noise; read `wue` as `vue`, `remates` as `remotes`). The document's
own date is not in the excerpt; the file's is the ingest date. Whether `REA_UI` complies is not assessed here.

## Architecture (S L15–64, L455–604)
- The front end is a UI layer only: no core business logic, no direct call to a backend API; every
  datum comes through a BFF (Backend For Frontend) (S L19–23).
- API calls use relative paths `/api/**` only; no IP, domain or real backend address in code or in an
  environment file (S L52–54). The ui calls `/api/...`, uses axios or fetch with one error handler, and
  keeps BFF results in Pinia (S L547–549).
- The BFF (Node.js/.NET; Express, NestJS, .NET 8 Web API or Spring Boot named) aggregates, reshapes, checks
  permissions and caches (S L555–563). It is its own repository: for a subsystem `IMSNC` the repository
  `IMSNC-BFF`, project `Med3BFF.IMSNC` (S L601–604). Deployment: the SPA to a CDN, the BFF to its server,
  the backend services on their own (S L596–599).
- Micro-frontends by Module Federation (the prose says Webpack 5, S L459; the screens use
  `@originjs/vite-plugin-federation`, C L33, L102): the shell provides layout and shell functions only,
  subsystems build and deploy on their own and may not depend on each other (S L60–62).
- The wiring in the screens (C): a subsystem exposes `./src/router/subSystemRouter.js` — a route array
  the shell mounts under its `subSystem` path — not its vue-router (C L11–25, L43, S L497–499); shell
  name `Nhivue.main` on port 5100, the sample subsystem `hmai4000` on 5102 with `filename
  remoteEntry.js` (C L39–40, L48, L108, L120); `vue`, `vue-router`, `pinia` shared as singletons (C L44,
  L115); the shell also exposes `./store` and `./V1/components`, `./V2/components` (C L111–113).

## Project layout and conventions (S L24–140)
- `public/` holds images and icons; `src/` holds `api/modules/<name>/{types,index}.js`, `layouts/`,
  `router/`, `utils/` (S L24–41). `auth/`, `components/`, `composables/`, `helpers/`, `layouts/`,
  `router/`, `utils/` are shared and changed only by application and architecture review (S L44–50, L55–57).
- Naming: files kebab-case, components PascalCase, variables and methods camelCase (S L72–74). A
  standard CRUD is split into `edit`, `form`, `list`, `table` (S L79–84). Reused components are
  wrapped once under `components/` (S L75–78), shared ones in `components/common` and `components/base`
  (S L108–111).
- Element Plus is the UI kit: its layout and grid (`el-container`, `el-row`, `el-col`), its standard
  components (`el-table`, `el-form`, `el-dialog`, `el-tabs`), its Dialog for pop-up messages; no hand-made
  modal, select or pagination (S L58, L86–87, L104–107). Styles in SCSS under `styles/`; customise by SCSS
  or CSS variables, theme config or class extension, never by editing Element Plus or `node_modules`;
  SFC styles `scoped` with namespaced classes; no global override of the kit (S L88–102, L138–141).
- Composition API and one-way data flow; no direct DOM access (`document.getElementById`, jQuery) (S
  L112–118).
- Fields: a required field carries `class="required"` and a red `*` (S L120–121). Colours: label
  `#666666` optional, `#FF0000` required; content `#000000`; hint `#909090`; page background `#FFFFFF` (S
  L123–130). Layout: three columns; a label never wraps; one half-width space between label and field (S
  L132–134). Permission: allowed but not operable → locked; not allowed → not shown (S L136–137).

## Validation (S L142–269)
- Front and back validate the same; length, special-character and RegEx checks; one validation module in
  the shell (`src/utils/validate.js`) that subsystems take through Federation; no page re-implements a rule
  (S L143–150).
- Dates are ROC years, `YYY/MM/DD` or `YYYMMDD`, year-month `YYY/MM` or `YYYMM`; format, existence, leap
  year and a system-date ceiling are checked; functions `validateDate`, `validateYearMonth`,
  `validateSysDate`, `validateSysMonth`, `isLeapYear`, `isValidRocDate` (S L152–174).
- Named functions also for email (`checkEmail`, typo and domain filters), password (`checkPassword`,
  6–15 alphanumerics), ID and residence numbers (`validateTaiwanId`, check digit), 統一編號 (`isValidGUI`,
  8 digits, the 7th-digit-7 rule), numbers (`isDigit`, `isDigitOnly`, `isInteger`, `isNumeric`,
  `checkNumber`, `checkTime`) and byte length (`getByteLength`, `validateByteLength`, `hasSpecialChar`,
  `isEnglish`; ASCII = 1, CJK = 2) (S L175–238).
- Field data types `C(n)` 中文, `S(n)` 特殊中文字, `A(n)` 英數, `P(n)` 純數字, `D` 日期, `ID` 身分證, `N(p,s)`
  數值, `M(p,s)` 金額, parsed by `parseDataType` and applied by a `vDataType` directive on mounted/updated,
  which focuses an invalid field; no directive written in a page, no page-level `keyup` validation (S
  L239–262).
- Error messages are centralised, shown with Element Plus components, never `alert()`; required, format,
  length and system-limit errors are distinguished (S L263–269).

## Tooling, tests, security (S L270–340)
- ESLint (`eslint-plugin-vue`) with Prettier; Pinia for state; Vue Router with dynamic `import()`;
  `v-memo`; import only the components used (S L271–286). Tests: the document's own unit-test chapter,
  not in this excerpt (S L303).
- Environment: Node.js v23.6.1, Vue 3 v3.5.13 + Vite 6.0.0, VS Code; no package installed without the
  architect (licensing); libraries from the whitelist (S L330–340).
- Security: no `eval()`, no `innerHTML` injection, every input validated, XSS and injection prevented,
  no sensitive data in LocalStorage, tokens held by the BFF (S L304–310).
- The mandatory list (S L311–328): BFF only; no hard-coded backend address; micro-frontends do not pollute
  each other; CSS scoped; front/back validation equal; no self-installed packages; the colour codes;
  permission control; unit tests; axios not AJAX; no jQuery; no page-level validation; the shared
  validate module; the `vDataType` directive.

## The shared UI frame (S L342–454)
Every screen is the shared frame (下載專區, 聯絡窗口, 網路地圖, 網路使用說明, 資安專區, a left menu, a footer)
around a subsystem work area; the excerpt shows the Internet, VPN and 醫事人員溝通平台 variants as mock-ups
(S L344–452). Where REA sits in this frame is not stated.
