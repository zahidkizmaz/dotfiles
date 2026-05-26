#!/usr/bin/env sh

# Start a program if not already running.
# Usage: start.sh <program> [args...]
#
# Logs are written to ~/.cache/hyprland/logs/ and created fresh
# each Hyprland session (start.sh truncates, restart.sh appends).

program_name="$1"
shift

log_file="$HOME/.cache/hyprland/logs/$(basename "$program_name").log"
mkdir -p "$(dirname "$log_file")"

if ! pgrep "$program_name" >/dev/null; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $program_name starting" >"$log_file"
  if [ $# -eq 0 ]; then
    nohup "$program_name" >>"$log_file" 2>&1 &
  else
    nohup "$program_name" "$@" >>"$log_file" 2>&1 &
  fi
fi
