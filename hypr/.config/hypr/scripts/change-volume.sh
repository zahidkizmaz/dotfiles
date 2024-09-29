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

get_icon_from_volume_level() {
  volume_level=$1

  if [ "$volume_level" -eq 0 ]; then
    icon="audio-volume-muted"
  elif [ "$volume_level" -lt 30 ]; then
    icon="audio-volume-low"
  elif [ "$volume_level" -lt 70 ]; then
    icon="audio-volume-medium"
  elif [ "$volume_level" -lt 100 ]; then
    icon="audio-volume-high"
  fi
  echo "$icon"
}

# Set volume and icon based on the action
case $action_sign in
  "+" | "-")
    change_volume "$action"
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    volume_level=$(awk '{print int($2 * 100)}' <<<"$volume")
    icon=$(get_icon_from_volume_level "$volume_level")

    # Show the volume notification with a visual bar
    notify-send -a "changeVolume" -u low -r "$msgId" "Volume " -h "int:value:${volume_level}" -i "$icon"
    ;;
  "e")
    # ends with 'e' from 'toggle'
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    volume_level=$(awk '{print int($2 * 100)}' <<<"$volume")
    muted=$(grep MUTED <<<"$volume")
    icon=$(get_icon_from_volume_level "$volume_level")

    if [ -n "$muted" ]; then
      icon="audio-volume-muted"
      notify-send -a "changeVolume" -u critical -r "$msgId" "Muted" -h "int:value:${volume_level}" -i "$icon"
    else
      notify-send -a "changeVolume" -u low -r "$msgId" "Volume " -h "int:value:${volume_level}" -i "$icon"
    fi
    ;;
  *)
    echo "ERROR: Example Usage: $0 [5%+|5%-|toggle]"
    exit 1
    ;;
esac
