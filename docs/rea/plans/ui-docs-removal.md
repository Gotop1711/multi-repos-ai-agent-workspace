# rea — ui-docs-removal

Status: draft

## Goal
`REA_UI` carries no `docs/` directory, so neither an agent nor a developer reads a hand-written
analysis that the code has since moved past. At `REA_UI@5721638` the directory holds `analysis/`
(a README and one 2026-08-27 analysis of 參考欄位) and `deployment/` (`docker.md`, `research.md`,
`research-essence.md`). The analysis has already drifted: it cites `ruleSchemaUtils.js:200-209` for
`referenceFields`, which now sits at `:204`, and fifteen commits under `src/utils/rule` and
`src/views/rules` have landed since it was written (`git log f600cb0..5721638`). `docker.md` still
holds and now lives, re-checked and extended, in ui-deployment. The two `research*` files are a
general survey of AI agents in infrastructure work with no fact about this repository. When this
ships, the only references to `docs/` in the repository (`README.md:121-122`, `.dockerignore:3`)
are gone too.

## Writes
`REA_UI (develop)`, the branch the owner checked out for this on 2026-09-21 (`5721638`, equal to
`debug-ui`). A push to `develop` runs build → deploy → smoke on the dev host (ui-deployment › The
pipeline); a docs-only commit redeploys an unchanged app. To go through a merge request instead, the
owner names a `debug-*` branch at signing.

## Steps
1. One commit, `docs: remove docs/ — the deployment facts moved to the workspace`:
   - `git rm -r docs/`;
   - `README.md:121-122`: delete the blockquote that points to the analysis file; the paragraph
     above it (`README.md:119`) already states both pitfalls the pointer promised;
   - `.dockerignore:3`: delete `docs/`, which no longer exists.
2. `git grep -n -e "docs/" -e "analysis/" -e "docker.md" -e "research"` finds nothing outside
   `node_modules` and `package-lock.json`. No code changes, so lint, tests and the image are
   unaffected; `docker build` is not needed, since `docs/` never entered the build context.
3. Record `Shipped:` with the commit; the push and the merge request are the owner's.

## Done when
The owner sees on the branch: no `docs/` directory; no line in `README.md` or `.dockerignore`
names it; and ui-deployment in the workspace answers what `docker.md` used to.
