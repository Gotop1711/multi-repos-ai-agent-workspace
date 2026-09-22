# 2026-09-22 | claude | workspace | local-children

## Task
Owner: the manifest must be able to declare children that have no upstream — a folder imported as a
reference, or a project started from nothing here to implement a new service. An organization's log had
carried the defect as a `[workspace]` line: `remote` had to be a token, `clone` tried to clone it, and
`set-url` ran on a repository without `origin`.

## Done
- `remote: none` is the token. `clone`: present → reported as local; missing and `write` → `git init`
  on the default branch; missing and `read-only` → fail, naming `import`. `check` refuses `pr-only`.
- `import <REPO> <folder>`: copy minus `.git` / `.DS_Store`, init, one commit; credential-shaped files
  are named as a warning (the child's own, gitignored), never their values; refuses a non-empty path.
- `cite` prints `<REPO>@unborn` for a repository without commits; `restore` skips it with a message.
- AGENTS.md (intro paragraph), README, CHANGELOG, the manifest template's comment, help text.

## Decisions & pitfalls
- `clone` and `cite` read five fields from six-field lines, so `access` was `read-only|<product>` and
  the push lock never fired — found when the write child was not created in the sandbox. Fixed.
- The first commit of a new project is a plan's work, not `clone`'s: an empty repository is what the
  signature gate can cover, an initial commit would be a write nobody signed.
- `$hits—` (a variable followed by an em dash) is an unbound-variable error under bash 3.2: braces.
- `git grep --cached` after the pattern is read as a pathspec; flags go first.
- Tested in a scratch workspace with `write`, `read-only` and `pr-only` `none` entries plus a bare
  remote for the push lock. A sandbox's bare repository inside the tree trips the party check — expected.

## TODO
- A local child that later gains a remote has no `origin`: `clone` reports it present and never adds
  one; the owner adds the remote by hand. Worth a `clone` step if it recurs.
