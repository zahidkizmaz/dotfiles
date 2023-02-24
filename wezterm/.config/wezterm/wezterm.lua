local wezterm = require("wezterm")
return {
  window_padding = {
    top = 4,
    left = 2,
    right = 2,
    bottom = 0,
  },
  enable_tab_bar = false,
  window_decorations = "RESIZE",
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 14,
}
