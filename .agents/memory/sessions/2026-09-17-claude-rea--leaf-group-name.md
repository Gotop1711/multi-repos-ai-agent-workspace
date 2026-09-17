# 2026-09-17 | claude | rea | leaf-group-name

## Task
The owner's report: saving a rule module with more than one group fails. Screenshots of the request — `POST …/api/v1/RuleSet` → `400`, "Code 201 下有重複的群組名稱，每個 Leaf 的 Name 必須唯一", two leaves carrying `GroupName testA/testB` and one shared `Name`. Then: does the kernel store the group name for later use?

## Done
- Traced both sides; recorded as rule-editor › The leaf envelope. Filed `plans/leaf-group-name.md` (draft, `REA_UI (debug-ui)`). No child write — unsigned.
- The owner merged the rule into the kernel's `develop` mid-session; re-cited rea-kernel at `458e663` and dropped the now-wrong "ahead of `develop`" note.
- Answered the storage question in rea-kernel: `Name` is stored twice, `GroupName` in neither, nothing reads either back yet.
- That trace found a contradiction inside the kernel (every leaf must be named → the translator always suffixes → its own result parser rejects suffixed names). Filed `plans/translated-rule-names.md` (draft, a request; writes nothing).

## Decisions & pitfalls
- The error string matched nothing in the kernel worktree; `git grep` across all refs found it on a feature branch. When a live error has no source, search the refs before doubting the message.
- That the deployment ran that branch was **inferred** from the message being unique to the commit — no production access, the running build was not read.
- One group had always saved: a lone leaf's duplicated `Name` is trivially unique. Invisible until a second group existed.
- Re-citing a whole document at a new sha means re-verifying its older bullets, not just the new ones — did that for rea-kernel's four.
- `git branch --contains` said `develop` lacked the commit while `develop`'s file held the code: the merge brought a content-identical commit, not that sha. Cite the merge, not the branch tip's ancestor.
- Kept `GroupName` out of the ask to the kernel: the carrier already exists, so terms' "kernel is primary" makes it a ui-side move.

## TODO
- Both plans await `Signed:`; nothing in `REA_UI` may change before it.
- Unasked, unexamined: whether rules stored under the old shape need `TranslatedRules` regenerated — `RuleSetSL` only translates on save.
- Noticed, not filed: `RuleFieldDescriptor` has a `VisibleWhen` property at `458e663` that no document mentions; may bear on plan field-locking.
