#!/usr/bin/env sh

start_program() {
  program_name="$1"
  args="$2"

  if ! pgrep "$program_name" >/dev/null; then
    if [ -z "$args" ]; then
      nohup "$program_name" >/dev/null 2>&1 &
    else
      nohup "$program_name" "$args" >/dev/null 2>&1 &
    fi
    echo "Started $program_name $args with PID $!"
  fi
}

restart_program() {
  program_name="$1"
  args="$2"

  pid=$(pgrep "$program_name")
  if [ -n "$pid" ]; then
    kill "$pid"
    echo "Killed $program_name with PID $pid"
    sleep 0.5
  fi

  if [ -z "$args" ]; then
    nohup "$program_name" >/dev/null 2>&1 &
  else
    nohup "$program_name" "$args" >/dev/null 2>&1 &
  fi
  echo "Started $program_name $args with PID $!"
}

start_program "blueman-applet"
start_program "copyq" "--start-server"
start_program "nm-applet"
start_program "pcmanfm" "--daemon-mode"
start_program "dunst"

restart_program "waybar"
