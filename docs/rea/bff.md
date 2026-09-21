# rea / bff

The BFF (Backend For Frontend) the NHIA regulation requires between `REA_UI` and every backend. It does
not exist yet. Owner's rulings, 2026-09-21: it is a separate rea project with its own repository (a
working name `ui_bff` under `projects/`), written in Node.js, and `REA_kernel` may not stand in for it. This module records
what the regulation demands, what the ui does today, and the target; the work is plan bff. Regulation
sources are under `docs/rea/sources/`: `S` =
`2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.md@cbb064044d23`, `A` =
`2026-09-18-nhia-his3-dev-standard-v2-apim-login-p235-245.pdf.md@00fecbfe35c6`. The ui is cited at
`REA_UI@5721638` (`develop`, the branch the owner ruled the review reads).

## What the regulation requires
- The front end is a UI layer: no core business logic, no direct backend call, every datum through the
  BFF; the aim is to hide backend APIs, loosen coupling and raise security (S L20–24). It is the first
  item of the mandatory list (S L313).
- The ui calls relative `/api/**` only. No IP, domain or real backend address in code, and none in an
  environment file (S L53–55).
- The BFF aggregates several APIs into the shape a page needs, filters and converts fields so nothing
  unneeded reaches the browser, unifies token and session checks, and spares the ui from integrating many
  backends (S L521–530). It also checks permissions and caches (S L556–560).
- The token lives in the BFF: 「Token 必須由 BFF 管控」 (S L311). The login chapter says why: a user with
  developer tools open cannot see it. The front side unpacks the Keycloak User Token with the
  `client_secret` and refuses a function the user's claims do not grant; the backend repeats the check
  (A L161–173, L216–225). Keycloak issues the token with roles and menu rights in its claims (A
  L147–149); Kong is the API gateway in front of backend APIs (A L14–15, L27–32).
- Allowed technology: Node.js with Express or NestJS, .NET 8 Web API, or Spring Boot (S L561–564). The
  regulation's own sample is Express (S L565–589).
- It is its own project because of container deployment: for a subsystem `IMSNC` the repository is
  `IMSNC-BFF` and the project `Med3BFF.IMSNC` (S L601–604). The Git chapter shows the same triple,
  `-Backend`, `-Frontend`, `-BFF`
  (`2026-09-18-nhia-his3-dev-standard-v2-overview-git-p11-22.pdf.md@94b087e18a61` L212–214). The
  standard backend picture puts 「Gateway/BFF」 between the Vue 3 front end and the Web API
  (`2026-09-18-nhia-his3-dev-standard-v2-backend-architecture-p72-88.pdf.md@ef02788f2448` L42–44).
- Deployment: the SPA to a CDN, the BFF to a Node.js or .NET server, backends on their own (S L597–600).

## What the ui does today
- The browser talks to two backends through the ui's own nginx, with nothing in between.
  `frontend.conf:23-27` proxies `/api/` to the kernel container `nhi-claimvalidator:8080`;
  `frontend.conf:11-15` proxies `/api/v1/Payment/` to an external Azure App Service host, written out in
  the file. The image is nginx serving `dist` with that config (`Dockerfile:9-12`).
- The code itself complies with the relative-path rule: `VITE_API_BASE_URL` is empty in production
  (`.env.production:2-3`), axios takes it as `baseURL` (`src/api/request.js:5-7`), and the four
  endpoints are relative: `/api/v1/RuleSchema`, `/api/v1/RuleSet` twice
  (`src/api/modules/rules/index.ts:129,166,231`), `/api/v1/Payment/Item/Get` and
  `/api/v1/Payment/Detail/Get` (`src/api/modules/payment/index.ts:19,29`).
- Real backend addresses do sit in the repository, against S L53–55: the Azure host in
  `frontend.conf:14`, and the dev proxy targets in `.env.development:4,6` (values not copied here).
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
- It follows the regulation's error codes and log format (nhia-frontend-standard › 附件 四 and 三) and
  carries unit tests.

