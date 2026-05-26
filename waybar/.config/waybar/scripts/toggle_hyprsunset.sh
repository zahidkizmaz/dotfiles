#!/bin/sh

check_hyprsunset() {
  if /run/current-system/sw/bin/pgrep -x "hyprsunset" >/dev/null; then
    echo '{"text": "on", "alt": "on", "class": "on", "tooltip": "Hyprsunset on"}'
  else
    echo '{"text": "off", "alt": "off", "class": "off", "tooltip": "Hyprsunset off"}'
  fi
}

if [ "$1" = "toggle" ]; then
  if /run/current-system/sw/bin/pgrep -x "hyprsunset" >/dev/null; then
    /run/current-system/sw/bin/pkill hyprsunset
  else
    /run/current-system/sw/bin/hyprsunset &
  fi
fi

check_hyprsunset
