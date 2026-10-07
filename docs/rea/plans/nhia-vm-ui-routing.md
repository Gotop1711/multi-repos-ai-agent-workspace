# rea — nhia-vm-ui-routing

Status: shipped
Writes: REA_UI (feature-nhi-deployment)
Signed: gotop1711 — 2026-10-05
Shipped: 2026-10-05 — REA_UI@2a7a7c9 (feature-nhi-deployment, unpushed)
Shipped: 2026-10-07 — REA_UI@2d2c40e (owner-rebased feature-nhi-deployment, unpushed)

## Goal
Package REA_UI for the closed NHIA VM: the VM publishes host port 8082 to the UI container's port
80; every `/api/*`, including the future Payment endpoints, goes to the in-network
`nhi-claimvalidator:8080`; no image or dev-server route names the public Payment snapshot. Keep the
same-origin API proxy and the non-cached SPA shell (owner, 2026-10-05; current routes at
`REA_UI@b0ecc15 frontend.conf:7-43`).

## Writes
- `REA_UI` (`feature-nhi-deployment`): production nginx, development proxy and the Payment
  smoke-test wording.
- The supplied VM compose/config are outside the fleet and are a backend-operator handoff, not a
  repository write.

## Steps
1. Delete only the special `/api/v1/Payment/` location from `frontend.conf`. Retain `/api/`, the
   Docker DNS resolver and the `index.html` no-cache/CSP block.
2. Delete `VITE_DEV_PAYMENT_PROXY_TARGET` and Vite's special Payment proxy, so development also
   sends Payment through the generic backend target. Keep the CI Payment check, but describe its
   upstream as the backend rather than the public snapshot.
3. Run lint, unit tests and a production build; build the image for `linux/amd64`. Smoke-test `/`,
   the SPA fallback, `/api/v1/RuleSchema` and `/api/v1/Payment/Item/Get` against a same-network fake
   `nhi-claimvalidator`.
4. Export an immutable commit-tagged tar and SHA-256. Handoff compose maps `8082:80`; do not change
   the image's `listen 80` or Dockerfile `EXPOSE 80`.

## Done when
No `rea-payment-snapshot` or `VITE_DEV_PAYMENT_PROXY_TARGET` remains in REA_UI; the image is
`linux/amd64`; its production metadata and headers are intact; both API paths reach
`nhi-claimvalidator` unstripped; the tar loads with its recorded tag; after the backend adds Payment,
`http://med3rearuledev.intra.nhi.gov.tw:8082/api/v1/Payment/Item/Get` answers successfully.
