-- hyprland.start: documented startup pattern (recommended for autostart,
-- fires ~52s after Hyprland initializes — display is fully ready).
hl.on("hyprland.start", function()
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
  )
  hl.exec_cmd("systemctl --user start hypridle.service")
  hl.exec_cmd("systemctl --user start hyprsunset.service")
  hl.exec_cmd("systemctl --user start waybar.service")
  hl.exec_cmd("firefox", { workspace = "1 silent" })
  hl.exec_cmd("kitty", { workspace = "2 silent" })
  hl.exec_cmd("kitty", { workspace = "special:magic silent" })
end)

-- hyprland.shutdown: stop display-dependent services before Hyprland exits
-- so they exit cleanly instead of crashing with broken pipe, avoiding
-- systemd restart loops and rate limiting.
hl.on("hyprland.shutdown", function()
  hl.exec_cmd("systemctl --user stop waybar.service")
  hl.exec_cmd("systemctl --user stop hypridle.service")
  hl.exec_cmd("systemctl --user stop hyprsunset.service")
end)

-- monitor.added fires right when the display initializes (seconds, not ~52s like
-- hyprland.start). Start GUI apps here since they all need the Wayland socket.
hl.on("monitor.added", function()
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start blueman-applet")
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start copyq --start-server")
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start dunst")
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start nm-applet")
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start udiskie")
end)

hl.on("config.reloaded", function()
  hl.exec_cmd("systemctl --user restart hypridle.service")
  hl.exec_cmd("systemctl --user restart hyprsunset.service")
  hl.exec_cmd("systemctl --user restart waybar.service")
  hl.exec_cmd("systemctl --user start easyeffects.service")
end)
