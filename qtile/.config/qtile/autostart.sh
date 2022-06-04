#!/usr/bin/env bash

# Set key repeat rate
xset r rate 250 30 &
nm-applet &
blueman-applet &
picom &
dunst &
xwallpaper --stretch "$WALLPAPER" &
xrandr --output HDMI1 --auto
xbindkeys
