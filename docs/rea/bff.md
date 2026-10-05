# rea / bff

The BFF (Backend For Frontend) the NHIA regulation requires between `REA_UI` and every backend. It does
not exist yet. Owner's rulings, 2026-09-21: it is a separate rea project with its own repository (a
working name `ui_bff` under `projects/`), written in Node.js, and `REA_kernel` may not stand in for it. This module records
what the regulation demands, what the ui does today, and the target; the work is plan bff. The regulation is cited as `R` =
`docs/rea/sources/2026-09-21-nhia-his3-dev-standard-v2-full-p1-367.pdf.md@b3e81e38baa5`, the whole
document. The ui is cited at `REA_UI@5721638` (`develop`, the branch the owner ruled the review reads).

## What the regulation requires
- The front end is a UI layer: no core business logic, no direct backend call, every datum through the
  BFF; the aim is to hide backend APIs, loosen coupling and raise security (R L622–626). It is the first
  item of the mandatory list (R L915).
- The ui calls relative `/api/**` only. No IP, domain or real backend address in code, and none in an
  environment file (R L655–657).
- The BFF aggregates several APIs into the shape a page needs, filters and converts fields so nothing
  unneeded reaches the browser, unifies token and session checks, and spares the ui from integrating many
  backends (R L1123–1132). It also checks permissions and caches (R L1158–1162).
- The token lives in the BFF: 「Token 必須由 BFF 管控」 (R L913). The login chapter says why: a user with
  developer tools open cannot see it. The front side unpacks the Keycloak User Token with the
  `client_secret` and refuses a function the user's claims do not grant; the backend repeats the check
  (R L6366–6378, L6421–6430). Keycloak issues the token with roles and menu rights in its claims (R
  L6352–6354); Kong is the API gateway in front of backend APIs (R L6219–6220, L6232–6237).
- Allowed technology: Node.js with Express or NestJS, .NET 8 Web API, or Spring Boot (R L1163–1166). The
  regulation's own sample is Express (R L1167–1191).
- The stack is stated three times, and the statements disagree:
  - 肆 十一 (三) 2 (5), the front-end chapter: a BFF may be Node.js with Express or NestJS, .NET 8 Web
    API, or Spring Boot (R L1163–1166), and its sample is Node.js (R L1167–1191).
  - 伍 一 (二), the back-end chapter's 適用範圍: it governs every back-end project, the BFF named second
    (R L1243), and its languages are C#, ASP.NET Core and .NET 10 (R L1257–1260). Read literally, a BFF
    is a C# project, and the .NET version is 10, not 肆's 8.
  - 附件五 Node.js 開發規範: rules for a Node.js back end, on Node.js v22.18.0 and Express v4.21.2 (R
    L8134, L8349–8350).
  What follows for the owner's Node.js BFF: 肆 permits the choice and 附件五 governs how it is written,
  so language, layout, style and tests come from 附件五, versions from the whitelist. 伍's rules that
  are not about C# still bind, because 伍 names the BFF: minimal response DTOs (R L4424), forward
  compatibility (R L1412), the naming of the project. 伍's C#-specific rules — .NET 10, Dapper,
  FluentValidation — and 附件三's NLog-based logging (R L7513) cannot apply literally; their intent has
  to be met with Node.js tools (winston for logs, 附件五 says). The risk is a reviewer reading 伍's
  適用範圍 literally and flagging a Node.js BFF, so the architect should confirm the choice in writing.
- Container port: a convention, not a fixed rule. It sits in 玖 二 (一) 2 (4), inside the instructions
  for the **dotnet** Dockerfile (R L6464–6476): 「EXPOSE 8080 可依實際需求調整。在三代在 port 部分有規範」,
  then per environment `fw-web` 8000, `fw-api` 8001, `fw-batch` 8002, `fw-bff` 8003 (R L6477–6496; the
  UAT rows are misprinted `:sit`), and 「如果不依三代已設定 port 更改，那在 dotnet EXPOSE 的 port 要跟
  deployment.yaml … containerPort 一致即可」 (R L6497–6499). `fw-api: dev` turns up in the deployment template as a
  pod **label**, on a container with `containerPort: 8001` and `ASPNETCORE_URLS http://+:8001`
  (`R.p255`); what the label drives is not said, and a network policy keyed on it is the likely reading,
  which makes keeping 8003 for a pod labelled `fw-bff` the safe choice. The same template names the
  objects `<部門>-<code, lowercase>-api-pod`, `-api-container`, `-api-configmap` and runs non-root with
  all capabilities dropped. A Node.js BFF would take its Dockerfile from the
  template's `npm` folder, which the text describes as 「主要是用在前端 vue3」 (R L6505), so its Dockerfile
  has no stated port; 8003 is the consistent choice, and any port is compliant if `EXPOSE` and the
  yaml's `containerPort` agree.
- It is its own project because of container deployment: for a subsystem `IMSNC` the repository is
  `IMSNC-BFF` and the project `Med3BFF.IMSNC` (R L1203–1206). The Git chapter shows the same triple,
  `-Backend`, `-Frontend`, `-BFF`
  (R L395–397). The
  standard backend picture puts 「Gateway/BFF」 between the Vue 3 front end and the Web API
  (R L1597–1599).
