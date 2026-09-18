# 2026-09-18 | claude | rea | nhia-frontend-standard

## Task
Owner: ingest the NHIA web front-end development regulation — chapter 肆 of 「第三代醫療資訊系統建置案」
開發規範 V2.0, excerpted as pages 29–58 of the whole-HIS document.

## Done
- Ingested the PDF at product level (it governs the product, not one repository) as
  `sources/2026-09-18-nhia-his3-dev-standard-v2-web-frontend-p29-58.pdf.md` (`d806bd3a4ab8`).
- Its pages 24–27 are screenshots (router and vite configs) and extracted empty; split them out in
  scratch and ingested the part with `OCR=` forced as
  `sources/2026-09-18-nhia-his3-dev-standard-v2-federation-config-screens-p52-55.pdf.md` (`8ebd949dd61c`).
- New module nhia-frontend-standard: the rule, section by section, cited to both sources; linked in
  index.md. Compliance of `REA_UI` is not assessed — that is a task of its own.

## Decisions & pitfalls
- A non-ASCII title needs `NAME=`; the document's own date is not in the excerpt, so the name carries
  the ingest date.
- PDFKit returns a page's text layer only; a PDF whose text-per-page average is fine but with a few
  image pages needs the pages split and `OCR=` forced on the part — whole-file `OCR=` would replace good
  text with OCR noise. OCR of code screenshots is legible but noisy (`wue` for `vue`); the module says so.
- `prune` removes an uncited derivative: a source without a citing document does not survive.

## TODO
- Push: workspace `rea`.
- Next task, if the owner wants it: `REA_UI` against the mandatory list (BFF-only `/api`, Element Plus,
  Federation, `src/utils/validate.js`, `vDataType`, colours) — findings would be a plan.
