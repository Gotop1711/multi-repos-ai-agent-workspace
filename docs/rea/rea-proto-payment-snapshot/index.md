# rea / rea-proto-payment-snapshot

Repository `REA_PROTO_PAYMENT_SNAPSHOT` (`projects/rea_proto_payment_snapshot`, access write,
`git@github.com:Gotop1711/REA_payment-snapshot.git`, `main`). Cited at
`REA_PROTO_PAYMENT_SNAPSHOT@e22769a`. Plan: [payment-snapshot](../plans/payment-snapshot.md).

## What it is
A Node process and a JSON file: the 支付標準 the stopped Azure Payment host served, frozen. It
answers the two paths `REA_UI` calls, `POST /api/v1/Payment/Item/Get` and `/Detail/Get`, plus
`GET /healthz`; anything else is 404 (`src/server.mjs:50-66`). No dependency, no database, no
authentication; nothing writes.

## Run / test
- `npm start` — `PORT`, default 8080 (`src/server.mjs:69-76`); `npm test` — `node --test`, 21 cases
  (`test/`). Node ≥ 22 (`package.json:8-10`).
- `Dockerfile:1-9`: `node:22-alpine`, copies `src/` and `data/` only, runs as `node`, port 8080.
  Not built here (no Docker daemon on 2026-10-01); App Platform builds it.
- Rebuild the data only when the seed changes: `node tools/build-payment-data.mjs <dir with the two
  csv>` writes `data/paymentData.json` (`tools/build-payment-data.mjs:153-166`).

## Entry points
| Read this first | For |
|---|---|
| `src/handlers.js` | the two lookups; born as the ui's one-day dev mock (plan payment-mock) — the commit message's `REA_UI@8c52af5` is reachable from no public ref since the owner's rewrite |
| `src/server.mjs` | routing, body cap 1 MB, 400 on bad JSON, `/healthz` |
| `tools/build-payment-data.mjs` | the seed replay: newest `PAY_S_DATE` row per code, joined, CRLF |
| `README.md` | provenance, the one known difference, deployment |

## Storage
`data/paymentData.json` — 8,686 rows, 4.4 MB, one object per line, from `REA_PROTO_BE@ba161ff
SeedData/seed_data_mhct_payment.csv` and `seed_data_mhct_payitems.csv`; read once at start.

## Integration
- Serves exactly what the Azure host served: `Item/Get` for `""` and `Detail/Get` for `01116B`
  equal the owner's 2026-09-30 captures as JSON (rea-ui › Run / test cites them; checked again
  against the running server in session). Rule dates are the "no rule" values on every row — the
  prototype's MongoDB is not reproduced (rea-proto-be › What each mode needs).
- Deployed on App Platform at `https://rea-payment-snapshot-nw4ns.ondigitalocean.app` (`/healthz` → `{"status":"ok","rows":8686}`;
  both lookups equal the captures from there too, 2026-10-01). `REA_UI` reaches it only through its
  nginx `$payment_upstream` (`REA_UI@cffdc0f frontend.conf:16`) and its dev proxy target
  (`.env.development:6`); the pipeline's `smoke-test` POSTs the route (`.gitlab-ci.yml:132-140`).
- Not the prototype backend: no `Rule/Save`, no `UiTemplate/*`; the data-creator acceptance plan
  still needs `REA_PROTO_BE` itself.
