#!/bin/sh
# Toggle mute for the default audio sink.
# Used by waybar's wireplumber on-click.

exec /run/current-system/sw/bin/wpctl set-mute @DEFAULT_SINK@ toggle
