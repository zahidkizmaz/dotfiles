#!/usr/bin/env bash

# Arbitrary but unique message id
msgId="9999"

action="${1}"
action_sign="${action: -1}"

change_volume() {
  local action=$1

  wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "$action"
}

# Set volume and icon based on the action
case $action_sign in
  "+")
    icon="󰝝"
    change_volume "$action"
    ;;
  "-")
    icon="󰝞"
    change_volume "$action"
    ;;
  "e")
    # ends with 'e' from 'toggle'
    icon="󰝟"
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
  *)
    echo "Usage: $0 [5%+|5%-|toggle]"
    exit 1
    ;;
esac

# Query volume level
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
mute=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep MUTED)

# Define the width of the volume bar (adjust as needed)
bar_width=28

generate_bar() {
  local width=$1
  local percent=$2
  local filled_width=$((width * percent / 100))
  local empty_width=$((width - filled_width))

  if [[ $filled_width != 0 ]]; then
    printf '█%.0s' $(seq 1 $filled_width)
  fi
  if [ $empty_width != 0 ]; then
    printf '░%.0s' $(seq 1 $empty_width)
  fi
}

if [[ $volume == 0 || -n $mute ]]; then
  # Show the sound muted notification
  dunstify -a "changeVolume" -u low -r "$msgId" "$icon  Muted" "$(generate_bar $bar_width 0)"
else
  # Show the volume notification with a visual bar
  bar=$(generate_bar $bar_width "$volume")
  dunstify -a "changeVolume" -u low -r "$msgId" \
    "$icon  ${volume}%" "$bar"
fi