## The subsystem code
Owner's question, 2026-09-21: is a five-character code required? It is. Source `N` =
`2026-09-21-nhia-his3-dev-standard-v2-project-naming-p110-113-p143.pdf.md@e826f7067352`.
- A program code has twelve characters, and the first five are the subsystem: characters 1–3 the
  system, the 4th the work area (`N` NHI, `W` WWW/Internet, `V` VPN, `C` common), the 5th the language
  (`C` C#, `J` Java, `T` JavaScript and others); 6–9 a sequence, the 10th the kind (`S` screen, `N`
  back end, `B` batch, `R` report, `U` schedule), 11–12 a number (N L54–73).
- It names everything: the front-end project `Med3Vue.IMSNC` and a page `IMSNC1001S01.vue` (N L48–50),
  the BFF `Med3BFF.IMSNC` in repository `IMSNC-BFF` (S L601–604), shared libraries
  `Med3Core.IMSNC.Log.Common` (N L76–78). 「子系統代碼必須統一」: never one system under two codes
  (N L144–149).
- Operations use it too: the deploy scripts take 「子系統名稱(5 碼)」 for the API and for the Vue app
  (`2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.md@be9db46b3ab5` L98, L116–117),
  and every log line carries it as `BusCode`
  (`2026-09-18-nhia-his3-dev-standard-v2-appendices-1-4-p297-336.pdf.md@2f916184d583` L408).
- REA's code is not in the regulation; it is assigned, so it comes from NHIA. Inferred only: `REA` +
  `N` (the 署內 shell) + `C` (the kernel is C#; the example reuses the C# code `IMSNC` for the Vue and
  BFF projects) would read `REANC`. `REA_UI` does not follow the rule today: the project is not named
  `Med3Vue.<code>` and its pages are `Payment.vue`, `RuleEditorDialog.vue`.

## What 附件五 asks of a Node.js BFF
The owner chose Node.js on 2026-09-21. Source `J` =
`2026-09-21-nhia-his3-dev-standard-v2-nodejs-p337-348.pdf.md@987fa90cdd98`.
- Layout: `src/` with `configs`, `constants`, `controllers` (req and res only, no business logic),
  `middlewares` (authentication, error handling), `routes`, `services`, `utils`, `validations` (zod),
  `tests`, and `app.js` building the express instance; `server.js` listens; `.env` with a
  `.env.template`, `.eslintrc.js`, `Dockerfile`, `jest.config.js`, `README.md` at the root (J L16–51).
  `models/` with sequelize is for a database, which a BFF has none of (J L24).
- Code: `const` and `let`, never `var`; `===`; no globals; named functions; `try/catch` around every
  async path; a logger instead of `console.log`; JSDoc on functions (J L113–142). One Express error
  middleware; secrets in `.env` read through one config module; winston or pino for logs (J L177–184).
- API: RESTful paths, JSON, the status codes 200, 201, 204, 400, 401, 403, 404, 409, 500, paging by
  `page` and `limit` (J L188–219). A pass-through route keeps the kernel's paths and OData query, so
  this binds new BFF routes, not the mirrored ones.
- Environment: Node.js v22.18.0 LTS and Express v4.21.2 (J L227–228); other packages by application
  to the architect (J L229–233). Tests with jest and supertest (J L240–256).
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
  gateway, lets only requests with a valid token reach backend APIs (A L14–32, L129–149).
- REA has no login of its own: the ui is a subsystem the shell loads, so the token is the shell's.
- The regulation says the front side keeps that token in the BFF layer, unpacks it with the
  `client_secret`, and refuses a function the claims do not grant; the backend checks again (A
  L161–173).
- Not said anywhere in the ingested parts, and the questions to take to NHIA's architects: how the
  shell's token reaches a subsystem's BFF (a shared cookie, a header the shell's BFF adds, or a call
  to the shell); whether each subsystem BFF gets its own Keycloak client and secret; which claim names
  an REA function; whether a dev realm exists to test against.

## Open questions
- REA's five-character code, from NHIA.
- Whether the architect admits `zod`, `jest` and `supertest` for the BFF.
- The token questions above.
- Whether the Payment service stays external; `frontend.conf:10` expects it to move into the cluster.
