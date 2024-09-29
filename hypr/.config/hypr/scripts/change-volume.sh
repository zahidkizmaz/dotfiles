#!/usr/bin/env bash

# Arbitrary but unique message id
msgId="987123"

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
  echo "ERROR: Example Usage: $0 [5%+|5%-|toggle]"
  exit 1
  ;;
esac

# Query volume level
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume_level=$(awk '{print int($2 * 100)}' <<<"$volume")
muted=$(grep MUTED <<<"$volume")

if [[ $volume_level == 0 || -n $muted ]]; then
  # Show the sound muted notification
  notify-send -a "changeVolume" -u critical -r "$msgId" "$icon  Muted" -h "int:value:${volume_level}"
else
  # Show the volume notification with a visual bar
  notify-send -a "changeVolume" -u low -r "$msgId" "$icon  Volume " -h "int:value:${volume_level}"
fi
