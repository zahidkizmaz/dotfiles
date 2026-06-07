-- Window management rules
--
-- Floating window rules are loaded first (dialogs, popups, PiP, etc.),
-- followed by non-floating rules (workspace management, focus behavior).
require("floating_windowrules")

-- Stay focused: keep pinentry dialogs above everything
hl.window_rule({ match = { title = "(pinentry-)(.*)" }, stay_focused = true })

-- Browser: hide the screen-sharing notification bar (the "Hide" button on it
-- is broken on Wayland)
hl.window_rule({ match = { title = ".*is sharing.*" }, workspace = "special silent" })

-- No shadow on tiled windows: cleaner look, shadows only on floating windows
hl.window_rule({ match = { float = false }, no_shadow = true })

-- Smart gaps: no border/rounding on non-floating windows in single-tiled workspaces
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
