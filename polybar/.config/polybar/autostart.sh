#!/bin/bash

# Run polybar for all monitors
for m in $(polybar --list-monitors | cut -d":" -f1); do
  if [[ $m == "eDP1" ]]; then
    MONITOR=$m polybar --reload laptop_screen &
  else
    MONITOR=$m polybar --reload external_screen &
  fi
done
