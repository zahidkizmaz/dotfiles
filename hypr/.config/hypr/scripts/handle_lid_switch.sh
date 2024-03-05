#!/usr/bin/env bash

if grep open /proc/acpi/button/lid/LID0/state; then
  hyprctl keyword monitor "eDP-1,preferred,auto,1"
else
  if [[ "$(hyprctl monitors | grep -c 'Monitor')" -gt 1 ]]; then
    hyprctl keyword monitor "eDP-1, disable"
  fi
fi
