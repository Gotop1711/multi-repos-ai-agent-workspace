#!/usr/bin/env bash
# workspace.sh — the whole harness in one script.
#   ./workspace.sh setup    one-time: wire the safety hook, print what to do next
#   ./workspace.sh clone    rebuild the fleet from catalog/repos.yaml
#   ./workspace.sh check    verify the manifest (session-init / pre-commit)
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
case "$cmd" in clone|check)
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
  sed -n '2,5p' "$0"
  ;;

*)
  sed -n '2,5p' "$0" >&2
  exit 1
  ;;
esac
