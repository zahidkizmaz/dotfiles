-- Module level: services that must be running immediately (not delayed by
-- hyprland.start which fires ~52s late).
hl.exec_cmd("systemctl --user enable --now hypridle.service")
hl.exec_cmd("systemctl --user enable --now hyprsunset.service")

-- Small delay for waybar: process starts immediately but needs the
-- compositor fully settled to connect IPC and render promptly.
-- Started here (not in monitor.added) to avoid race when multiple
-- monitors fire the event simultaneously.
hl.timer(function()
  hl.exec_cmd("~/.config/hypr/scripts/start.sh waybar")
end, { timeout = 1500, type = "oneshot" })

-- hyprland.start: documented startup pattern (dbus, workspace apps)
hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("firefox", { workspace = "1 silent" })
  hl.exec_cmd("kitty", { workspace = "2 silent" })
  hl.exec_cmd("kitty", { workspace = "special:magic silent" })
end)

-- monitor.added fires right when the display initializes (seconds, not ~52s like
-- hyprland.start). Start GUI apps here since they all need the Wayland socket.
hl.on("monitor.added", function()
  hl.exec_cmd("~/.config/hypr/scripts/start.sh blueman-applet")
  hl.exec_cmd("~/.config/hypr/scripts/start.sh copyq --start-server")
  hl.exec_cmd("~/.config/hypr/scripts/start.sh dunst")
  hl.exec_cmd("~/.config/hypr/scripts/start.sh nm-applet")
  hl.exec_cmd("~/.config/hypr/scripts/start.sh udiskie")
end)

-- config.reloaded: restart services that read config files (waybar reads
-- hyprland styles, hypridle and hyprsunset read their own .conf files).
hl.on("config.reloaded", function()
  hl.exec_cmd("~/.config/hypr/scripts/restart.sh waybar")
  hl.exec_cmd("systemctl --user restart hypridle.service")
  hl.exec_cmd("systemctl --user restart hyprsunset.service")
  hl.exec_cmd("systemctl --user start easyeffects.service")
end)
