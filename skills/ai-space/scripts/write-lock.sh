#!/usr/bin/env bash
# Serialize writes to ~/.ai-space across local CLI sessions.
# Agent shells are short-lived, so the lock is TTL-based, not PID-based.
set -euo pipefail

REPO="${AI_SPACE_ROOT:-$HOME/.ai-space}"
TTL_SEC="${AI_SPACE_LOCK_TTL:-1800}"
WAIT_MAX_SEC="${AI_SPACE_LOCK_WAIT:-90}"
SLEEP_SEC=2

usage() {
  echo "usage: $0 prepare|heartbeat|release|status" >&2
  exit 64
}

git_dir() {
  git -C "$REPO" rev-parse --absolute-git-dir
}

lock_dir() {
  echo "$(git_dir)/ai-space-write.lock"
}

now() {
  date +%s
}

age_sec() {
  local lock="$1"
  local at=0
  if [[ -f "$lock/acquired_at" ]]; then
    at=$(cat "$lock/acquired_at" 2>/dev/null || echo 0)
  fi
  echo $(( $(now) - at ))
}

is_stale() {
  local lock="$1"
  [[ ! -d "$lock" ]] && return 0
  local age
  age=$(age_sec "$lock")
  (( age >= TTL_SEC ))
}

acquire() {
  local lock waited=0
  lock=$(lock_dir)
  while true; do
    if mkdir "$lock" 2>/dev/null; then
      echo "$(now)" > "$lock/acquired_at"
      echo "acquired $lock"
      return 0
    fi
    if is_stale "$lock"; then
      rm -rf "$lock"
      continue
    fi
    if (( waited >= WAIT_MAX_SEC )); then
      echo "busy: another session holds $lock (age $(age_sec "$lock")s, ttl ${TTL_SEC}s). Retry this write later. Do not stop permanently. Do not create another knowledge store." >&2
      return 1
    fi
    sleep "$SLEEP_SEC"
    waited=$((waited + SLEEP_SEC))
  done
}

release() {
  local lock
  lock=$(lock_dir)
  rm -rf "$lock"
  echo "released"
}

heartbeat() {
  local lock
  lock=$(lock_dir)
  if [[ ! -d "$lock" ]]; then
    echo "no lock to refresh; run prepare first" >&2
    return 1
  fi
  echo "$(now)" > "$lock/acquired_at"
  echo "heartbeat"
}

has_remote() {
  git -C "$REPO" remote | grep -q .
}

sync_repo() {
  if has_remote; then
    git -C "$REPO" pull --ff-only
  fi
}

has_conflicts() {
  git -C "$REPO" diff --name-only --diff-filter=U | grep -q .
}

is_dirty() {
  if ! git -C "$REPO" diff --quiet; then
    return 0
  fi
  if ! git -C "$REPO" diff --cached --quiet; then
    return 0
  fi
  [[ -n "$(git -C "$REPO" ls-files -o --exclude-standard)" ]]
}

recover_dirty() {
  if has_conflicts; then
    release
    echo "unmerged conflicts in $REPO; fix them before writing. lock released." >&2
    return 2
  fi
  if ! is_dirty; then
    return 0
  fi
  git -C "$REPO" add -A
  if git -C "$REPO" diff --cached --quiet; then
    return 0
  fi
  git -C "$REPO" commit -m "$(cat <<'EOF'
Recover interrupted knowledge-store write.

EOF
)"
  echo "recovered dirty worktree"
}

prepare() {
  acquire
  if ! sync_repo; then
    release
    echo "pull --ff-only failed; lock released. Do not force push." >&2
    return 3
  fi
  recover_dirty
}

status() {
  local lock
  lock=$(lock_dir)
  if [[ ! -d "$lock" ]]; then
    echo "free"
    return 0
  fi
  echo "held age=$(age_sec "$lock")s ttl=${TTL_SEC}s stale=$(is_stale "$lock" && echo yes || echo no)"
}

cmd="${1:-}"
case "$cmd" in
  prepare) prepare ;;
  heartbeat) heartbeat ;;
  release) release ;;
  status) status ;;
  *) usage ;;
esac
