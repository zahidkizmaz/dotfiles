#!/usr/bin/env sh

# Restart specified programs (kills and restarts each one).
# Called from startup.lua on config.reloaded to gracefully restart
# services like waybar without restarting all GUI apps.
#
# Logs are appended to ~/.cache/hyprland/logs/ (start.sh creates
# fresh files per Hyprland session, restart.sh appends to them).

log_dir="$HOME/.cache/hyprland/logs"
mkdir -p "$log_dir"

for program in "$@"; do
  name="$(basename "$program")"
  log_file="$log_dir/$name.log"
  now="$(date '+%Y-%m-%d %H:%M:%S')"

  old_pids="$(pgrep "$name" 2>/dev/null)" || true
  if [ -n "$old_pids" ]; then
    pids_str="$(echo "$old_pids" | tr '\n' ' ')"
    echo "[$now] $name restarting, killing PID(s): $pids_str" >>"$log_file"
    pkill "$name" 2>/dev/null || true
    sleep 0.3
  else
    echo "[$now] $name starting (was not running)" >>"$log_file"
  fi

  nohup "$program" >>"$log_file" 2>&1 &
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $name started, PID $!" >>"$log_file"
  echo "Restarted $program with PID $!"
done
