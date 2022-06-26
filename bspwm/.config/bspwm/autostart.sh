#!/usr/bin/env bash

# Set key repeat rate
autorandr --change &
xset r rate 250 30 &
nm-applet &
blueman-applet &
picom &
dunst &
nitrogen --restore &
polybar top_bar &
xbindkeys
