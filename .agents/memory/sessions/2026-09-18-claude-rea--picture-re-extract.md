# 2026-09-18 | claude | rea | picture-re-extract

## Task
Owner: after rebasing `rea` onto `main` (picture derivatives), re-extract the stored originals so the
sources gain their pictures.

## Done
- Re-extracted the six image-bearing originals: the regulation PDF with `IMAGES=…:14-21` (the mock-up
  pages carry text too), the config-screens part with `OCR=` again, the four 306 screenshots. 21
  pictures, largest 152 KiB; the two JSON captures were left alone (no pictures, unchanged text).
- Every re-extracted derivative gained one header line (`pictures:`), so every `L<n>` into them moved
  by one and every blob changed: nhia-frontend-standard's `S`/`C` citations bumped and re-blobbed,
  spot-checked at two lines; rule-codes' four 306 blobs replaced (it cites no lines).

## Decisions & pitfalls
- A re-extract that adds a header line shifts every line citation into that source — bump them in the
  same commit, or a citation lands one line off. The extract command prints the new blob; the old one
  still resolves through `git show`.
- `IMAGES=` is per file: one extract call per file that needs it.

## TODO
- Push `rea` (owner's shell).
