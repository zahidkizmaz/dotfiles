#!/usr/bin/env bash

# Used in hyprlock
# requires upower

# Get the battery device path
battery_device=$(upower -e | grep -E 'battery|BAT' | head -n 1)

# Exit if no battery is found
[ -z "$battery_device" ] && exit 1

# Get battery percentage and status
battery_info=$(upower -i "$battery_device")
battery_percentage=$(awk -F': *' '/percentage/ {gsub("%","",$2); print $2}' <<<"$battery_info")
battery_status=$(awk -F': *' '/state/ {print $2}' <<<"$battery_info")

# Define the battery icons for each 10% segment
battery_icons=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")

# Define the charging icon
charging_icon="󰂄"

# Calculate the icon index safely
icon_index=$((battery_percentage / 10))
[ "$icon_index" -gt 9 ] && icon_index=9

# Get the corresponding icon
battery_icon=${battery_icons[$icon_index]}

# Use charging icon if charging
if [ "$battery_status" = "charging" ]; then
  battery_icon="$charging_icon"
fi

# Output the battery percentage and icon
echo "$battery_percentage% $battery_icon"
