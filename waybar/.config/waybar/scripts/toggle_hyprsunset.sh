#!/usr/bin/env bash

check_hyprsunset() {
  if pgrep -x "hyprsunset" >/dev/null; then
    echo '{"text": "on", "alt": "on", "class": "on", "tooltip": "Hyprsunset on"}'
  else
    echo '{"text": "off", "alt": "off", "class": "off", "tooltip": "Hyprsunset off"}'
  fi
}

if [ "$1" = "toggle" ]; then
  if pgrep -x "hyprsunset" >/dev/null; then
    pkill hyprsunset
  else
    hyprsunset &
  fi
fi

check_hyprsunset
