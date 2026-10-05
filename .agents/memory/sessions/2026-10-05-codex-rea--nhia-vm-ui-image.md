# 2026-10-05 | codex | rea | nhia-vm-ui-image

## Task
Owner needs a REA_UI Docker image to hand to the backend colleague for an offline/strict NHIA VM;
supplies its compose, TLS nginx configuration and folder screenshots.

## Done
- Checked the workspace; read REA_UI deployment/repository docs, current source at `b0ecc15`, the
  supplied configuration, and current kernel at `7f9936f` (still no Payment route).
- Ingested the supplied compose and nginx as sources. The compose's secret scan was waived only for
  environment-variable placeholders; no credential value was present.
- Built `rea-ui:b0ecc15` for `linux/amd64`; image ID
  `sha256:8a1dcf63e5cd7f91659e87a416e957dbafada8752ff75dc0a1f11bc2728c448f`.
- Smoke test: nginx config valid; `/` 200 with production meta, CSP and no-cache; SPA fallback 200;
  `/api/v1/RuleSchema` reached a same-network fake `nhi-claimvalidator` with its path intact. Removed
  the two temporary containers and network.
- Exported `/Users/jarivschen/Web/Case_資拓_健保署/署內vm/rea-ui-b0ecc15-linux-amd64.tar`
  (22 MB), SHA-256 `c856eb895f931156d1ad37ae5cfe5b34e72dd92a39f67e52b4b45cfc7ed310ce`.
- Updated ui-deployment with the NHIA VM topology and routing gate; refreshed the REA_UI head.

## Decisions & pitfalls
- The VM's outer nginx owns 80/443; the UI service should expose no host port and join
  `med3_cluster_network`, with outer `/` proxying to it.
- The existing outer `/api` regex bypasses the UI image. Payment would hit the kernel (no route),
  while the image itself points Payment at public DigitalOcean. A closed deployment needs an
  internal Payment service/routing decision before it can work end to end.
- `ui_latest-codes` omits tracked dotfiles including `.env.production` and `.dockerignore`; do not
  use that copied folder as the Docker build context. The Git checkout was used.
- `linux/amd64` is an explicit handoff assumption; the VM operator must confirm `uname -m`.

## TODO
- Owner/backend: confirm VM architecture and outbound HTTPS policy; name the internal Payment
  upstream if egress is blocked.
- Backend: add the UI service and outer nginx `/` route, load the tar, then smoke-test over HTTPS.
