#!/usr/bin/env bash

check_hyprsunset() {
  if pgrep -x "hyprsunset" >/dev/null; then
    echo '{"text": "off", "alt": "off", "class": "off", "tooltip": "Hyprsunset off"}'
  else
    echo '{"text": "on", "alt": "on", "class": "on", "tooltip": "Hyprsunset on"}'
  fi
}

if [ "$1" = "toggle" ]; then
  if pgrep -x "hyprsunset" >/dev/null; then
    pkill hyprsunset
  else
    hyprsunset -t 3500 &
  fi
  sleep 0.2
fi

check_hyprsunset
