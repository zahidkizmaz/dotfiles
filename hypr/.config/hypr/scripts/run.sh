#!/usr/bin/env sh

# Start or restart a program, capturing its output to a log file.
# Usage: run.sh start   <program> [args...]
#        run.sh restart <program>
#
# Logs go to ~/.cache/hyprland/logs/<program>.log.
#   start   — creates a fresh log per Hyprland session (truncate).
#   restart — kills existing processes, then starts, appending to log.

action="$1"
program="$2"
shift 2

name="$(basename "$program")"
log_file="$HOME/.cache/hyprland/logs/$name.log"

mkdir -p "$(dirname "$log_file")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >>"$log_file"
}

start() {
  if pgrep "$name" >/dev/null; then
    exit 0 # already running
  fi
  : >"$log_file" # fresh log per Hyprland session
  log "$name starting"
  if [ $# -eq 0 ]; then
    nohup "$program" >>"$log_file" 2>&1 &
  else
    nohup "$program" "$@" >>"$log_file" 2>&1 &
  fi
}

restart() {
  old_pids="$(pgrep "$name" 2>/dev/null)" || true
  if [ -n "$old_pids" ]; then
    pids_str="$(echo "$old_pids" | tr '\n' ' ')"
    log "$name restarting, killing PID(s): $pids_str"
    pkill "$name" 2>/dev/null || true
    sleep 0.3
  else
    log "$name starting (was not running)"
  fi
  nohup "$program" >>"$log_file" 2>&1 &
  log "$name started, PID $!"
  echo "Restarted $program with PID $!"
}

case "$action" in
  start) start "$@" ;;
  restart) restart ;;
  *)
    echo "Usage: $0 {start|restart} <program> [args...]" >&2
    exit 1
    ;;
esac
