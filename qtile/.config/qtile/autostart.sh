#!/usr/bin/env bash

# Set key repeat rate
autorandr --change &
xset r rate 250 30 &
# Make Caps Lock an additional Esc and both Shift Keys toggle Caps Lock
setxkbmap -option caps:escape,shift:both_capslock &

nm-applet &
blueman-applet &
picom &
dunst &
nitrogen --restore &
xbindkeys