- Deployment: the SPA to a CDN, the BFF to a Node.js or .NET server, backends on their own (R L1199–1202).

## What the ui does today
Two deployments must be kept apart (owner, 2026-09-22). The `Dockerfile`, `frontend.conf` and env files
in `REA_UI` were written for a deployment to a space **outside NHIA** and are described, as that, in
ui-deployment. NHIA's own deployment — the regulation's templates, ports and route paths — is a
different target that does not exist yet (› Container port; nhia-frontend-standard › Architecture).
What follows reads the repository as it stands, because the regulation's rules on a front-end project
bind its code and config wherever it is deployed; it is not a description of an NHIA deployment.
- The browser talks through the ui's own nginx, with nothing in between. Since `REA_UI@2a7a7c9`,
  `frontend.conf:7-14` proxies every `/api/` path, including Payment, to the kernel container
  `nhi-claimvalidator:8080`; the image is nginx serving `dist` with that config (`Dockerfile:9-12`).
- The earlier separate Payment host was stopped on 2026-09-30, replaced temporarily by the snapshot
  service, then removed from REA_UI by plan nhia-vm-ui-routing when the owner decided the kernel will
  implement Payment. This still lacks the BFF required by the target architecture.
- The code itself complies with the relative-path rule: `VITE_API_BASE_URL` is empty in production
  (`.env.production:2-3`), axios takes it as `baseURL` (`src/api/request.js:5-7`), and the four
  endpoints are relative: `/api/v1/RuleSchema`, `/api/v1/RuleSet` twice
  (`src/api/modules/rules/index.ts:129,166,231`), `/api/v1/Payment/Item/Get` and
  `/api/v1/Payment/Detail/Get` (`src/api/modules/payment/index.ts:19,29`).
- Backend addresses still sit in the repository, against R L655–657: the Docker service name in
  `frontend.conf:13` and the dev proxy target in `.env.development:4` (value not copied here).
- There is no token at all. The request interceptor's `Authorization` lines are commented out and speak
  of a 「主系統 token」 from an `authStore` (`src/api/interceptors.js:93-98`); 401 and 403 only raise an
  `ElMessage` (`interceptors.js:129,135`). Nothing in `src/` mentions Keycloak.
- Work a BFF would own is done in the browser: every response is camel-cased by `deepCamelizeKeys`
  (`src/api/request.js:2`, `caseTransform.js`), and the ui receives whole `RuleSet` rows of which it
  never reads five top-level fields (ruleset-api; plan ruleset-unread-fields).

## Target
Inferred from the rules above, not yet designed or agreed:
- Browser → nginx (static SPA, and `/api/` → the BFF only) → BFF → kernel, and BFF → Payment service.
  The ui repository then holds no backend address; the BFF holds them as its own configuration.
- Later, the BFF holds the shell's User Token server-side, checks the claim for each REA function and
  forwards the token to the kernel, which checks again (› Token and Keycloak: deferred).
- The BFF's first routes mirror the four endpoints one to one, so the ui changes nothing but its proxy.
  Shaping comes after: trim the `RuleSet` row to what the ui reads, move the case transform out of the
  browser, merge Payment lookups a dialog needs into one call.
- It follows the regulation's error codes and log format (nhia-regulation › The whole regulation) and
  carries unit tests.

