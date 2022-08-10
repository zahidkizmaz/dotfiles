#!/usr/bin/env bash

pgrep -x sxhkd >/dev/null || sxhkd &
pgrep -x picom >/dev/null || picom &
pgrep -x dunst >/dev/null || dunst &
pgrep -x nm-applet >/dev/null || nm-applet &
pgrep -x polybar >/dev/null || polybar top_bar &
pgrep -x copyq >/dev/null || copyq --start-server &
pgrep -x blueman-applet >/dev/null || blueman-applet &
pgrep -x polkit-gnome-au || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

exec nitrogen --restore
