# rea / ui-deployment

How `REA_UI` is packaged, routed and deployed: the Docker image, its nginx, the build modes and the
GitLab pipeline, and the manual check of the image before a push. It is the deployment to a space
outside NHIA that the repository's files were written for (owner, 2026-09-22), not the NHIA
三代 deployment the regulation prescribes; that one is nhia-frontend-standard › Architecture and bff. Cited at `REA_UI@5721638` (`develop`
= `debug-ui` = `debug-api`). This module replaces the repository's own `docs/deployment/docker.md`
(last edited `c96d4d1`, 2026-08-05), removed with the whole `docs/` in `REA_UI@a024004`; every
statement of that file was re-checked against the config at `5721638` and still holds; what it lacked
is added below. Its two neighbours, `research.md` and `research-essence.md`, were a general survey of
AI agents in infrastructure delivery with no fact about this repository, and are not carried over
(`git show 5721638:docs/deployment/research.md` re-reads them).

## The image
- Two stages. `node:22.19.0-alpine3.22` runs `npm ci` then `npm run build -- --mode ${VUE_ENV}`, with
  `ARG VUE_ENV=production` (`Dockerfile:1-7`); `build` is `vite build` (`package.json:11`). Then
  `nginx:1.29.3-alpine3.22` gets `dist` at `/dist`, `frontend.conf` as `conf.d/default.conf` and
  `nginx_header.cfg` beside it, exposing 80 (`Dockerfile:9-14`).
- `.dockerignore` keeps out `README.md`, `.git/`, `.gitignore`, `.gitlab-ci.yml`, `node_modules/`,
  `dist/`, `coverage/`, editor files and `tests/` (`REA_UI@a024004 .dockerignore:1-26`). Two things
  must stay in the context: `mock/`, because `vite.config.js:10` imports it unconditionally even though
  the plugin runs only under `serve` (`vite.config.js:27`); and `.env.*`, because the build reads
  `.env.production` (`a024004 .dockerignore:14`).

## nginx routing (`frontend.conf`)
- `/api/v1/Payment/` goes to an external host written out in the file: since `3aea51f` the
  snapshot service on DigitalOcean App Platform (`frontend.conf:13-21`, `:16`; rea-proto-payment-
  snapshot), before that the Azure host stopped on 2026-09-30; nginx picks the longest prefix, and
  the trailing slash keeps `/api/v1/PaymentOther` on the kernel. HTTPS upstream, so
  `proxy_ssl_server_name on` sends SNI (`:20`). The comment still expects the block to be deleted
  when Payment moves into the cluster (`:12`).
- `/api/` goes to `http://nhi-claimvalidator:8080`, the kernel container on the Docker network
  (`frontend.conf:23-28`), path unstripped: the kernel routes `/api/*` itself.
- Both upstreams are variables resolved by Docker's DNS, `resolver 127.0.0.11 valid=10s`
  (`frontend.conf:13-15,25-27`). So nginx starts without the backend, answers 502 while it is absent,
  and finds a redeployed backend within 10 s without a restart.
- `= /index.html` is served `Cache-Control: no-cache`, so a browser never keeps an old shell that
  loads removed hashed assets; because a location-level `add_header` cancels the inherited ones, it
  re-includes the CSP (`frontend.conf:30-36`). Everything else is `/dist` with the SPA fallback
  `try_files $uri $uri/ /index.html` (`frontend.conf:38-42`).
- CSP: `default-src 'self'; connect-src 'self'`, scripts `'self' 'unsafe-inline' 'unsafe-eval'`,
  images also `data:` and `blob:` (`nginx_header.cfg:4`). `connect-src 'self'` suffices only because
  both APIs are same-origin proxies; a direct call to any host would be blocked.
- Request bodies up to 10 MB on both API routes (`frontend.conf:12,24`).
- The dev server mirrors the two routes: `/api/v1/Payment/` → `VITE_DEV_PAYMENT_PROXY_TARGET`, `/api`
  → `VITE_DEV_PROXY_TARGET`, both `changeOrigin`, `secure: false` (`vite.config.js:57-69`; the targets
  sit in `.env.development:4,6`, values not copied here). With `VITE_USE_MOCK=false` the mock plugin is
  off and `/api` really goes out (`vite.config.js:27`, `.env.development:7-8`). The Payment mock of
  `316318e` lived from 2026-09-30 to `69fe8b7` the next day; the Payment target is the snapshot
  service since `3aea51f` (rea-ui › Run / test). Why these real addresses in the repository break
  the regulation: bff › What the ui does today.

## Build modes
- The mode is visible in the page: `index.html:8` writes `<meta name="app-env"
  content="%VITE_APP_ENV%">`, which is `production` or `development` from `.env.<mode>:1`.
