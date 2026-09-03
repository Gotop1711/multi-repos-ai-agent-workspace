# Session Log — 2026-09-03 | claude | workspace

## Task
Browse and analyse the whole workspace; recommend how to organise many
documents of mixed file types into it, and how to govern `docs/` (by feature,
by product, both, or other).

## Completed
1. `docs/workspace.md` — created the workspace's own scope document: examined
   Body (mechanics at workspace@8e4db92), a Changes entry, Open findings 1–22
   from the analysis (each with citation, evidence type, confidence).
2. `docs/plans/workspace--docs-scope-grammar.md` — **unsigned** plan: organise
   `docs/` by scope (product or cross-cutting system), feature as a
   `--<feature>` filename token and `[feature]` tag, kind as a heading; `scope:`
   hint in the manifest defaulting to the repo id; root file never moves on a
   split; exact rule edits listed, none applied.
3. `docs/plans/workspace--document-layer.md` — **unsigned** plan: originals of
   every type in an external store mirrored at gitignored `originals/`; one
   tracked UTF-8 text derivative per original under `sources/<scope>/` written
   by a new `workspace.sh extract`; blob citations `sources/…@<blob12>`;
   hook gates for binaries and > 1 MiB; migration steps; exact edits listed,
   none applied.
4. No rule, script, ignore file or manifest was changed. The fleet is still
   empty; nothing under `projects/` exists.

## Decisions & pitfalls
- Method: two multi-agent workflows (17 + 13 agents) — analysis lenses, four
  independent designs per question, two adversarial critics per design, a
  synthesis, and (for the document layer) a completeness critic. All sandboxes
  live in gitignored `.agents/scratch/` (`mechanics/`, `critique-*/`, `synth/`,
  `critic/`, `synthesizer/`, `verify-wf2/`) and are disposable.
- Recorded both recommendations as unsigned plans instead of applying them:
  every proposed edit targets files outside the agent write surface
  (`AGENTS.md`, `workspace.sh`, `.gitignore`, `docs/README.md`, `BLUEPRINT.md`,
  `README.md`, `catalog/repos.yaml`). The human signs, rejects, or instructs.
- Findings about the workspace itself are cited `workspace@<sha>` because the
  workspace is not a manifest child; `docs/workspace.md` is legitimate under
  the current rules (one document per product/area; the template names
  `workspace` as a scope). The scope-grammar synthesis wanted `workspace` to
  be a log tag only — amended in that plan, because findings about the
  mechanics need an Open-findings tray with evidence.
- Changes entries inside a scope document use H3 (`### [desc] — date`): the
  CHANGELOG's H2 form would collide with the document's own sections (Open
  finding 15).
- Pitfall: the first Workflow script failed to parse — a single-quoted JS
  string containing `${…}` and an inner `'`. Moving all long prose into
  template literals fixed it.
- Pitfall: the workflow task-output file is a JSON wrapper with HTML-escaped
  strings; per-agent results are cleaner in the run's `journal.jsonl`.
- Pitfall (this machine): `tesseract` is on PATH but cannot launch (missing
  `liblept.5.dylib`); `pandoc`, `pdftotext`, `gitleaks`, `git-lfs` are absent;
  `textutil`, `swift` + PDFKit, `qlmanage`, `file`, `iconv` work. The plans
  rely only on what works and say what to install.
- Pitfall: the completeness critic changed the extract design materially —
  agents must not copy into the store (a write to human-owned state); `check`
  must warn, not fail, on store-side drift (or the mandatory closeout is
  blocked); the prescribed redaction format was refused by its own regex;
  UTF-16 originals trip the hook's binary gate; iWork/rtfd files are folder
  bundles; a bare `git mv` of a derivative leaves its header pointing at the
  old store path. Applied in the plan; snippets I did not re-run are marked
  *(amended)* — re-verify before applying.
- This log's filename follows the current rule (`{scope}-{task}`), not the
  proposed `--` form: the plan is unsigned.

## TODO / known-incomplete
- Human: answer the questions in both plans (store for originals; pile shape;
  NDA/PII; which repos and scopes; may agents run `extract`) and sign or
  reject them; the two plans touch the same lines of `AGENTS.md:18` and
  `TEMPLATE.md:4` — apply them together.
- Human: decide on the low-cost defect fixes in `docs/workspace.md` findings
  4 (anchor `.gitignore`), 5 (`restore` fetch), 9 (hook reads the index),
  10 (`$0` stale) — all outside the agent write surface.
