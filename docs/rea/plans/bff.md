# rea — bff: a BFF between the ui and its two backends

Status: draft

## Goal
`REA_UI` reaches its backends only through a BFF, as the NHIA regulation's first mandatory rule demands
(bff › What the regulation requires). Today the ui's nginx proxies the browser straight to the kernel
and to an external Payment host, the repository carries real backend addresses, and no token exists
anywhere (bff › What the ui does today, at `REA_UI@5721638`). When this ships, the browser talks to one
origin, that origin's `/api/` goes to the BFF alone, the BFF holds the backend addresses and the user's
token, and the ui repository names no backend. Owner's rulings, 2026-09-21: the BFF is a separate rea
project in its own repository; `REA_kernel` is not the BFF.

## Writes
A new repository for the BFF, which must first exist and be listed in `catalog/repos.yaml` with
`product: rea` and `access: write` (a `Writes:` token is a manifest id). `REA_UI (develop)` for the
proxy change and the removal of backend addresses. Nothing in `REA_kernel`: a token check on the kernel
side is the regulation's second guard and would be a request of its own.

## Steps
1. Before signing, three answers from NHIA: the repository's name — the regulation gives three
   patterns, and NHIA's own GitHub decides (bff › The subsystem code); REA's five-character code, read
   as `REANC` from the program-code rule, which names the project `Med3BFF.<code>` and its deployment;
   and the architect's written acceptance of a Node.js BFF, since 伍 claims the BFF for C# (bff › the
   stack), together with whether `zod`, `jest`, `supertest` are admitted. Decided 2026-09-21: Node.js
   with Express, laid out as 附件五 prescribes.
2. Owner creates the repository and adds it to the manifest; `./workspace.sh clone`;
   `./workspace.sh doc add rea <repo>` for its repository doc.
3. Pass-through BFF: the routes the ui calls today, one to one — `GET /api/v1/RuleSchema`, `GET
   /api/v1/RuleSet` with its `$filter`, `$orderby`, `$top`, `$skip` query passed through, `POST
   /api/v1/RuleSet`, `POST /api/v1/Payment/Item/Get`, `POST /api/v1/Payment/Detail/Get` — with
   the kernel and Payment addresses as BFF configuration, listening on 8003, the regulation's convention for a BFF container, the regulation's error codes and log format,
   a health route, a Dockerfile, unit tests.
4. `REA_UI`, for the off-premises deployment its files describe (ui-deployment): `frontend.conf` proxies
   `/api/` to the BFF only and loses the Payment block and the Azure host; `.env.development` points its one proxy target at a local BFF; `vite.config.js` loses the
   Payment proxy. The ui's `src/` does not change, its paths are already relative. An
   NHIA deployment would not use `frontend.conf` at all: `deploy_vue.sh` generates the nginx, which
   proxies no `/api`, and the gateway routes the API (nhia-frontend-standard › Architecture).
5. Token, deferred until the owner and NHIA's architects settle bff › Token and Keycloak: the BFF
   receives the shell's User Token, keeps it server-side, checks the claim per route and forwards it
   to the backends. The ui's commented-out `Authorization` lines go; 401 and 403 handling stays. If
   this outgrows the write set or the schedule it becomes its own plan, and steps 1–4 ship without it.
6. Shaping, each its own commit and each optional: trim the `RuleSet` row to the fields the ui reads
   (closes plan ruleset-unread-fields without a kernel change); move the case transform out of the
   browser; merge the Payment lookups a dialog makes.

## Done when
The deployed ui's network panel shows requests to its own origin only; `grep` finds no backend host in
`REA_UI`; stopping the BFF stops every API call; once step 5 lands, a request without a valid token is
refused by the BFF before it reaches the kernel; the rule editor opens, edits and saves a rule as
before; the BFF's tests and the ui's `vitest` and lint pass.
