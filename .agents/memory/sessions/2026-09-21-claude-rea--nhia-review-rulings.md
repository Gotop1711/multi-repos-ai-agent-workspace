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
- Appendices part re-extracted with pages 13–15 as pictures (`2f916184d583`, lines unchanged).

- Second round of rulings: `REA_UI` is a subsystem the shell loads; the BFF is Node.js; Keycloak is
  deferred for discussion. Ingested 附件五 Node.js (`987fa90cdd98`) and the project-naming pages
  p110–113, p143 (`e826f7067352`). bff gained › The subsystem code (required; REA's comes from NHIA),
  › What 附件五 asks, › Token and Keycloak: deferred; plan bff's steps 1 and 5 follow.

## Decisions & pitfalls
- 附件五 names `zod`, `jest`, `supertest`; the whitelist lists none of them. Two rule sets that both
  bind: surfaced as a question for the architect rather than picked.
- The ui already obeys the relative-path rule in `src/`; what breaks the BFF rule is its nginx
  (`frontend.conf`) and env files. A pass-through BFF therefore needs no `src/` change.
- The ui was scaffolded as a subsystem (`subSystemRouter.js`, the federation dependency) and runs
  stand-alone.
- A plan's `Writes:` token must be a manifest id, so a plan for a repository that does not exist starts
  with the owner creating and listing it.
- Small 圖例 do not make a page a picture: name such pages in `IMAGES=`.

## TODO
- Owner: REA's five-character code from NHIA; the architect's answer on `zod`, `jest`, `supertest`;
  the Keycloak discussion (bff › Token and Keycloak: deferred).
- Not filed: the shell ruling makes `REA_UI` a Federation remote to be; the review will show it.
- Then: the review itself against the mandatory list, on `develop`.
- Push `rea`.
