# rea / bff

The BFF (Backend For Frontend) the NHIA regulation requires between `REA_UI` and every backend. It does
not exist yet. Owner's rulings, 2026-09-21: it is a separate rea project with its own repository (a
working name `ui_bff` under `projects/`), and `REA_kernel` may not stand in for it. This module records
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
- The BFF keeps the User Token server-side and gives the browser a session cookie; it checks the claim
  for each REA function and forwards the token to the kernel, which checks again.
- The BFF's first routes mirror the four endpoints one to one, so the ui changes nothing but its proxy.
  Shaping comes after: trim the `RuleSet` row to what the ui reads, move the case transform out of the
  browser, merge Payment lookups a dialog needs into one call.
- It follows the regulation's error codes and log format (nhia-frontend-standard › 附件 四 and 三) and
  carries unit tests.

## Open questions
- REA's five-character subsystem code, which names the repository `<code>-BFF` and the project
  `Med3BFF.<code>` (naming rule: 伍 五 (十二), not yet read for REA).
- Node.js or .NET. Node.js with Express keeps it with the ui's team and is the regulation's sample; the
  whitelist admits `express <=5.1.0`, `http-proxy-middleware <=3.0.5`, `axios <=1.18.0` and
  `keycloak-js <=26.2.1` (`2026-09-18-nhia-his3-library-whitelist.md.md@e97c76a4c25f` L4265, L4462,
  L3876, L4633), but it brings 附件五 Node.js 開發規範 (PDF p337–348, not ingested) into force. .NET 8
  puts it under chapter 伍's layering and naming rules.
- Whether a Keycloak realm and client exist for REA, and whether REA is reached through the Intranet
  shell's login (nhia-frontend-standard › rulings, the open point on REA's place in the frame).
- Whether the Payment service stays external; `frontend.conf:10` expects it to move into the cluster.
