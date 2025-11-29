#!/usr/bin/env sh

if ! pgrep "vicinae" >/dev/null; then
  vicinae server &
fi

vicinae toggle
