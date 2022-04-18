#!/usr/bin/env bash

# Set key repeat rate
xset r rate 250 30 &
nm-applet &
picom &
nitrogen --restore &
xrandr --output HDMI1 --auto
