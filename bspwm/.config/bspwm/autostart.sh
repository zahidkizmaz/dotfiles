#!/usr/bin/env bash

# Set key repeat rate
xset r rate 250 30 &
setxkbmap -option caps:escape,shift:both_capslock &

pgrep -x sxhkd >/dev/null || sxhkd &
pgrep -x picom >/dev/null || picom &
pgrep -x dunst >/dev/null || dunst &
pgrep -x polybar >/dev/null || polybar top_bar &
pgrep -x nm-applet >/dev/null || nm-applet &
pgrep -x blueman-applet >/dev/null || blueman-applet &

autorandr --change &
nitrogen --restore &
exec xbindkeys
