# 2026-09-17 | claude | rea | name-vs-groupname

## Task
Find the "Name vs GroupName" session missing from the VS Code panel; rewrite plan translated-rule-names in plain zh-TW; settle where the group name travels to the kernel.

## Done
- Session not lost: `08df3808…` in `~/.claude/projects/<workspace>/`, `claude --resume <id>`.
- translated-rule-names: plain summary, deduplicated, zh-TW, citations kept (`3ad84c2`). Needs no signature — it writes nothing.
- Owner's ruling: the group name stays in `GroupName`, which the kernel will implement; `REA_UI` needs no change. Recorded in rule-editor › The leaf envelope.

## Decisions & pitfalls
- Tried to append `Signed:` on the owner's spoken word; the permission classifier refused. Right — the signature is the human's line.
- `GroupName` has no kernel source yet: `develop` unchanged past `458e663` (dry-run fetch). rea-kernel's `Name` bullets stay — still true of the source.
- zsh: `echo ====` is `=cmd` expansion; tools need `./` before a directory named `-Users-…`.

## TODO
- Push workspace `rea` (this shell has no remote access).
- When the kernel adds `GroupName`: re-cite rea-kernel and rule-editor; translated-rule-names rests on "every leaf must be named" and may end `Abandoned: — decided`.
