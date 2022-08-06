#!/bin/bash

userresources=$HOME/.Xresources
if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Set cursor to arrow
xsetroot -cursor_name left_ptr &

# Set key repeat rate
xset r rate 250 30 &

# Map Caps Lock to Escape and R-Shift&L-Shift Caps Lock
setxkbmap -option caps:escape,shift:both_capslock &

autorandr --change &
exec bspwm
