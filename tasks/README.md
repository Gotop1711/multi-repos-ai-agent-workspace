# tasks/ — working records

One directory per task: `tasks/<YYYY-MM-DD>-<name>/`, holding whatever the task
needs. Findings cite the task's snapshot lockfile with a `snapshot:` line —
`./workspace.sh check` verifies those resolve. Confirmed conclusions get distilled
into `docs/<scope>/`; task directories are never rewritten afterward.
