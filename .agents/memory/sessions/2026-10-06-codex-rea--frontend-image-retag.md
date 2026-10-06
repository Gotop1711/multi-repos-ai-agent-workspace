# 2026-10-06 | codex | rea | frontend-image-retag

## Task
Owner requests the REA_UI Docker image name `nhi-claimvalidator-frontend-dev`.

## Done
- Reloaded the previously validated `rea-ui:2a7a7c9` archive and retagged it as
  `nhi-claimvalidator-frontend-dev:latest`; no source, layer or application configuration changed.
- Both tags resolve to the same `linux/amd64` image ID
  `sha256:6bbac700fe65adeec547a8fc590caa7857e617c650d04916f98b1cc60f4e8d9a`.
- Exported and reload-checked `/Users/jarivschen/Web/Case_資拓_健保署/署內vm/nhi-claimvalidator-frontend-dev.tar`
  (22 MB), SHA-256 `a18093ecc11f7f1152346c6c8fc36c6d923711c41794a7d2c6dde5733c6ccb34`.
- Its manifest has only `nhi-claimvalidator-frontend-dev:latest`; made the archive world-readable.
- Recorded the handoff repository name and compose spelling in ui-deployment. No child changed.

## Decisions & pitfalls
- A Docker image reference always has a tag; omitting it in compose means `:latest`.
- Renaming requires a tag plus `docker save`; renaming only the `.tar` file would leave the old
  repository tag inside the archive.

## TODO
- Backend operator: replace only the UI service's `image:` value, verify the checksum, load the new
  tar and deploy; keep the `8082:80` mapping and shared `med3_cluster_network`.
