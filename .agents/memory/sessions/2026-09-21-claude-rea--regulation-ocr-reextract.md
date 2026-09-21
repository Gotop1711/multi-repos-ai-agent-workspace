# 2026-09-21 | claude | rea | regulation-ocr-reextract

## Task
Owner: after `extract` was improved on `main`, confirm the stored asset is the owner's original,
re-extract the whole regulation, and bring every document and plan up to the new precision.

## Done
- Asset and original are byte-identical (`cmp`, sha256 `cf804534…30d2`); only the name differs.
- Re-extracted with `main@bd8dd45`'s script, borrowed into the working tree and restored, since the
  rebase is the owner's: text layer unchanged (R L1–8811; 313 line references re-checked, none moved),
  115 pictures, OCR of 98 pictured pages appended from R L8813. Blob now `b3e81e38baa5`.
- Searched the OCR index, then opened the pictures. Corrected: the shell is `NhiVue.main`, its exposed
  keys `./v1/components`, `./v2/components`, only the shell shares singletons (was OCR-derived).
  Added: 圖 2 and 圖 7 draw BootstrapVue/Bootstrap5 and **no BFF**, against 肆's text; a deployed Vue
  app sits under `/<route path>/` on nginx 8000 (`base: '/'` must change); `fw-api: dev` is a pod
  label in the template, so my "framework image" guess in bff was wrong and 8003 is the safe port.

- nhia-frontend-standard passed its cap: the whole-document parts moved to new module nhia-regulation.

## Decisions & pitfalls
- The OCR index earned its keep within minutes and was wrong in the same minutes: it found 圖 7, and it
  had given us a misspelt shell name. Index to find, picture to cite.
- Small inline 圖例 (pages 241, 242, 309–311) are below the figure threshold; kept via `IMAGES=`.
- The other session's ui-deployment module is not mine to edit; the route-path finding is reported.

## TODO
- Owner: rebase `rea` onto `main` (bd8dd45); push both. The route-path and port-8000 facts may belong
  in ui-deployment. Earlier open items stand (REANC, architect, shell team, Keycloak).
