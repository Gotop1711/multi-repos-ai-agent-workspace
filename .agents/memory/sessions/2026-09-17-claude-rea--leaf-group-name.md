# 2026-09-17 | claude | rea | leaf-group-name

## Task
The owner's report: saving a rule module with more than one group fails. Screenshots of the request — `POST http://210.59.250.145:8081/api/v1/RuleSet` → `400`, `{Code: "201", Path: "Logic", Message: "Code 201 下有重複的群組名稱，每個 Leaf 的 Name 必須唯一"}`, with a two-leaf `Or` payload whose leaves carry `GroupName: testA` / `testB` and the same `Name: 限制申報科別`.

## Done
- Traced both sides. The kernel means the group name by a leaf's `Name` (`REA_kernel@876cd3d`: `StructureValidator` requires it non-blank and unique per `Code`; `RuleSetTranslator` suffixes the engine rule name with it); `RuleNode` has no `GroupName`, and the API discards unmapped members in silence. `REA_UI@411c809` sends the rule code's display name as `name` on every leaf (`addLeafMeta`) and the group name as `groupName`.
- Recorded as rule-editor › The leaf envelope, with the second consequence it explains: no group name has ever round-tripped, so a reload falls back to `群組N`.
- rea-kernel gained an "Ahead of `develop`" bullet — the deployment runs a feature branch, not `develop`.
- Filed `plans/leaf-group-name.md` (draft, `REA_UI (debug-ui)`): five steps, tests, and what the owner checks. No child write — unsigned.

## Decisions & pitfalls
- The error string matched nothing in the kernel worktree (`develop` at `2ff26b0`); `git grep` across all refs found it on `origin/16-feature-RuleSetTranslator-201`. When a live error has no source, search the refs before doubting the message.
- That the deployed API is at/after `876cd3d` is **inferred** from the message being unique to that commit — no production access was used, and the running build was not read.
- One group has always saved: a lone leaf's duplicated `Name` is trivially unique. The defect was invisible until a second group existed.
- The fix is forward-compatible in either direction: `develop` neither checks `Name` nor suffixes with it, so moving the group name into `Name` is safe if the deployment rolls back.
- Kept `GroupName` out of the plan's ask to the kernel: the carrier exists, so terms' "kernel is primary" makes this a ui-side move, not a request.

## TODO
- The plan awaits `Signed:`; nothing in `REA_UI` may change before it.
- Unasked, unexamined: whether rules already stored under the old shape (`Name` = display name) need a migration for the translator's `Rule_<code>_<name>` names, and whether the result parser reads `Properties["Name"]`.
