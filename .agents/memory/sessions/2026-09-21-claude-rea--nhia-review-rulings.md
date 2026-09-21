# 2026-09-21 | claude | rea | nhia-review-rulings

## Task
Owner's answers to what must be settled before `REA_UI` is reviewed against the NHIA regulation; then:
document the BFF architecture and open a plan; record 附件二 in a document and a plan.

## Done
- nhia-frontend-standard › Rulings: subject `develop`; jQuery banned for the ui; versions follow the
  whitelist; the BFF is a separate rea project and the kernel is not it; 附件二 in scope, second.
- Module bff (the rules, today's wiring at `REA_UI@5721638`, target, open questions) and plan bff.
- Module nhia-ui-design (the 39 items; four exist only as pictures, read from them) and plan
  ui-design-conformance.
- Re-extracted the appendices part with pages 13–15 as pictures (button and label 圖例); blob now
  `2f916184d583`, lines unchanged.

## Decisions & pitfalls
- The ui already obeys the relative-path rule in `src/`; what breaks the BFF rule is its nginx
  (`frontend.conf`) and env files. A pass-through BFF therefore needs no `src/` change.
- The regulation's template files sit unused in the ui (`subSystemRouter.js`, the federation
  dependency, a commented-out 主系統 token): it was scaffolded as a subsystem and runs stand-alone.
- A plan's `Writes:` token must be a manifest id, so a plan for a repository that does not exist starts
  with the owner creating and listing it.
- Small 圖例 do not make a page "a picture" (text over 200 characters): name such pages in `IMAGES=`.

## TODO
- Owner: where REA sits (loaded into the Intranet shell, or stand-alone); REA's five-character code;
  Node.js or .NET for the BFF; whether a Keycloak client exists for REA.
- Then: the review itself against the mandatory list, on `develop`.
- Push `rea`.
