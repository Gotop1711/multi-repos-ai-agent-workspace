#!/usr/bin/env bash
# workspace.sh — the whole harness in one script.
#   ./workspace.sh setup                 one-time: wire the safety hook, print what to do next
#   ./workspace.sh clone                 rebuild the fleet from catalog/repos.yaml
#   ./workspace.sh cite                  print the fleet as one citation line — paste into findings
#   ./workspace.sh restore <repo>@<sha>… check cited commits out (bare <repo> returns to its branch)
#   ./workspace.sh check                 verify the manifest (session-init / pre-commit)
# Plain bash (macOS 3.2 ok), zero dependencies.
set -u
cd "$(dirname "$0")" || exit 1
MANIFEST="catalog/repos.yaml"
tmp=""; trap 'rm -f "$tmp"' EXIT

entries() { # one line per repo: id|path|remote|branch|access
  awk '
    function flush() { if (id != "") print id "|" path "|" remote "|" branch "|" access }
    /^- id:/                       { flush(); id=$3; path=""; remote=""; branch=""; access="" }
    /^[[:space:]]+path:/           { path=$2 }
    /^[[:space:]]+remote:/         { remote=$2 }
    /^[[:space:]]+default_branch:/ { branch=$2 }
    /^[[:space:]]+access:/         { access=$2 }
    END                            { flush() }
  ' "$MANIFEST"
}

cmd="${1:-help}"
case "$cmd" in clone|cite|restore|check)
  [ -f "$MANIFEST" ] || { echo "FAIL: $MANIFEST missing" >&2; exit 1; }
esac

case "$cmd" in

setup)
  git config core.hooksPath .githooks
  echo "safety hook wired: every commit now runs './workspace.sh check' first."
  bash "$0" check || true
  echo
  echo "next steps:"
  if grep -qE '^- id:' "$MANIFEST" 2>/dev/null; then
    echo "  1. ./workspace.sh clone            # fleet appears under projects/"
  else
    echo "  1. edit catalog/repos.yaml         # declare your child repos + access levels"
    echo "  2. ./workspace.sh clone            # fleet appears under projects/"
  fi
  git remote | grep -q . \
    || echo "  •  add a PRIVATE remote for this repo and push — its memory must survive a dead disk"
  ;;

clone)
  tmp="$(mktemp)"; entries > "$tmp"
  if [ ! -s "$tmp" ]; then
    echo "nothing to clone yet — add your repos to catalog/repos.yaml first."
    exit 0
  fi
  fail=0
  while IFS='|' read -r id path remote branch access; do
    [ -n "$id" ] || continue
    if [ -d "$path/.git" ]; then echo "[$id] already cloned"; else
      echo "[$id] cloning $remote → $path"
      git clone --quiet --branch "$branch" "$remote" "$path" \
        || { echo "[$id] CLONE FAILED — continuing with the rest" >&2; fail=$((fail+1)); continue; }
    fi
    if [ "$access" = "read-only" ]; then
      git -C "$path" remote set-url --push origin DISALLOWED_READ_ONLY
      echo "[$id] read-only → push disabled"
    elif [ "$(git -C "$path" remote get-url --push origin 2>/dev/null)" = "DISALLOWED_READ_ONLY" ]; then
      git -C "$path" remote set-url --push origin "$remote"
      echo "[$id] access upgraded → push re-enabled"
    fi
  done < "$tmp"
  [ "$fail" -eq 0 ] && echo "fleet complete." || { echo "$fail repo(s) failed to clone." >&2; exit 1; }
  ;;

cite)
  tmp="$(mktemp)"; entries > "$tmp"
  [ -s "$tmp" ] || { echo "manifest has no repos — edit catalog/repos.yaml first" >&2; exit 1; }
  line=""
  while IFS='|' read -r id path remote branch access; do
    [ -n "$id" ] || continue
    [ -d "$path/.git" ] || { echo "[$id] not cloned — run ./workspace.sh clone" >&2; exit 1; }
    [ -z "$(git -C "$path" status --porcelain)" ] \
      || echo "warn: [$id] has local changes — its HEAD does not describe what you are reading" >&2
    line="$line $id@$(git -C "$path" rev-parse --short HEAD)"
  done < "$tmp"
  echo "${line# }"
  ;;

