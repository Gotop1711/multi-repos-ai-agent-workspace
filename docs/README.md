# docs/ — the library: settled knowledge and the write gate

`BLUEPRINT.md`, beside this file, is the design rationale for the whole
repository — read it first. Everything else here is per-scope knowledge:
one folder per scope (product/area), created when work on it begins:

```
docs/<scope>/
├── background.md           ← human-set framing; agents cite, never edit
├── specification.md        ← agent-maintained current architecture — opens
│                             with a `snapshot: snapshots/<...>.lock.yaml`
│                             line naming the lockfile it describes
├── CHANGELOG.md            ← what shipped for this scope
└── plans/<FEATURE>_PLAN.md ← discussion → 🚦 signature → execution
```

## The signature gate

A plan authorizes child-repo work only after a human adds, inside the file:

    Signed: <name> — <YYYY-MM-DD>

⛔ No write of any kind to a child repository before that line exists.

## Writing rules

- Append or update; **never delete history**. Corrections are appended notes,
  not overwrites.
- CHANGELOG entries: same format as the header of `./CHANGELOG.md`.
- Session logs (`.agents/memory/sessions/`) hold the *journey*; this folder
  holds the *settled state*. Distill confirmed findings here; leave the dead
  ends in the logs.
