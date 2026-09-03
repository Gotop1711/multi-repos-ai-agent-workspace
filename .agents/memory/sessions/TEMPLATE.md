# Session Log — YYYY-MM-DD | {agent} | {scope}

Copy to `YYYY-MM-DD-{agent}-{scope}--{task}.md` ({agent} = claude / codex / …;
{scope} = the lead scope id the task targeted — a `docs/` scope id, existing or
created this session — or `workspace`; {task} = the feature id when the task
is one; scopes touched besides the lead are named in the Task line). Written
by the agent at closeout —
a session may not end without its log. This file is the **journey only**:
findings belong in the docs system (`docs/<scope>.md` → Open findings).

## Task
One line.

## Completed
1. path — what was done

## Decisions & pitfalls        ← the valuable part
- Why this option, not just which.
- Failed attempts and WHY they failed — saves the next session from retrying them.

## TODO / known-incomplete
- Explicit list; never buried in prose.
