# 2026-10-07 | codex | rea | frontend-image-rebuild

## Task
Owner rebased `feature-nhi-deployment` onto current `develop` and requests a rebuilt
`nhi-claimvalidator-frontend-dev` image and tar.

## Done
- Confirmed clean `REA_UI@2d2c40e`: `develop@bdd28ec` is its ancestor; Payment and all `/api/*`
  routes use `nhi-claimvalidator:8080`; no snapshot endpoint or dev Payment target remains.
- Built production for `linux/amd64`; lint passed; 53 files / 1,141 unit tests passed with existing
  non-failing Vue warnings and the existing >500 kB chunk warning.
- Image `nhi-claimvalidator-frontend-dev:latest` exposes 80; image ID
  `sha256:a86c5022f2271cabfb60316eb78a77ef90c59a15050650af799044beec053f10`.
- At `127.0.0.1:8082`, nginx config, production meta, CSP/no-cache, `/`, SPA fallback, RuleSchema GET
  and Payment POST passed; both API paths reached one fake `nhi-claimvalidator` unchanged.
- Replaced and reload-checked `/Users/jarivschen/Web/Case_資拓_健保署/署內vm/nhi-claimvalidator-frontend-dev.tar`
  (22 MB), SHA-256 `63d10a7d8e58edc5e95d3a0a238c8893bf384c757109b18717967906171ee80c`;
  manifest tag is `nhi-claimvalidator-frontend-dev:latest`.
- Removed disposable containers, network, build-test image and aborted-turn build context. No child
  file or git state was changed by Codex.

## Decisions & pitfalls
- Before the owner's rebase, `develop` still had the external Payment proxy; building it directly
  would have regressed VM routing. The rebased branch is now the single build source.
- `.dockerignore` excludes `tests/`, so the build-stage image initially found none; mounting only
  `tests/` read-only into that image exercised its exact source and installed dependencies.

## TODO
- Backend operator: verify the new checksum, load this replacement tar, redeploy, then exercise the
  real VM/backend before the owner adds `Verified:` to plan nhia-vm-ui-routing.
