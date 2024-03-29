#!/usr/bin/env bash

pgrep -x blueman-applet >/dev/null || blueman-applet &
pgrep -x copyq >/dev/null || copyq --start-server &
pgrep -x dunst >/dev/null || dunst &
pgrep -x hypridle >/dev/null || hypridle &
pgrep -x nm-applet >/dev/null || nm-applet &
pgrep -x pcmanfm >/dev/null || pcmanfm --start-server &
pgrep -x polkit-kde-auth || /usr/lib/polkit-kde-authentication-agent-1 &
pgrep -x waybar >/dev/null || waybar &

exec ~/.config/hypr/scripts/set_gsettings.sh
