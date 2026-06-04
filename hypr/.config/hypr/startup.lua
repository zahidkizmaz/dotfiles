-- hyprland.start: documented startup pattern (recommended for autostart,
-- fires ~52s after Hyprland initializes — display is fully ready).
hl.on("hyprland.start", function()
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
  )
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start noctalia")
  hl.exec_cmd("systemctl --user start hypridle.service")
  hl.exec_cmd("firefox", { workspace = "1 silent" })
  hl.exec_cmd("kitty", { workspace = "2 silent" })
  hl.exec_cmd("kitty", { workspace = "special:magic silent" })
end)

-- monitor.added fires right when the display initializes (seconds, not ~52s like
-- hyprland.start). Start GUI apps here since they all need the Wayland socket.
hl.on("monitor.added", function()
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start copyq --start-server")
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start udiskie")
end)

hl.on("config.reloaded", function()
  hl.exec_cmd("systemctl --user start easyeffects.service")
  hl.exec_cmd("~/.config/hypr/scripts/run.sh start noctalia")
  hl.exec_cmd("noctalia msg config-reload")
end)
