# rea / nhia-frontend-standard

The NHIA rule the ui must be built to: 「第三代醫療資訊系統建置案」開發規範 V2.0, all 367 pages, ingested
whole as `R` = `docs/rea/sources/2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md@b3e81e38baa5` (PDFKit text; `R L<n>`
cites a line, and a page marker `<!-- page N -->` carries the PDF page). Pictures of its 115 pages with
figures sit beside it as `….p<N>.jpg`, named by PDF page and cited `R.p<N>`. From R L8813 on, the file
holds a machine reading (OCR) of those pictures: a search index with misreadings, never cited — a fact
that only a picture states is cited as the picture, after looking at it. Chapter 肆「前端(Vue3)開發規範」 (pages 30–58) is the ui's
own chapter and this module's subject, with the owner's rulings on how the ui is read against it. What
else in the document binds the ui, the figures that contradict the text, and how the source was taken
are in nhia-regulation. Whether `REA_UI` complies is not assessed here.

## Rulings for the review of the ui
The owner's, in session 2026-09-21. They fix how `REA_UI` is read against this regulation.
- **Subject.** The review reads `REA_UI` on `develop`, at the commit `./workspace.sh cite` prints when
  it starts (`REA_UI@5721638` on 2026-09-21).
- **jQuery is banned for the ui.** The whitelist's `jquery <=3.7.1` covers the whole project's
  libraries; the front-end chapter's ban (R L928) governs a front-end project.
- **Versions follow the whitelist.** It is kept up to date, so where it is newer than the chapter, as
  with Vite (whitelist `<=7.1.12`, chapter 6.0.0, R L937), the whitelist decides.
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
  view only, and is imported nowhere. Converting it is plan federation-remote.
- **The BFF is written in Node.js** (2026-09-21), which brings 附件五 into force for it (module bff).

## Architecture (R L618–667, L1058–1207)
- The front end is a UI layer only: no core business logic, no direct call to a backend API; every
  datum comes through a BFF (Backend For Frontend) (R L622–626).
- API calls use relative paths `/api/**` only; no IP, domain or real backend address in code or in an
  environment file (R L655–657). The ui calls `/api/...`, uses axios or fetch with one error handler, and
  keeps BFF results in Pinia (R L1150–1152).
- The BFF (Node.js/.NET; Express, NestJS, .NET 8 Web API or Spring Boot named) aggregates, reshapes, checks
  permissions and caches (R L1158–1166). It is its own repository: for a subsystem `IMSNC` the repository
  `IMSNC-BFF`, project `Med3BFF.IMSNC` (R L1204–1207). Deployment: the SPA to a CDN, the BFF to its server,
  the backend services on their own (R L1199–1202).
- Micro-frontends by Module Federation (the prose says Webpack 5, R L1062; the screens use
  `@originjs/vite-plugin-federation`): the shell provides layout and shell functions only, subsystems
  build and deploy on their own and may not depend on each other (R L663–665).
- The wiring is shown only as screenshots of code, pages 52–55, with no text layer; read from the
  pictures. A subsystem's `subSystemRouter.js` exports a route array `SubSystemRouter` (`R.p52`). Its
  `vite.config` names it (`hmai4000`), sets `filename: "remoteEntry.js"`, lists the shell as remote
  `main` at `http://localhost:5100/dist/assets/remoteEntry.js`, exposes `"./hmaSystem":
  "./src/router/subSystemRouter.js"`, shares `["vue", "vue-router", "pinia"]`, and serves on 5102
  (`R.p53`). The shell imports `SubSystemRouter` and mounts it as the children of a `subSystem` path in
  its own router (`R.p54`, and R L1100–1102). The shell's `vite.config` is named `NhiVue.main`, has the
  remote `subSystem` at `http://localhost:5102/…/remoteEntry.js`, exposes `./store`, `./v1/components`
  and `./v2/components`, shares the three libraries as `{ singleton: true }`, and serves on 5100
  (`R.p55`). An earlier draft of this paragraph, written from OCR, had `Nhivue.main` and
  `./V1/components`: the misreadings the evidence rule exists for.
- A deployed Vue app is served by nginx on 8000 under its route path, not at `/`: the template has
  `listen 8000`, `location /IHKE3000/ { alias /usr/share/nginx/html/; try_files … /index.html; }` and an
  `HTTPRoute` with `PathPrefix /IHKE3000/` to the service `hi0-ihkwc-web-svc:8000` (`R.p258`; the
  script is R L6539–6545). Kubernetes objects are named `<部門>-<code, lowercase>-web-…`. `REA_UI` builds
  with `base: '/'` today (`REA_UI@5721638 vite.config.js:25`), which a path-prefixed deployment has to
  change. The template proxies no `/api`: the API is another route, as the BFF rule expects.