- `VITE_API_BASE_URL` is empty in production, so axios calls relative `/api` (`.env.production:2-3`).
- Any `vite build`, whatever its mode, drops `console.*` (`vite.config.js:72-74`; the commit subject
  of `b0cd679` says "only in production builds", the condition is `command === 'build'`). A production
  build also strips `data-test` attributes (`vite.config.js:12-20,31`).
- CI passes no `--build-arg` (`.gitlab-ci.yml:89`), so the dev environment runs a production-mode
  build. An attempt to build `develop` in development mode was made and reverted the same day
  (`1283821`, reverted by `56446f6`, 2026-08-05).

## The pipeline (`.gitlab-ci.yml`)
All jobs run on the runner tagged `med3-developer-runner`; stages test → build → deploy → smoke →
notify (`.gitlab-ci.yml:7-12`).
- `check-branch-name`, on every merge request: into `develop` the source must match
  `^[0-9]+-(feature|debug)` or `^(feature|debug)-`; into `production`, `hotfix-*` or
  `{n}-feature|debug|hotfix`; `develop` ↔ `production` always passes (`.gitlab-ci.yml:20-66`).
- `unit-test`, on a merge request into `develop`: `npm ci`, `npm run lint`, `npx vitest run`, a
  production build (`.gitlab-ci.yml:68-79`).
- On a push to `develop` only: `build` tags the image `$CI_REGISTRY_IMAGE/vue-frontend:dev` and
  `:<short sha>` and pushes both (`.gitlab-ci.yml:15-16,81-91`); `deploy` (GitLab environment `dev`)
  creates `med3_cluster_network` if missing and replaces the container `vue-frontend`, `--restart
  unless-stopped`, published on `$APP_HOST_PORT` (`.gitlab-ci.yml:93-111`); `smoke-test` waits 10 s,
  then up to three tries of `http://172.17.0.1:$APP_HOST_PORT/` for 200, and then requires
  `/api/v1/RuleSchema` below 500 (`.gitlab-ci.yml:113-144`); `notify` always runs and comments ✅ or ❌
  on every issue `#n` named in the description of the commit's merge request (`.gitlab-ci.yml:146-189`).
- CI/CD variables, set in GitLab and not in the repository: `APP_HOST_PORT` (e.g. 8081), `APP_URL`
  (e.g. the host in rea-ui › Deployment), `GITLAB_TOKEN` (a project access token, scope `api`, role
  Reporter, masked). Their environment scope must stay All, since `smoke-test` and `notify` declare no
  environment (`.gitlab-ci.yml:1-6`).
- There is no production deploy job; `production` appears only in the branch-name check.

## Checking the image by hand
Run from the repository root with a Docker daemon; each step tests one decision above.
1. `docker build -t vue-frontend:test .` — ends with Vite's `dist/` listing; a ~1 MB chunk warning is
   normal.
2. With no backend: `docker network create med3-test`, then `docker run -d --name vue-frontend-test
   --network med3-test -p 18081:80 vue-frontend:test`. `docker ps` shows Up, not Restarting; the log
   has no "host not found in upstream" — that error means a `proxy_pass` was hard-coded.
3. `curl -i localhost:18081/` gives 200 with the CSP and `no-cache`; `curl -sI
   localhost:18081/index.html` must show both headers (no CSP there means the re-include was lost);
   `/rules/edit/123` gives 200 (the fallback).
4. One `assets/…` path from the page gives 200 with a sensible content type.
5. `curl -s -o /dev/null -w "%{http_code} in %{time_total}s\n" localhost:18081/api/v1/RuleSchema`
   gives 502 well under a second; a hang means the proxy regressed.
6. Start a fake backend under the kernel's name: `docker run -d --name nhi-claimvalidator --network
   med3-test node:22.19.0-alpine3.22 node -e
   'require("http").createServer((q,s)=>s.end(JSON.stringify({ok:true,path:q.url}))).listen(8080)'`;
   wait 12 s (the 10 s TTL); the same curl returns `{"ok":true,"path":"/api/v1/RuleSchema"}` — the
   name is re-resolved and the prefix arrives unstripped.
7. Optional: `localhost:18081` in a browser renders with no CSP violation in the console.
8. `docker rm -f vue-frontend-test nhi-claimvalidator; docker network rm med3-test; docker rmi
   vue-frontend:test`.

Not covered by these steps: the Payment route (step 5's curl never reaches `/api/v1/Payment/`; it
needs outbound HTTPS from the container — inferred, not run; since `3aea51f` the pipeline's
`smoke-test` POSTs it through nginx and requires 200, `.gitlab-ci.yml:132-140`); and the registry
push, the `172.17.0.1` smoke URL and `notify`, which run only on a push to `develop`.
