# 2026-10-06 | codex | rea | local-image-test

## Task
Owner asks how to determine locally whether the exported `rea-ui:2a7a7c9` tar is workable.

## Done
- Prepared a copy-paste test flow: checksum, load, platform/tag inspection, isolated Docker network,
  fake backend under alias `nhi-claimvalidator`, UI at `127.0.0.1:8082:80`, curl probes, nginx
  validation and cleanup.
- The fake backend proves RuleSchema and Payment take the same proxy and keep their paths/methods;
  it deliberately does not imitate the API response bodies or prove the business workflow.
- Added the test's acceptance boundary and Apple Silicon `--platform linux/amd64` requirement to
  ui-deployment. No child repository or artifact changed.

## Decisions & pitfalls
- A homepage-only check misses the main deployment risk: Docker DNS and `/api/` routing.
- A 502 without a backend is expected and proves only that nginx did not serve SPA HTML for `/api`.
- The Node test-server image may require a Docker Hub pull. Mixed arm64 fake backend and amd64 UI
  containers can share the same Docker network.

## TODO
- Owner: run the probes locally; later repeat against the real VM/backend before adding `Verified:`
  to plan nhia-vm-ui-routing.
