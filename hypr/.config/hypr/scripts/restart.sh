#!/usr/bin/env sh

# Restart specified programs (kills and restarts each one).
# Called from startup.lua on config.reloaded to gracefully restart
# services like waybar without restarting all GUI apps.

restart_program() {
  program_name="$1"
  pid=$(pgrep "$program_name")
  if [ -n "$pid" ]; then
    kill "$pid"
    sleep 0.5
  fi
  nohup "$program_name" >/dev/null 2>&1 &
  echo "Restarted $program_name with PID $!"
}

for program in "$@"; do
  restart_program "$program"
done
