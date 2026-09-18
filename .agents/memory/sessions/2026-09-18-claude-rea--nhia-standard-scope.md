# 2026-09-18 | claude | rea | nhia-standard-scope

## Task
Owner: before reviewing `REA_UI` against the NHIA regulation, list which other chapters of the full
開發規範 V2.0 are needed (from the table-of-contents screenshots), and decide: excerpts or the whole.

## Done
- nhia-frontend-standard › The whole regulation: the parts needed (8 plus 2 of unknown location),
  the parts for context (4), and what is not needed, each with why.
- Recommendation to the owner: hand over the whole document; the agent splits out and ingests only the
  needed parts, as with the config-screens part.

## Decisions & pitfalls
- The table of contents is stale: its page numbers drift 5 to 8 from the printed ones inside 肆 alone,
  so excerpting by it would cut pages wrong. Headings locate a part; page numbers do not.
- 肆 points to two things with no named chapter (程式庫白名單, 命名原則): only a search of the whole
  document finds them.
- The TOC screenshots are not ingested (chat attachments); the module says so.

## TODO
- Owner: the whole document's path. Then split, ingest the needed parts, and start the review.
- Push `rea`.
