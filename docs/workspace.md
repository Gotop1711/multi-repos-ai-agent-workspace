# workspace — the governance repository itself

History: `git log --oneline -- docs/workspace.md` · sessions: `ls .agents/memory/sessions | grep -- '-workspace--'` · workspace releases: `../CHANGELOG.md`

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

### Specifications (moved from `docs/plans/` on 2026-09-03)

- → see `workspace/document-layer.md` — how human-supplied documents enter the
  workspace: the store, `ingest` / `extract`, derivatives, blob citations.
- → see `workspace/scope-grammar.md` — how `docs/` is organised: scopes,
  features, plans, session-log names.

## Open findings

Observed at workspace@8e4db92 unless a finding says otherwise. Ids are never reused — 1, 4 and 7 were resolved on 2026-09-03 and deleted on 2026-09-04 (`git log -S`). Entry format: claim — citation; evidence
type; confidence; Q: unresolved questions. "direct (executed)" = re-run on this
machine in this session; "direct (read)" = established from the cited lines;
"corroborated" = a sandbox run by a subagent in `.agents/scratch/` plus reading.

### 2. An empty fleet cannot produce a rule-compliant finding
`cite` exits 1 when the manifest has no repos while `check` only warns, so a
documents-first workspace has no citation source at all — `workspace.sh:76`,
`:140`; direct (executed `check`, read `cite`); high.

### 3. `gitleaks` is absent here and nothing says so
The hook calls `gitleaks` only if present and `setup` never reports its
absence, so the secret gate is `extract`'s grep alone on this machine —
`.githooks/pre-commit`, `workspace.sh` › setup; direct (read;
`command -v gitleaks` empty); high. Q: is `gitleaks protect --staged` still the
current command form — unverified; low.
### 5. `restore` never fetches
A sha that exists upstream but not in the local clone fails as "history
rewritten upstream?" because checkout's stderr is discarded — the normal
second-machine case, so acceptance item 3 fails routinely with a misleading
diagnosis — `workspace.sh:108-111`, `docs/BLUEPRINT.md:155-157`; direct (read),
corroborated; high. Fix: `git -C "$path" fetch --quiet origin` before the checkout.

### 6. A bare symbol token on a pasted finding line still trips `restore`; AGENTS.md hardcodes `projects/<repo>`
`restore` skips `sources/…@…`, `p.N`, `L<n>` and path tokens, but a bare
symbol (`recompute`) still reports "not in the manifest" and sets rc=1 —
`workspace.sh` › restore; direct (executed); medium. `AGENTS.md` › Evidence
says `projects/<repo>` while `path:` in the manifest is free-form; direct
(read); low.
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

### 14. Same-day session logs with an identical task slug overwrite each other
`YYYY-MM-DD-{agent}-{scope}--{task}.md` has no sequence component
(`AGENTS.md` › Every session 5, `TEMPLATE.md`); two sessions on one day with
the same scope and task slug write the same file; direct (read); low.
### 15. The scope-document skeleton lives in the specification, not the README; no "does not exist yet" branch
`docs/README.md` names the two parts; the recommended headings are only in
`docs/workspace/scope-grammar.md` §5; `AGENTS.md` › Every session 3 says "read
`docs/<scope>.md`" with no branch for a scope whose document does not exist
yet (`docs/README.md` › Scopes says the agent creates it); direct (read); low.
### 16. No authorised remedy for a non-fast-forward closeout push from a second machine
`AGENTS.md` sanctions read-only git here and the closeout push, but not the
`fetch`/`pull`/rebase a second machine needs when another one pushed first
(`docs/BLUEPRINT.md` › private remote); direct (read); medium (interpretation).
### 17. `CHANGELOG.md` says "append-only" while its entries are newest-first
`CHANGELOG.md:3` vs the order of every entry below it; direct (read); low.
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
The signature gate is social and em-dash sensitive (`docs/README.md` › The
signature gate); "docs system"/"knowledge system", "session logs"/"journey
logs"/"journals", "product"/"product code"/"product/area" are used
interchangeably; direct (read); low.