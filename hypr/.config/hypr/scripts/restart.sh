#!/usr/bin/env sh

# Restart specified programs (kills and restarts each one).
# Called from startup.lua on config.reloaded to gracefully restart
# services like waybar without restarting all GUI apps.

for program in "$@"; do
  pkill "$(basename "$program")" 2>/dev/null || true
  sleep 0.3
  nohup "$program" >/dev/null 2>&1 &
  echo "Restarted $program with PID $!"
done
