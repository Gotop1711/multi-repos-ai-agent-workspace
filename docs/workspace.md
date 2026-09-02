# workspace — the governance repository itself

Scope document for this repository (rules, memory, docs, one script), kept
under the rules of `docs/README.md`. The workspace is not a manifest child, so
citations here are `workspace@<sha>` — this repository's own HEAD at the
moment of observation — plus file:line and symbol.

## Body

### Purpose & framing

One governance repository that lets AI agents work across many independently
managed child code repositories: gitignored clones under `projects/`, a fleet
manifest with per-repo access levels, agent-written memory and documentation,
and evidence on every claim. Rationale in `BLUEPRINT.md`; rulebook in
`AGENTS.md`; mechanics in `workspace.sh`.

### Current architecture (examined at workspace@8e4db92)

- Eleven tracked files: `README.md`, `AGENTS.md`, `CLAUDE.md`, `CHANGELOG.md`,
  `.gitignore`, `workspace.sh`, `.githooks/pre-commit`, `catalog/repos.yaml`,
  `docs/README.md`, `docs/BLUEPRINT.md`, `.agents/memory/sessions/TEMPLATE.md`
  — workspace@8e4db92 `git ls-files`; direct (executed); high.
- The manifest is parsed by an awk state machine over `- id:` blocks —
  workspace@8e4db92 `workspace.sh:14-24` `entries()`; direct (read); high.
- `clone` rebuilds the fleet and sets a `read-only` repo's push URL to
  `DISALLOWED_READ_ONLY`, re-enabling it when access is upgraded —
  `workspace.sh:49-72`, `:63-69`; direct (read), corroborated by a sandbox run
  in `.agents/scratch/mechanics/`; high.
- `cite` prints the fleet as one `id@sha` line in manifest order and warns on
  stderr for dirty children — `workspace.sh:74-86`; direct (read); high.
- `restore` splits an unquoted `$*` on purpose so a pasted line is one
  argument, refuses dirty children, detaches at a sha or returns to the
  manifest branch — `workspace.sh:88-118`, `:97-99`; direct (read); high.
- `check` validates manifest completeness, access values, indentation and
  single-token values, then prints the newest session log — `workspace.sh:120-145`;
  direct (executed: `check: PASS (0 repo(s) in manifest)`); high.
- The pre-commit hook runs `check` and, only if installed, `gitleaks` —
  `.githooks/pre-commit:5-8`; direct (read); high.
- The agent write surface is session logs, `docs/`, `CHANGELOG.md` and
  gitignored `.agents/scratch/` — `AGENTS.md:42-45`; a child write needs a
  `Signed:` line in a plan — `docs/README.md:48-54`; direct (read); high.
- A tracked file's git blob is a stable content identity:
  `git hash-object AGENTS.md` equals `git rev-parse HEAD:AGENTS.md`
  (`a9f8876…`) — direct (executed); high. Basis for citing any tracked file by
  blob without new machinery.

## Changes

### [Create the scope document; record the 2026-09-03 analysis] — 2026-09-03

#### Added
- This document, with Open findings 1–22 from the 2026-09-03 analysis session
  (log `2026-09-03-claude-workspace-analyze-and-document-layout.md`).
- Two **unsigned** plans in discussion state:
  `docs/plans/workspace-docs-scope-grammar.md` (how `docs/` is organised) and
  `docs/plans/workspace-document-layer.md` (where human-supplied documents of
  mixed file types go). No rule, script or ignore file was changed.

## Open findings

All observed at workspace@8e4db92. Entry format: claim — citation; evidence
type; confidence; Q: unresolved questions. "direct (executed)" = re-run on this
machine in this session; "direct (read)" = established from the cited lines;
"corroborated" = a sandbox run by a subagent in `.agents/scratch/` plus reading.

### 1. Human-supplied documents have no sanctioned home and no citation form
`docs/` admits only agent-written scope documents and plans; `projects/` is
clones only; `.agents/scratch/` is disposable; the write surface has no inputs
location; every finding must cite a `<repo>@<sha>` read from `projects/`; §4
has no trigger for source material and §5 rejects per-scope
background/specification folders — `docs/README.md:4-10`, `AGENTS.md:4-5`,
`AGENTS.md:42-45`, `AGENTS.md:55-56`, `docs/BLUEPRINT.md:22-25`, `:139`;
direct (read); high. Q: which external store will hold originals; whether any
material is NDA/PII-bound even as text. → plan `workspace-document-layer`.