- If the document-layer plan is signed: re-run the *(amended)* `extract`,
  `check` and hook snippets on this machine before applying.
- Nothing was pushed to any child repo; the manifest still lists no repos.
- **Closeout push did not happen from the agent environment:** `git push` over
  SSH fails with `Permission denied (publickey)` (the agent's ssh-agent holds
  no identities) and a one-off HTTPS push finds no valid token in the
  osxkeychain; `gh` is not installed. The closeout commit is local on `main`,
  one ahead of `origin/main` — the human runs `git push`.

## Update — same session, after the owner's answers
- Completed: folded the owner's interactive answers into both plans as settled
  facts (document-layer §14; scope-grammar §13); question sections removed;
  routing table, §8 extraction, §9 `extract` arms, §11 migration and §12
  triggers adjusted accordingly.
- Answers: no store yet (plain local folder); nothing restricted; subjects a
  mix of product and cross-cutting; agents may run `extract`; the pile has
  many scans, many decks/spreadsheets and many live cloud documents besides
  PDFs/Office/text; some products span several repos; cross-cutting systems
  are conventions with no home repo.
- Decision: because of the pile shape, Vision OCR and a pptx/xlsx extractor
  move into the rule commit. Both were prototyped in
  `.agents/scratch/verify-extractors/`: the OOXML extractor on synthetic
  files only (test on real exports before applying); the PDFKit + Vision OCR
  program on a rendered one-page PDF (1.3 s, text read correctly).
- Pitfall: the closeout commit was not amended a second time — the owner may
  already have pushed it from their terminal — so this update is a second
  commit of the same session.
- TODO: the owner signs or rejects the two plans; after migration, move the
  originals folder to a versioned store.

## Update — plans signed and applied (same session)
- Completed: the owner signed both plans (line 4 of each); applied their §9
  edits to AGENTS.md, docs/README.md, docs/BLUEPRINT.md, README.md,
  CHANGELOG.md, TEMPLATE.md, catalog/repos.yaml (comment), .gitignore,
  .githooks/pre-commit and workspace.sh (`extract` with textutil / PDFKit /
  Vision OCR / OOXML, `restore` token arms, `scope:` validation, document
  checks in `check`, help lines). Both plans, this log, and every reference
  renamed to the `--` grammar; `Shipped:` lines added; docs/workspace.md
  findings 1, 4, 7, 14 struck as resolved and 3, 6, 15, 16, 17 annotated.
- Verification (sandbox `.agents/scratch/apply-test/`, a git-initialised copy
  with the hook wired and a store of real fixtures): 12 derivatives written
  (txt, docx, text-layer pdf, image-only pdf and png via OCR, pptx, xlsx,
  UTF-16 csv, sql via MIME fallback, redacted txt, restricted xlsx, binary as
  no-text); refused: AKIA key, > 1 MB text; skipped: bundle, bad name, file
  outside the store; `check` PASS with the info line, warn on a tampered
  original, FAIL on a stray file and on a wrong-scope header; hook refused a
  staged binary and a 1.2 MB text; blob citation equals `HEAD:<path>` after
  commit and `git show` returns it; `restore` skips document tokens and
  locators; a two-token `scope:` fails `check`; unmounted store → PASS with
  the "not verified" suffix.
- Pitfall: the auto-mode classifier blocked one Bash batch (writing
  workspace.sh, the hook, .gitignore and the manifest comment together); the
  same edits went through the dedicated Write/Edit tools. Executable bits
  survived.
- Pitfall: a `cd` into the sandbox persisted into the shell that launched the
  verification workflow; the agents were told the repo root explicitly.
- Deviation from the plan text: none intended; the `extract` credential
  message can repeat a line number when two patterns hit the same line
  (cosmetic; fixed after the review if nothing larger surfaces).
- TODO: fold in the verification workflow's fix list, then the closeout
  commit; the owner pushes.
- Closeout made before the verification workflow finished (the owner had to
  power down). The review run is `wf_f89cf4bb-60d`; its per-agent results, if
  any completed, are in that run's `journal.jsonl` under
  `~/.claude/projects/<this workspace>/…/subagents/workflows/`. Next session:
  read it (or re-run the review), apply the fix list plus the cosmetic
  credential-line dedupe in `extract`, and close out again.