## The subsystem code
Owner's questions, 2026-09-21: is a five-character code required, and does `REANC` come from the
database rules? It comes from the program-code rule. The regulation has two five-character rules that
share their first four characters and differ in the fifth:
- **Program and subsystem code** (伍 四 (一) 3, R L2717–2736): characters 1–3 the system, the 4th the
  work area (`N` NHI/Intra, `W` WWW/Internet, `V` VPN, `C` common), the 5th the *language* (`C` C#, `J`
  Java, `T` JavaScript); then 6–9 a sequence, the 10th the kind (`S` screen, `N` back end, `B` batch,
  `R` report, `U` schedule), 11–12 a number. The first five are what the regulation calls the
  「子系統名稱(5 碼)」. `REANC` is this rule read for REA: `REA` + `N` (an 署內 system) + `C` (its
  backend, the kernel, is C#).
- **Database object prefix** (壹拾壹 一 3, R L6931–6936): characters 1–3 the system, the 4th the work
  area, the 5th the *database kind* (`M` MongoDB, `O` Oracle, `R` Redis). For REA's Oracle tables that
  would read `REANO`. It names tables, not projects, and nothing in the ui or the BFF.

REA's three characters are in the regulation's system table, 「34 藥品特材管理 REA 醫令自動化審查子系統」
(R L261). The last two characters are still NHIA's to assign; `REANC` is the reading to confirm.

What the program-subsystem code reaches, checked against the whole document:
- **The ui's file, component and project names: no.** 伍's 適用範圍 is back-end projects only (R
  L1239–1260), so its `Med3Vue.IMSNC` and `IMSNC1001S01.vue` (R L2711–2713) do not bind a Vue project;
  肆's kebab-case does (nhia-regulation › The whole regulation — The five-character subsystem code).
- **The ui's deployment: yes.** `bash deploy_vue.sh <namespace> <部門名稱> <子系統名稱(5 碼)> <route
  path>`, example `med3hi0 hi0 ihkwc IHKE300`, generates the ui's `deployment.yaml`, `nginx.conf`,
  `route.yaml`, `service.yaml` under a folder of that name (R L6538–6550). So `reanc` would name the
  ui's Kubernetes artifacts once it is deployed the project's way.
- **The BFF's names: yes.** Its repository `<code>-BFF` and project `Med3BFF.<code>` are set in 肆
  itself (R L1203–1206), and its deployment runs through `deploy_api.sh` with the same parameter (R
  L6520–6522). As a back-end project it also logs the code as `BusCode` (R L7638).
- **Repository names: not by this rule.** The Git chapter names repositories after the major project
  and the lowercase three-letter system, and gives the 署內 Intranet one shared front-end repository:
  `NHI3-intra-LocalLibrary-hma`, `NHI3-intra-Backend-hma`, `NHI3-intra-Frontend` (R L412–420). Another
  project uses `INAE0000-Backend`, `-Frontend`, `-BFF` (R L394–397), and 肆 wants `<code>-BFF`. Three
  patterns in one document, and the Git chapter says the structure 「會依開發進度變更」 (R L392–393). The
  repositories live on NHIA's own GitHub, so NHIA names them; neither `REA_UI` nor the BFF's repository
  name can be settled from the text.

## What 附件五 asks of a Node.js BFF
The owner chose Node.js on 2026-09-21; 附件五 (pages 337–348) is its chapter.
- Layout: `src/` with `configs`, `constants`, `controllers` (req and res only, no business logic),
  `middlewares` (authentication, error handling), `routes`, `services`, `utils`, `validations` (zod),
  `tests`, and `app.js` building the express instance; `server.js` listens; `.env` with a
  `.env.template`, `.eslintrc.js`, `Dockerfile`, `jest.config.js`, `README.md` at the root (R L8138–8173).
  `models/` with sequelize is for a database, which a BFF has none of (R L8146).
- Code: `const` and `let`, never `var`; `===`; no globals; named functions; `try/catch` around every
  async path; a logger instead of `console.log`; JSDoc on functions (R L8235–8264). One Express error
  middleware; secrets in `.env` read through one config module; winston or pino for logs (R L8299–8306).
- API: RESTful paths, JSON, the status codes 200, 201, 204, 400, 401, 403, 404, 409, 500, paging by
  `page` and `limit` (R L8310–8341). A pass-through route keeps the kernel's paths and OData query, so
  this binds new BFF routes, not the mirrored ones.
- Environment: Node.js v22.18.0 LTS and Express v4.21.2 (R L8349–8350); other packages by application
  to the architect (R L8351–8355). Tests with jest and supertest (R L8362–8378).
- Against the whitelist, which the owner ruled decides versions
  (`2026-09-18-nhia-his3-library-whitelist.md.md@e97c76a4c25f`): `express <=5.1.0` (L4265),
  `http-proxy-middleware <=3.0.5` (L4462), `axios <=1.18.0` (L3876), `winston <=3.7.2` (L5525), `dotenv
  <=17.2.3` (L4177), `cors <=2.8.5` (L4073), `keycloak-js <=26.2.1` (L4633) are listed. `zod`, `jest`,
  `supertest`, `pino`, a session or cookie library and a JWT library are not. 附件五 names the first
  three itself, so either the architect admits them or the BFF validates by hand and tests with the
  listed `vitest <=4.0.5` (L5468).

## Token and Keycloak: deferred
The owner wants to discuss this before deciding (2026-09-21). It does not block the first BFF: the
pass-through routes and the ui's proxy change need no token. What is known, for that discussion:
- Keycloak is the project's identity server. A user logs in once at the shell's login page; Keycloak
  returns a signed JWT 「User Token」 whose claims hold the user's roles and menu rights; Kong, the API
  gateway, lets only requests with a valid token reach backend APIs (R L6219–6237, L6334–6354).
- REA has no login of its own: the ui is a subsystem the shell loads, so the token is the shell's.
- The regulation says the front side keeps that token in the BFF layer, unpacks it with the
  `client_secret`, and refuses a function the claims do not grant; the backend checks again (R
  L6366–6378).
- Not said anywhere in the ingested parts, and the questions to take to NHIA's architects: how the
  shell's token reaches a subsystem's BFF (a shared cookie, a header the shell's BFF adds, or a call
  to the shell); whether each subsystem BFF gets its own Keycloak client and secret; which claim names
  an REA function; whether a dev realm exists to test against.

## Open questions
- REA's five-character code, from NHIA.
- Whether the architect admits `zod`, `jest` and `supertest` for the BFF.
- The token questions above.
- When the kernel's planned Payment endpoints will be available for the UI's deployment gate.
