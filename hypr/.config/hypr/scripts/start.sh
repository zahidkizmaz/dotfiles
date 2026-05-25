#!/usr/bin/env sh

# Start a program if not already running.
# Usage: start.sh <program> [args...]

program_name="$1"
shift

if ! pgrep "$program_name" >/dev/null; then
  if [ $# -eq 0 ]; then
    nohup "$program_name" >/dev/null 2>&1 &
  else
    nohup "$program_name" "$@" >/dev/null 2>&1 &
  fi
fi
