#!/usr/bin/env bash

pgrep -x sxhkd >/dev/null || sxhkd &
pgrep -x picom >/dev/null || picom &
pgrep -x dunst >/dev/null || dunst &
pgrep -x nm-applet >/dev/null || nm-applet &
pgrep -x copyq >/dev/null || copyq --start-server &
pgrep -x blueman-applet >/dev/null || blueman-applet &
pgrep -x polkit-gnome-au || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Run polybar for all monitors
for m in $(polybar --list-monitors | cut -d":" -f1); do
  MONITOR=$m polybar --reload top_bar &
done

exec nitrogen --restore
