# rea — payment-snapshot: a frozen 支付標準 service in its own repository replaces the Azure host

Status: shipped
Writes: REA_PROTO_PAYMENT_SNAPSHOT (main), REA_UI (develop)
Signed: gotop1711 — 2026-10-01
Shipped: 2026-10-01 — REA_PROTO_PAYMENT_SNAPSHOT@e22769a (step 1, pushed to main)
Amended: 2026-10-01 — App Platform URL `https://rea-payment-snapshot-nw4ns.ondigitalocean.app` (the owner, in session)
Shipped: 2026-10-01 — REA_UI@3aea51f (upstream, dev proxy, smoke-test), @69fe8b7 (dev mock removed); develop unpushed

## Goal
`REA_PROTO_PAYMENT_SNAPSHOT` answers `POST /api/v1/Payment/Item/Get` and `/Detail/Get` with the
data the stopped Azure host served, from its own repository, deployed on DigitalOcean App Platform
from GitHub `main`; `REA_UI`'s nginx and dev proxy point at it, and the ui carries no Payment code
of its own. Why: the host both proxies point at has been stopped since 2026-09-30 and nothing in the
fleet answers those paths (rea-ui › Deployment); the data is known exactly — plan payment-mock rebuilt
it from `REA_PROTO_BE@ba161ff`'s seed and proved it identical to the owner's captures. Owner's
rulings, 2026-10-01: a Node process plus the JSON snapshot, nothing else; its own repository
(`git@github.com:Gotop1711/REA_payment-snapshot.git`, outside the GitLab group); hosted outside
`210.59.250.145`, on App Platform. What it is not: the prototype backend — no `Rule/Save`, no
`UiTemplate`, no MongoDB — so the data-creator acceptance plan stays blocked; and its rule dates are
the "no rule" values for every row (payment-mock, step 2). The ui's dev mock becomes redundant and goes.

## Writes
`REA_PROTO_PAYMENT_SNAPSHOT (main)` — the whole repository, from its first commit.
`REA_UI (develop)` — two addresses, the smoke test, and the removal of the dev mock.
Nothing in `REA_PROTO_BE`: its two seed CSVs are read once more by the generator, not copied.

## Steps
0. Access — done 2026-10-01: the owner's SSH change lets this shell reach GitHub as `Gotop1711`.
   `./workspace.sh clone` cannot clone an empty upstream (it asks for `--branch main`, which does
   not exist yet), so the child was initialised by hand as `clone` does for `remote: none`:
   `git init -b main` plus `origin`. No file, no commit: the first commit is step 1's.
1. The repository, one commit: `src/handlers.js` (`REA_UI@8c52af5 mock/payment.js`, unchanged);
   `src/server.mjs` — `node:http`, `PORT` (default 8080), the two POST paths → JSON, `GET /healthz`
   → 200, anything else → 404, body capped at 1 MB, no dependency; `data/paymentData.json`
   (`REA_UI@58271d8 mock/paymentData.json`, 8,686 rows, 4.4 MB); `tools/build-payment-data.mjs`
   (`mock/build-payment-data.mjs`, reads the two CSVs from a directory argument); `test/` — the ui's
   17 cases ported to `node --test`, plus one that starts the server and exercises the three routes;
   `package.json` (`"type": "module"`, `start`, `test`, `engines.node >=22`, no dependencies);
   `Dockerfile` (`node:22-alpine`, copies `src/`, `data/`, `package.json`, runs as `node`, `EXPOSE
   8080`); `README.md` — what it is, the provenance (`REA_PROTO_BE@ba161ff SeedData/`, identical to
   the host's last answers on 2026-09-30), the one known difference, how to rebuild the data, how it
   is deployed; `.gitignore`. The seed CSVs (11 MB) are not committed; the README says where they are.
2. Owner: push `main`; in App Platform choose the repository and `main`, the Dockerfile component,
   HTTP port 8080, health check `GET /healthz`, the smallest instance, auto-deploy on push; note the
   `https://….ondigitalocean.app` URL. Amend this plan with the URL.
3. `REA_UI`, one commit: `frontend.conf:14` sets `$payment_upstream` to that URL (`https`, so
   `proxy_ssl_server_name on` stays, `:18`); `.env.development:6` points `VITE_DEV_PAYMENT_PROXY_TARGET`
   at it and the comment names the snapshot; `smoke-test` (`.gitlab-ci.yml:113-144`) gains a POST
   through nginx, `http://172.17.0.1:$APP_HOST_PORT/api/v1/Payment/Item/Get` with `{}`, expecting 200.
4. `REA_UI`, one commit: the dev mock goes — `VITE_MOCK_PAYMENT` from `.env.development`, the
   `payment` option from `mock/index.js` and `vite.config.js` (back to `316318e`'s parent shape),
   `mock/payment.js`, `mock/paymentData.json`, `mock/build-payment-data.mjs`, `tests/unit/mock/`.
   Plan payment-mock stays as history: it shipped, and its data now lives in the snapshot repository.
5. After shipping, the docs: rea-proto-payment-snapshot (run, test, deploy, integration), rea-ui
   (Run / test, Deployment), ui-deployment (nginx routing, the dev server), bff (the external host
   is now the snapshot).

## Done when
The App Platform URL answers `Item/Get` for `""` with the 8,686 captured rows (identical to
`docs/rea/rea-proto-be/sources/2026-09-30-post-payment-item-get-response.json.md@82b9f9adcd5c`,
checked here) and `Detail/Get` for `01116B` with the captured row; `/healthz` is 200; on
`http://210.59.250.145:8081` the network panel shows `Item/Get` 200 from nginx, a code can be picked,
查詢, 進階查詢 and the 加成 tab work; `npm run dev` does the same with no mock flag; `git grep -l
Payment/Item` in `REA_UI` finds only `src/api/modules/payment/index.ts`; `npx vitest run`, `npm run
lint` and the snapshot's `node --test` pass; the next push to `develop` passes `smoke-test`.
