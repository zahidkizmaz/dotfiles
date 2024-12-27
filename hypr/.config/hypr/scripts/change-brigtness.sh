#!/usr/bin/env bash

# Arbitrary but unique message id
msgId="789123"

action="${1}"
icon="display-brightness"

brightnessctl set "$action"

# Show the volume notification with a visual bar
current_brightness=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')
notify-send -a "changeBrightness" -u low -r "$msgId" "Brightness " -h "int:value:${current_brightness}" -i "$icon"
