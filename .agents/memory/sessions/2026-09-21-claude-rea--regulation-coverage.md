# 2026-09-21 | claude | rea | regulation-coverage

## Task
Owner: is the five-character subsystem code binding on `REA_UI` if its rule sits in the C# chapter?
Is the ingested regulation complete enough, or should the whole document be ingested? And file the
ui's conversion to a Federation remote as a plan.

## Done
- The code: the BFF needs it either way (肆 十一 5 names `<code>-BFF` / `Med3BFF.<code>`), so it stays
  a blocker for plan bff only. For the ui's own names the regulation contradicts itself — 伍 四 (一) 2
  gives `IMSNC1001S01.vue`, 肆 二 1 gives kebab-case — so it needs a ruling, not an assumption. Both
  modules corrected.
- Coverage audit: swept every page outside the ingested parts for front-end terms. Found and ingested
  two truncated tails (前端單元測試 → p225, JavaScript → p356; the old parts pruned) and three
  back-end-chapter rules (API naming p114–118, DTO/validation p169–184, the cover and revision history
  p1–3). nhia-frontend-standard › Coverage now records the method, the page list and the full
  document's sha256.
- Plan federation-remote: expose `subSystemRouter.js`, configure the federation plugin, drop the frame.

## Decisions & pitfalls
- Cutting by heading truncates a section whose tail runs onto the next page: cut to the next heading
  and read the following page. The sweep is the audit that catches it.
- Refused a whole-document ingest: 47 automatic pictures for uncited pages, and ~150 line citations to
  re-point, buying no content the sweep did not already find. Recorded in the module with the reason.
- Appending pages to a part leaves earlier line numbers intact: only the blob and range end moved.
- `SECRET_OK=` is per file name, so a re-cut of a waived part needs the waiver again.

## TODO
- Owner: REA's five-character code from NHIA; a ruling on the ui's file naming (kebab-case vs the
  12-character code); the architect on `zod`, `jest`, `supertest`; the shell team's answers in plan
  federation-remote step 1; the Keycloak discussion.
- Push `rea`.
