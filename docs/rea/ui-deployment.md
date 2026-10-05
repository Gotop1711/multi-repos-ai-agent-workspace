# rea / ui-deployment

How `REA_UI` is packaged, routed and deployed: the Docker image, its nginx, the build modes and the
GitLab pipeline, and the manual check of the image before a push. It is the deployment to a space
outside NHIA that the repository's files were written for (owner, 2026-09-22), not the NHIA
三代 deployment the regulation prescribes; that one is nhia-frontend-standard › Architecture and bff. Cited at `REA_UI@2a7a7c9`. This module replaces the repository's own `docs/deployment/docker.md`
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
- Every `/api/` path, including `/api/v1/Payment/`, goes to
  `http://nhi-claimvalidator:8080`, the kernel container on the Docker network
  (`frontend.conf:7-14`), path unstripped: the kernel routes `/api/*` itself. There is no external
  Payment upstream in the image since `2a7a7c9`.
- The upstream variable is resolved by Docker's DNS, `resolver 127.0.0.11 valid=10s`
  (`frontend.conf:10-14`). So nginx starts without the backend, answers 502 while it is absent, and
  finds a redeployed backend within 10 s without a restart.
- `= /index.html` is served `Cache-Control: no-cache`, so a browser never keeps an old shell that
  loads removed hashed assets; because a location-level `add_header` cancels the inherited ones, it
  re-includes the CSP (`frontend.conf:17-23`). Everything else is `/dist` with the SPA fallback
  `try_files $uri $uri/ /index.html` (`frontend.conf:25-28`).
- CSP: `default-src 'self'; connect-src 'self'`, scripts `'self' 'unsafe-inline' 'unsafe-eval'`,
  images also `data:` and `blob:` (`nginx_header.cfg:4`). `connect-src 'self'` suffices only because
  the API is a same-origin proxy; a direct browser call to another host would be blocked.
- Request bodies up to 10 MB on the API route (`frontend.conf:10-14`).
- The dev server likewise sends every `/api` path to `VITE_DEV_PROXY_TARGET`, with `changeOrigin`
  and `secure: false` (`vite.config.js:55-63`; target at `.env.development:4`, value not copied here).
  With `VITE_USE_MOCK=false` the mock plugin is off and `/api` really goes out
  (`vite.config.js:27`, `.env.development:5-6`).

## Build modes
- The mode is visible in the page: `index.html:8` writes `<meta name="app-env"
  content="%VITE_APP_ENV%">`, which is `production` or `development` from `.env.<mode>:1`.
- `VITE_API_BASE_URL` is empty in production, so axios calls relative `/api` (`.env.production:2-3`).
- Any `vite build`, whatever its mode, drops `console.*` (`vite.config.js:65-67`; the commit subject
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
  `/api/v1/RuleSchema` below 500 and the backend's `Payment/Item/Get` at 200
  (`.gitlab-ci.yml:113-144`); `notify` always runs and comments ✅ or ❌
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
   name is re-resolved and the prefix arrives unstripped. A POST to
   `/api/v1/Payment/Item/Get` must reach the same fake backend with that path unstripped.
7. Optional: `localhost:18081` in a browser renders with no CSP violation in the console.
8. `docker rm -f vue-frontend-test nhi-claimvalidator; docker network rm med3-test; docker rmi
   vue-frontend:test`.

Not covered by these steps: the registry push, the `172.17.0.1` smoke URL and `notify`, which run
only on a push to `develop`.

## NHIA VM handoff
The configuration supplied on 2026-10-05 is a second deployment shape, not the pipeline deployment
above. Its compose has MongoDB, the kernel API, the ETL worker and an outer nginx; all join the
external `med3_cluster_network`, and only that outer nginx publishes 80/443
(`docs/rea/sources/2026-10-05-nhia-vm-docker-compose.yml.md@e50f1ac39ce7 L10`, `L41`, `L60`,
`L76`, `L86`, `L95`, `L106`). Its TLS virtual host returns 404 for `/` and sends every `/api` or
`/swagger` request directly to `nhi-claimvalidator:8080`
(`docs/rea/sources/2026-10-05-nhia-vm-nginx-default.conf.md@9a5dc8523ef7 L9`, `L23`, `L28`).

Owner decision, 2026-10-05: add `rea-ui` to the same network and publish host `8082` → container
`80`. Requests to `http://med3rearuledev.intra.nhi.gov.tw:8082` therefore go directly to the UI
nginx, not the outer TLS nginx. The UI's generic `/api/` proxy remains necessary and sends Payment
to the kernel backend that will implement it later (`REA_UI@2a7a7c9 frontend.conf:7-14`). Until it
does, the frontend serves but its Payment calls receive the backend's not-found response. The exact
`index.html` location remains necessary for cache lifetime and CSP (`frontend.conf:17-23`).

For an offline handoff, build from the Git checkout rather than a copied source folder: `.env.production`
is part of the build context and fixes the generated app to production mode (`REA_UI@2a7a7c9
.env.production:1-3`; `Dockerfile:3-7`). Build for the VM's architecture, give the image an immutable
commit tag, `docker save` it, record SHA-256, then have the VM operator verify the checksum and
`docker load` it before compose. The UI service maps `8082:80`; its internal nginx and Dockerfile
continue to listen/expose 80 (`frontend.conf:4-5`, `Dockerfile:14`).
