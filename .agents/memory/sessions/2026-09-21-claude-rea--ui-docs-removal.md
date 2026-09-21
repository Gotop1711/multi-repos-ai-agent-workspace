# 2026-09-21 | claude | rea | ui-docs-removal

## Task
Owner: `REA_UI`'s `docs/` goes stale and misleads. Remove `docs/analysis/` and whatever references
it; check whether `docs/deployment/` is still current and move its content into the workspace; then
remove the whole `docs/` directory.

## Done
- Judged at `REA_UI@5721638` (`develop` = `debug-ui` = `debug-api`, one `docs/` tree on all three).
  The analysis has drifted (a cited line moved 200 → 204; 15 code commits since). `docker.md` still
  holds line by line. The two `research*` files are a generic AI-DevOps survey with no repo facts.
- `doc add rea ui-deployment`: image, nginx routes, build modes, the pipeline, the manual image
  check, all re-cited; plus what `docker.md` lacked (dev proxy, `VITE_APP_ENV` meta, console drop,
  CI builds production mode, no production deploy job, the Payment route is untested locally).
- `plan new rea ui-docs-removal`: `git rm -r docs/`, `README.md:121-122`, `.dockerignore:3`.
  Draft, Writes `REA_UI (develop)`, because the owner checked out `develop` during the session.
- Owner signed (Writes `REA_UI (develop)`). Shipped `REA_UI@a024004` on `develop`: `docs/` removed
  (5 files), `README.md`'s analysis pointer and `.dockerignore`'s `docs/` line dropped; the plan's
  `git grep` finds nothing. Not pushed.

## Decisions & pitfalls
- Nothing was written to `REA_UI` until the owner's `Signed:` line; the commit touches only the write set.
- The module's `.dockerignore` citation moved to `a024004`, the file it describes changed there.
- The research files were not carried over: nothing in them is a fact about this fleet.
- `b0cd679`'s subject says the console is dropped "only in production builds"; the code drops it on
  any `vite build`. The module records the code's behaviour, not the commit message's.
- Only two files reference `docs/`: `README.md` and `.dockerignore`. Checked with `git grep`.

## TODO
- Owner: push `REA_UI` `develop` (runs build → deploy → smoke), then `Verified:` on ui-docs-removal.
- Push `rea` (owner's shell).
