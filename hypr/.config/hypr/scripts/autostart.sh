#!/usr/bin/env bash

pgrep blueman-applet >/dev/null || blueman-applet &
pgrep copyq >/dev/null || copyq --start-server &
pgrep dunst >/dev/null || dunst &
pgrep hypridle >/dev/null || hypridle &
pgrep nm-applet >/dev/null || nm-applet &
pgrep pcmanfm >/dev/null || pcmanfm --start-server &
pgrep waybar >/dev/null || waybar &