restore)
  shift
  if [ "$#" -eq 0 ]; then
    echo "usage: workspace.sh restore <repo>@<sha> [...]   # paste a finding's citations" >&2
    echo "       workspace.sh restore <repo> [...]         # back to the manifest branch" >&2
    exit 1
  fi
  tmp="$(mktemp)"; entries > "$tmp"
  fail=0
  # $* unquoted on purpose: a whole citation line pasted as ONE argument
  # (quotes, or a zsh variable) still splits into tokens
  for token in $*; do
    id="${token%%@*}"; sha=""; [ "$token" != "$id" ] && sha="${token#*@}"
    path="$(awk -F'|' -v id="$id" '$1==id{print $2; exit}' "$tmp")"
    branch="$(awk -F'|' -v id="$id" '$1==id{print $4; exit}' "$tmp")"
    [ -n "$path" ] || { echo "[$id] not in the manifest" >&2; fail=$((fail+1)); continue; }
    [ -d "$path/.git" ] || { echo "[$id] not cloned — run ./workspace.sh clone" >&2; fail=$((fail+1)); continue; }
    if [ -n "$(git -C "$path" status --porcelain)" ]; then
      echo "[$id] has local changes — NOT touching it" >&2; fail=$((fail+1)); continue
    fi
    if [ -n "$sha" ]; then
      git -C "$path" checkout --quiet --detach "$sha" 2>/dev/null \
        && echo "[$id] → $sha (detached; './workspace.sh restore $id' returns to $branch)" \
        || { echo "[$id] RESTORE FAILED (sha $sha unreachable — history rewritten upstream?)" >&2; fail=$((fail+1)); }
    else
      git -C "$path" checkout --quiet "$branch" && echo "[$id] → $branch" \
        || { echo "[$id] RESTORE FAILED (branch $branch)" >&2; fail=$((fail+1)); }
    fi
  done
  [ "$fail" -eq 0 ] || { echo "restore: $fail repo(s) not restored." >&2; exit 1; }
  ;;

check)
  status=0; n=0; tmp="$(mktemp)"; entries > "$tmp"
  while IFS='|' read -r id path remote branch access; do
    n=$((n+1))
    [ -n "$id" ] && [ -n "$path" ] && [ -n "$remote" ] && [ -n "$branch" ] \
      || { echo "FAIL: manifest entry $n incomplete (needs id/path/remote/default_branch)" >&2; status=1; }
    case "$access" in write|pr-only|read-only) : ;;
      *) echo "FAIL: [$id] access must be write|pr-only|read-only (got '${access:-<empty>}')" >&2; status=1 ;; esac
  done < "$tmp"
  raw="$(grep -cE '^[[:space:]]*-[[:space:]]*id:' "$MANIFEST" || true)"
  if [ "$raw" -gt "$n" ]; then
    echo "FAIL: manifest has $raw 'id:' line(s) but only $n parse — check indentation ('- id:' must start at column 0)" >&2
    status=1
  fi
  bad="$(awk '
    /^[[:space:]]*#/ { next }
    /^- id:/ { if (NF > 3) print NR; next }
    /^[[:space:]]+(path|remote|default_branch|access):/ { if (NF > 2) print NR }
  ' "$MANIFEST")"
  [ -z "$bad" ] || { echo "FAIL: manifest line(s) $(echo $bad | tr ' ' ','): values must be single tokens (no spaces or inline comments)" >&2; status=1; }
  [ "$n" -gt 0 ] || echo "warn: manifest has no repos yet — edit catalog/repos.yaml"
  newest="$(ls .agents/memory/sessions 2>/dev/null | grep -E '^[0-9]{4}-' | sort | tail -1)"
  echo "info: newest session log: ${newest:-none yet}"
  [ "$status" -eq 0 ] && echo "check: PASS ($n repo(s) in manifest)" || echo "check: FAIL" >&2
  exit "$status"
  ;;

help)
  sed -n '2,7p' "$0"
  ;;

*)
  sed -n '2,7p' "$0" >&2
  exit 1
  ;;
esac