## Project layout and conventions (R L627–743)
- `public/` holds images and icons; `src/` holds `api/modules/<name>/{types,index}.js`, `layouts/`,
  `router/`, `utils/` (R L627–644). `auth/`, `components/`, `composables/`, `helpers/`, `layouts/`,
  `router/`, `utils/` are shared and changed only by application and architecture review (R L647–653, L658–660).
- Naming: files kebab-case, components PascalCase, variables and methods camelCase (R L675–677). A
  standard CRUD is split into `edit`, `form`, `list`, `table` (R L682–687). Reused components are
  wrapped once under `components/` (R L678–681), shared ones in `components/common` and `components/base`
  (R L711–714).
- Element Plus is the UI kit: its layout and grid (`el-container`, `el-row`, `el-col`), its standard
  components (`el-table`, `el-form`, `el-dialog`, `el-tabs`), its Dialog for pop-up messages; no hand-made
  modal, select or pagination (R L661, L689–690, L707–710). Styles in SCSS under `styles/`; customise by SCSS
  or CSS variables, theme config or class extension, never by editing Element Plus or `node_modules`;
  SFC styles `scoped` with namespaced classes; no global override of the kit (R L691–705, L741–744).
- Composition API and one-way data flow; no direct DOM access (`document.getElementById`, jQuery) (R
  L715–721).
- Fields: a required field carries `class="required"` and a red `*` (R L723–724). Colours: label
  `#666666` optional, `#FF0000` required; content `#000000`; hint `#909090`; page background `#FFFFFF` (R
  L726–733). Layout: three columns; a label never wraps; one half-width space between label and field (R
  L735–737). Permission: allowed but not operable → locked; not allowed → not shown (R L739–740).

## Validation (R L745–872)
- Front and back validate the same; length, special-character and RegEx checks; one validation module in
  the shell (`src/utils/validate.js`) that subsystems take through Federation; no page re-implements a rule
  (R L746–753).
- Dates are ROC years, `YYY/MM/DD` or `YYYMMDD`, year-month `YYY/MM` or `YYYMM`; format, existence, leap
  year and a system-date ceiling are checked; functions `validateDate`, `validateYearMonth`,
  `validateSysDate`, `validateSysMonth`, `isLeapYear`, `isValidRocDate` (R L755–777).
- Named functions also for email (`checkEmail`, typo and domain filters), password (`checkPassword`,
  6–15 alphanumerics), ID and residence numbers (`validateTaiwanId`, check digit), 統一編號 (`isValidGUI`,
  8 digits, the 7th-digit-7 rule), numbers (`isDigit`, `isDigitOnly`, `isInteger`, `isNumeric`,
  `checkNumber`, `checkTime`) and byte length (`getByteLength`, `validateByteLength`, `hasSpecialChar`,
  `isEnglish`; ASCII = 1, CJK = 2) (R L778–841).
- Field data types `C(n)` 中文, `S(n)` 特殊中文字, `A(n)` 英數, `P(n)` 純數字, `D` 日期, `ID` 身分證, `N(p,s)`
  數值, `M(p,s)` 金額, parsed by `parseDataType` and applied by a `vDataType` directive on mounted/updated,
  which focuses an invalid field; no directive written in a page, no page-level `keyup` validation (R
  L842–865).
- Error messages are centralised, shown with Element Plus components, never `alert()`; required, format,
  length and system-limit errors are distinguished (R L866–872).

## Tooling, tests, security (R L873–943)
- ESLint (`eslint-plugin-vue`) with Prettier; Pinia for state; Vue Router with dynamic `import()`;
  `v-memo`; import only the components used (R L874–889). Tests: the document's own unit-test chapter,
  not in this excerpt (R L906).
- Environment: Node.js v23.6.1, Vue 3 v3.5.13 + Vite 6.0.0, VS Code; no package installed without the
  architect (licensing); libraries from the whitelist (R L933–943).
- Security: no `eval()`, no `innerHTML` injection, every input validated, XSS and injection prevented,
  no sensitive data in LocalStorage, tokens held by the BFF (R L907–913).
- The mandatory list (R L914–931): BFF only; no hard-coded backend address; micro-frontends do not pollute
  each other; CSS scoped; front/back validation equal; no self-installed packages; the colour codes;
  permission control; unit tests; axios not AJAX; no jQuery; no page-level validation; the shared
  validate module; the `vDataType` directive.

## The shared UI frame (R L945–1057)
Every screen is the shared frame (下載專區, 聯絡窗口, 網路地圖, 網路使用說明, 資安專區, a left menu, a footer)
around a subsystem work area; the excerpt shows the Internet, VPN and 醫事人員溝通平台 variants as mock-ups
(R L947–1055). Where REA sits in this frame is not stated.
