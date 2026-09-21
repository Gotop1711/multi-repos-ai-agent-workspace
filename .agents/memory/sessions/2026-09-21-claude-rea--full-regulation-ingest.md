# 2026-09-21 | claude | rea | full-regulation-ingest

## Task
Owner: ingest the whole 開發規範 V2.0, drop the per-chapter excerpts, then read it systematically and
check what the documents and plans already claim — the naming judgement above all.

## Done
- Ingested all 367 pages as one source `R` (`2bfefa3770d5`, 8812 lines, 80 pictures); remapped 163 line
  citations across five documents by matching each old line's text inside its PDF page, then pruned the
  fifteen excerpts (`prune --apply`).
- Naming, re-judged: 伍 states its 適用範圍 as back-end projects in C#/.NET (R L1239–1260), so its
  「前端專案命名規則」 does not reach the ui, and 肆's kebab-case governs; the code is still needed for
  `deploy_vue.sh` and for the BFF's names. The owner's reading was right for the ui's own names.
- Found by reading, not by sweeping: REA's system code is in the regulation (「REA 醫令自動化審查子系統」,
  R L261), so the five-character code reads `REANC` on the stated rules; the BFF's container port is
  8003; 伍 claims the BFF while naming .NET 10 against 肆's .NET 8 and 附件五's Node.js; 附件三 Log
  binds back-end developers and SRE, not the ui (corrected in the module).

- Owner's follow-up: `REANC` is the program-code reading (5th char = language), not the database one
  (5th = DB kind, `REANO`); it reaches the ui's deployment and the BFF's names, not the ui's files, and
  no repository — the Git chapter names repos its own way (`NHI3-intra-Frontend`). Port 8003 is a
  convention in the dotnet Dockerfile notes, adjustable by the text itself; bff corrected.

## Decisions & pitfalls
- Remapping citations needs the range's end remapped too (a first pass left `L61–63` as `L663–63`);
  every replacement was printed with both ends' source text before acceptance.
- The whole-document extract loses the four federation code screens (p52–55): PDFKit finds no text
  layer and OCR only runs when a whole file needs it. Those citations now point at the pictures.

## TODO
- Owner: confirm `REANC` with NHIA; ruling on ui file naming if NHIA disagrees with 肆; the architect
  on `zod`, `jest`, `supertest`; the shell team (plan federation-remote); the Keycloak discussion.
- Push `rea`.