### 2. An empty fleet cannot produce a rule-compliant finding
`cite` exits 1 when the manifest has no repos while `check` only warns, so a
documents-first workspace has no citation source at all — `workspace.sh:76`,
`:140`; direct (executed `check`, read `cite`); high.

### 3. No secret, size or binary guard reaches the tracked tree on this machine
The hook validates the manifest and calls `gitleaks` only if present; it is
absent here and `setup` never says so; history is never rewritten and every
closeout pushes, so a credential or large binary committed once is permanent —
`.githooks/pre-commit:5-8`, `CHANGELOG.md:3`, `docs/README.md:58`,
`README.md:28-29`; direct (read; `command -v gitleaks` empty); high. A 10 MB
PDF commits through the hook — corroborated; high. Q: whether
`gitleaks protect --staged` is still the current command form — unverified; low.

### 4. `.gitignore` silently swallows legitimate document names
`docs/deck.key` (`:10 *.key`), `docs/credentials-policy.pdf` (`:11 credentials*`),
`docs/.env-setup.md` (`:8 .env*`), `docs/projects/x.md` and
`docs/vendor/projects/x.pdf` (`:2 projects/`, unanchored) are all ignored with
no error; `.agents/scratch/` (`:5`) is likewise unanchored — `.gitignore:2-11`;
direct (executed `git check-ignore -v`); high. Fix: anchor `/projects/` and
`/.agents/scratch/`; any documents layout must avoid these names.

### 5. `restore` never fetches
A sha that exists upstream but not in the local clone fails as "history
rewritten upstream?" because checkout's stderr is discarded — the normal
second-machine case, so acceptance item 3 fails routinely with a misleading
diagnosis — `workspace.sh:108-111`, `docs/BLUEPRINT.md:155-157`; direct (read),
corroborated; high. Fix: `git -C "$path" fetch --quiet origin` before the checkout.

### 6. The citation-plus-file format is unspecified and breaks `restore`
`./workspace.sh restore 'docs/x.pdf.md@abc123 p.3'` prints `[docs/x.pdf.md] not
in the manifest`, `[p.3] not in the manifest`, rc=1; the rules prescribe
"`<repo>@<sha>` + file + symbol" with no separator, so a real finding line does
not paste cleanly — `AGENTS.md:55-57`, `:67-69`, `docs/README.md:20`,
`workspace.sh:99-103`; direct (executed); high. `AGENTS.md:56` also hardcodes
`projects/<repo>` while `path:` is free-form — `catalog/repos.yaml:11`,
`workspace.sh:18`; direct (read); high.

### 7. "Automatically written" session logs are an overclaim
`README.md:12`, `AGENTS.md:8-9` and `docs/BLUEPRINT.md:38` say logs are written
automatically; `AGENTS.md:21-25` and `TEMPLATE.md:4` have the agent write them
by hand; `check` only prints the newest log name — `workspace.sh:141-142`. The
workspace's own most important red line (`AGENTS.md:51`) is enforced by
nothing, against `docs/BLUEPRINT.md:59-60`; direct (read); high.

### 8. The write surface contradicts the growth path, the CHANGELOG mandate and catalog editing
`AGENTS.md:42-45` fixes the surface; `docs/BLUEPRINT.md:108-123` and
`README.md:52-59` tell agents to add `.agents/skills/`, `schemas/`,
`policies/`, `catalog/*.yaml`, `labs/`, `reports/` (all outside it);
`AGENTS.md:28` sends workspace-level changes to the CHANGELOG though the only
such change an agent may make is adding docs files; `catalog/repos.yaml` is
outside the surface yet nothing says it is human-only (`README.md:24`,
`docs/BLUEPRINT.md:77`); `docs/README.md` and `docs/BLUEPRINT.md` — the
governance texts (`docs/README.md:42-43`) — are agent-writable while
`AGENTS.md` is not; direct (read); medium (interpretation). Q: is the intended
rule "an agent may extend the surface only when told to"?

### 9. The pre-commit hook validates the working tree, not the index
Admitted at `.githooks/pre-commit:3-4`: a broken manifest can be committed
(staged bad, worktree fixed) and a clean commit can be blocked; corroborated;
high. Fix: check `git show :catalog/repos.yaml`.

### 10. `$0` goes stale after `cd "$(dirname "$0")"`
`cd docs && ../workspace.sh help` prints `sed: ../workspace.sh: No such file or
directory` with rc=0; `setup`'s inner `bash "$0" check` silently never runs from
a subdirectory; symlinked invocation reports the manifest missing —
`workspace.sh:10`, `:36`, `:148`, `:152`; direct (executed); high.

