#!/usr/bin/env bash

if ! pgrep "vicinae" >/dev/null; then
  USE_LAYER_SHELL=0 nohup vicinae server >/tmp/vicinae.log 2>&1 &
  sleep 0.3
fi

vicinae toggle
