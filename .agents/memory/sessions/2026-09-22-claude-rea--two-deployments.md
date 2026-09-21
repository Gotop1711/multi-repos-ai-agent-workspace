# 2026-09-22 | claude | rea | two-deployments

## Task
Owner: `rea` is rebased onto `main`; and ui-deployment records a deployment to a space outside NHIA,
to be kept apart from the NHIA 三代 regulation.

## Done
- After the rebase, re-ran the now-native `extract` on the whole regulation: zero files changed, blob
  `b3e81e38baa5` again. The earlier run with the borrowed script was the regular output.
- The separation is stated on both sides: bff › What the ui does today, plan bff step 4 (the file it
  edits belongs to the off-premises deployment; an NHIA deployment generates its own nginx),
  nhia-frontend-standard › Architecture, and one scope sentence at the top of ui-deployment.

## Decisions & pitfalls
- I had read the ui's `frontend.conf` and `Dockerfile` as "how REA is deployed" and measured them
  against NHIA's template. They answer to a different environment. The regulation's rules on code and
  config still bind the repository; its deployment templates bind only the NHIA target.
- ui-deployment is another task's module: added the owner's scope sentence only, nothing else.

## TODO
- rea-ui › Deployment names a host and a build; whether that is the same off-premises space is the
  owner's to confirm. Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea`.
