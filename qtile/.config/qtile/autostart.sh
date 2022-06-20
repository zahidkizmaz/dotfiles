#!/usr/bin/env bash

# Set key repeat rate
xset r rate 250 30 &
nm-applet &
blueman-applet &
picom &
dunst &
autorandr --change --force &
nitrogen --restore &
xbindkeys
