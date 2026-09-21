# 2026-09-21 | claude | rea | rea-proto-be-child

## Task
Owner: create a new child `REA_PROTO_BE`, which has no git history, by copying the folder
`NhiDeclareVerifyProject-main 2/nhi_declare_verify/NhiDeclareVerify` (a zip download) into `projects/`.

## Done
- Copied to `projects/rea_proto_be` (148 files, 11 MB, mostly `SeedData/`; `.DS_Store` left out);
  `diff -rq` against the source: identical. The `.sln` one level up was not part of the named folder.
- Manifest entry `REA_PROTO_BE`: `remote: none` (placeholder — there is no upstream),
  `default_branch: main`, `access: read-only`, `product: rea`.
- On the owner's word in session: `git init -b main` in the child, the zip root's .NET `.gitignore`
  added, one local import commit — `REA_PROTO_BE@ba161ff`. No remote, nothing pushed.
- `check` PASS (4 repos); `cite` prints the four-repo line again.

## Decisions & pitfalls
- A manifest child without `.git` and a commit breaks `cite` for the whole fleet ("not cloned",
  exit 1) and leaves nothing to cite as `<repo>@<sha>`. That is why the child got one commit; asked
  first, since a commit in a child is not a standing authorization.
- `remote` cannot be empty (`check` fails an incomplete entry), hence the `none` token and the
  comment above the entry. `./workspace.sh clone` on a fresh machine cannot rebuild this child — the
  copy on this disk and the original zip are its only sources.
- Screened before committing: `appsettings.json` holds `ConnectionStrings` / `MongoDbSettings`
  keys; no password-shaped value found in `*.json`, `*.cs` or the `Dockerfile`.
- No repository doc written: nothing about the child has been analysed yet, and an empty template
  is not a fact.

## TODO
- `./workspace.sh doc add rea rea-proto-be` once the child is read (runtime, entry points, APIs,
  storage — .NET, Mongo and Oracle settings are visible in `appsettings.json`), and link what it is
  to `REA_PROTO` with file-level evidence — the shared name proves nothing.
- [workspace] the manifest has no way to declare a child that has no remote: `remote` must be a
  non-empty token, `clone` then tries to clone it, and for a `read-only` entry runs
  `remote set-url --push origin` on a repository that has no `origin`.
- Earlier open items stand. Push `rea`.
