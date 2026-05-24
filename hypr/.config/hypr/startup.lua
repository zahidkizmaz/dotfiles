-- Startup commands (equivalent to exec-once in .conf)
-- Runs once on Hyprland start via the hyprland.start event
hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  hl.exec_cmd("systemctl --user enable --now hypridle.service")
  hl.exec_cmd("systemctl --user enable --now hyprsunset.service")

  hl.exec_cmd("~/.config/hypr/scripts/autostart.sh")

  hl.exec_cmd("firefox", { workspace = "1" })
  hl.exec_cmd("kitty", { workspace = "2" })
  hl.exec_cmd("kitty", { workspace = "special:magic" })
end)
