# rea — ui-design-conformance: the ui's screens against 附件二

Status: draft

## Goal
`REA_UI`'s screens meet the thirty-nine items of 附件二 介面設計規範 (nhia-ui-design), or each miss is
ruled on. Owner's ruling, 2026-09-21: in scope, second in priority to plan bff. Nothing is assessed
yet; this plan starts with the assessment.

## Writes
`REA_UI (develop)`. Items 4–8 (header, menu, breadcrumb) only if `REA_UI` keeps its own frame; if it
is loaded into a shell they are the shell's and leave this plan.

## Steps
1. Owner rules where REA sits: a micro-frontend loaded into the Intranet shell, or a stand-alone app
   with its own frame.
2. Assess, in the workspace only: run the ui with its mock (`VITE_USE_MOCK=true`), capture the rule
   list, the rule editor dialog and the Payment view, ingest the captures, and record item by item in
   nhia-ui-design what is met, missed, or not applicable, each with the ui file that decides it (the
   Element Plus theme variables, `src/assets` styles, the dialog and button wrappers).
3. Owner picks which misses to fix; the button-name dictionary (items 1–2) needs the 署方's list first.
4. Fixes as theme-level commits where one variable settles an item (colours, button size and states,
   dialog width and border, placeholder colour), then per-component commits (ROC date, year and month
   inputs with typing, `HH:MM` time input, paging text, 【…】 on window-opening buttons, the padlock on
   disabled buttons, dialog focus), each with a test.

## Done when
nhia-ui-design marks every item met, not applicable, or ruled out by the owner, and the owner has
looked at the running editor beside the 圖例.
