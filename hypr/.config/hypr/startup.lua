-- hyprland.start: documented startup pattern (recommended for autostart,
-- fires ~52s after Hyprland initializes — display is fully ready).
-- Events:
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Expanding-functionality/#events
local run = require("run")

hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start easyeffects.service")
  run.start("noctalia")
  run.start("librepods", { "--hide" })
  hl.exec_cmd("zen-beta", { workspace = "1 silent" })
  hl.exec_cmd("kitty", { workspace = "2 silent" })
  hl.exec_cmd("kitty", { workspace = "special:magic silent" })
end)

-- monitor.added fires right when the display initializes (seconds, not ~52s like
-- hyprland.start). Start GUI apps here since they all need the Wayland socket.
hl.on("monitor.added", function()
  run.start("copyq", { "--start-server" })
  run.start("udiskie")
end)

-- config.reloaded is also emitted on the *initial* config load
local first_load = os.getenv("HYPR_CONFIG_LOADED") == nil
hl.env("HYPR_CONFIG_LOADED", "1")

hl.on("config.reloaded", function()
  if first_load then
    return
  end
  hl.exec_cmd("systemctl --user start easyeffects.service")
  run.start("noctalia")
  run.start("librepods", { "--hide" })
  hl.exec_cmd("noctalia msg config-reload")
end)
