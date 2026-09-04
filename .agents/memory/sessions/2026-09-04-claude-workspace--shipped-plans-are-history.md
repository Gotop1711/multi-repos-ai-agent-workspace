# Session Log — 2026-09-04 | claude | workspace

## Task
Owner chose option B of the three I put to them: a plan's blob citations keep
a document alive only until the plan carries `Shipped:` or `Abandoned:`.
Infrastructure → `main`, then rebase `rea`.

## Completed
1. `workspace.sh check` — the unreferenced-derivative scan now drops any
   referencing file under `docs/plans/` whose first column matches
   `^(Shipped|Abandoned):`.
2. `docs/README.md` writing rule — "needed" is now defined against a *live*
   document (scope document, specification, or an unshipped plan), with the
   reason: a shipped plan's knowledge has dissolved into the Body.
3. `docs/workspace/document-layer.md` §15 amendment; `CHANGELOG.md` entry
   (Changed + Fixed).
4. Sandbox `.agents/scratch/ocr-langs-test/`, seven cases: unsigned plan
   cites → kept; the same plan `Shipped:` → listed; `Abandoned:` → listed;
   shipped plan + a scope-document citation → kept; nobody cites → listed;
   `check` PASS throughout; the count line matches. Real script patched by
   the same script and asserted byte-identical to the tested copy.

## Decisions & pitfalls        ← the valuable part
- **bash 3.2: a `case` pattern's `)` closes the enclosing `$( … )`.** My
  first filter used `case "$d" in docs/plans/*) … esac` inside the
  `unref="$( … )"` substitution. macOS ships bash 3.2.57, which the document
  layer §1 commits to supporting, and it mis-parses that: `check` printed
  `command substitution: syntax error near unexpected token 'newline'`
  followed by `d: unbound variable`, and every sandbox case silently
  reported 0. The tell was that *all* cases returned 0, including the ones
  that should have listed — a uniform result is a broken harness, not a
  finding. Replaced with a `${d#docs/plans/}` prefix test; recorded in the
  amendment so nobody reintroduces it. (`(pattern)` with a leading paren
  also works, but the prefix test needs no folklore.)
- **Why the rule is right, in one line:** history must not pin documents the
  living documentation no longer needs — the same reason session logs never
  counted. The plan's own citations still resolve through `git show`, so
  nothing about the record of *why* a change was authorised is lost.
- **Why not option C (plans never count):** an unsigned plan under
  discussion genuinely needs its evidence at hand; sweeping it mid-discussion
  would be the destructive failure. B moves the boundary to the moment the
  plan stops being live, which is exactly what `Shipped:`/`Abandoned:` mark.
- Checked, not assumed: the two other `case` statements in `ingest`
  (`workspace.sh:279-280`) sit in a `for` loop, not inside a substitution —
  no hazard, and they have run all day.
- No-op on today's workspace: `rea` has no derivatives at all since the 303
  screenshots were removed. The rule was fixed before a case exists, which is
  the cheapest moment.

## TODO / known-incomplete
- Rebase `rea` onto this commit (CHANGELOG conflict expected, main-first).
- Plan `rea--303-ui-map` is `Shipped:`; if the owner ever ingests the §4.2
  captures they must be cited from `docs/rea.md`, not from the plan, or the
  next closeout will list them. The plan's §4.2 note already says not to
  ingest.
- Carried over: Open finding 8, `origin/nabu-dashboard`, SSH for github.com.