### 11. `check` validates neither path containment, id/path uniqueness nor quoting
`path: ../escape` clones outside the workspace; duplicate ids pass while
`clone` applies each entry and `restore` resolves the first; `default_branch:
"main"` passes `check` and fails `clone`; CRLF manifests fail with a
self-contradicting message — `workspace.sh:120-139`, `:58-60`, `:101-102`;
corroborated; medium.

### 12. `restore` accepts option-like or rev-ish tokens as shas
`child@-q` reports success; `child@HEAD~1` is echoed as if a sha —
`workspace.sh:100`, `:109`; corroborated; medium. Fix:
`git rev-parse --verify --quiet "$sha^{commit}"`.

### 13. Read-only enforcement covers only origin's push URL
`git push <url> main` and an added remote push fine — `workspace.sh:63-65`;
direct (read); high. `docs/BLUEPRINT.md:27-29` "fail mechanically" holds only
for the common path. Q: acceptable by design, or worth a note in AGENTS.md?

### 14. Session-log filenames can collide and their fields are undefined
`YYYY-MM-DD-{agent}-{scope}-{task}.md` has no sequence component, so two
same-day sessions with the same task overwrite each other against
`docs/README.md:58`; `{scope}` is "product code or workspace" (`TEMPLATE.md:4`)
vs "product/area" (`docs/README.md:8`); `{task}` has no slug rules —
`AGENTS.md:22`, `TEMPLATE.md:3-4`; direct (read); medium. → plan
`workspace-docs-scope-grammar` (`<scope>--<task>`).

### 15. No template or heading contract for `docs/<scope>.md`
`docs/README.md:14-24` names three parts but no headings; the Changes entry
format reuses the CHANGELOG's H2 (`docs/README.md:18`, `CHANGELOG.md:4`),
colliding with the document's own H2 sections; `AGENTS.md:18` has no branch
for "does not exist yet"; direct (read); medium. This document uses H3 entries
under `## Changes` and the skeleton proposed in the scope-grammar plan.

### 16. Git-authorization wording over-forbids read-only git here and omits pull/fetch
`AGENTS.md:29-35` sanctions read-only git only in children; taken literally
`git status`/`log`/`hash-object` in this repo need permission, and a second
machine's closeout push has no authorised remedy for a non-fast-forward
(`docs/BLUEPRINT.md:160-166`); direct (read); medium (interpretation).

### 17. CHANGELOG says "append-only" but is newest-first; README table is incomplete
`CHANGELOG.md:3` vs `:6`, `:20`; the initial release has no entry; the README
file table (`README.md:41-50`) omits `README.md`, `CHANGELOG.md`, `.gitignore`
and `docs/README.md` while `README.md:55` points readers at the CHANGELOG;
direct (read); high.

### 18. `pr-only` is undefined and mechanically identical to `write`
`workspace.sh:63-69` treats only `read-only` specially; `AGENTS.md:6` names
`pr-only` without defining it; "read-only by default" (`AGENTS.md:5`) has no
manifest default — `check` fails on an empty access (`workspace.sh:126-127`);
direct (read); high.

### 19. Vendor-neutrality gaps
Only a Claude bridge ships (`CLAUDE.md:1`) though `docs/BLUEPRINT.md:35-36`
says bridges are created only for installed runtimes; `.gitignore:12-13`
ignores only Claude-local state, not `.codex/`, `.gemini/`, `.cursor/`; direct
(read); low.

### 20. Dirty or detached children are a dead end for agents
Agents may not clean a child (`AGENTS.md:45`, `:30-32`) and `check` inspects
neither detached HEAD nor dirtiness (`workspace.sh:120-145`), so a session
after a `restore` may analyse a stale checkout unknowingly; `cite` prints
detached shas without a hint; direct (read); medium.

### 21. `cite` aborts on the first missing clone while `restore` continues
`workspace.sh:80` vs `:103-104`; a child whose `.git` is a file (worktree) is
treated as not cloned — `:58`, `:80`; direct (read), corroborated; low.

### 22. Ambiguities and terminology drift
"never overwrite" (`docs/README.md:58-59`) vs "documentation is maintained"
(`docs/BLUEPRINT.md:44`) for body paragraphs; the signature gate is social and
em-dash sensitive (`docs/README.md:52`); "docs system"/"knowledge system",
"session logs"/"journey logs"/"journals", "product"/"product code"/"product/area"
are used interchangeably; direct (read); low.
