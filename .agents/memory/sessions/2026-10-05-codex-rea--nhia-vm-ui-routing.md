# 2026-10-05 | codex | rea | nhia-vm-ui-routing

## Task
Owner clarifies the NHIA VM publishes REA_UI on 8082 and the kernel will later implement Payment;
asks whether the generic API proxy and exact `index.html` block remain necessary.

## Done
- Confirmed: publish host `8082:80`; no image listen/EXPOSE change. The generic `/api/` proxy stays
  because port 8082 reaches the UI nginx directly, bypassing the outer TLS nginx.
- Confirmed: keep the exact `index.html` block; it prevents stale SPA shells and must repeat CSP due
  to nginx `add_header` inheritance.
- The special public Payment location alone must go; so must the dev-only special Payment target.
  Payment will then fall through to the generic backend proxy. The CI Payment probe can remain as
  the deployment gate, with its stale external-snapshot comment corrected.
- Created draft plan `nhia-vm-ui-routing`, writing `REA_UI (debug-cicd)`. No child write or new image:
  the plan has no human `Signed:` line.
- Updated ui-deployment with the owner's port and backend-routing decision.

## Decisions & pitfalls
- `http://med3rearuledev.intra.nhi.gov.tw:8082` is HTTP. HTTPS on 8082 would require separate TLS
  termination/configuration and is not implied by `8082:80`.
- Removing the generic `/api/` location would make API requests hit the SPA fallback and return HTML.
- Until the backend ships Payment, the new image can serve the UI and other APIs but Payment calls
  will correctly return the backend's not-found response; the existing CI Payment probe will fail.

## TODO
- Owner: add `Signed: <name> — 2026-10-05` to/approve that exact line for the plan; then implement,
  test, commit on `debug-cicd`, build the replacement tar and give the backend compose snippet.
