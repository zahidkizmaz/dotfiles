local wezterm = require("wezterm")

wezterm.on("window-resized", function(window, _)
  local window_dimensions = window:get_dimensions()
  local width = window_dimensions.pixel_width
  local height = window_dimensions.pixel_height
  local font_size = 12
  if width > 1920 and height > 1080 then
    font_size = 14
  end

  local overrides = window:get_config_overrides() or {}
  overrides.font_size = font_size
  window:set_config_overrides(overrides)
end)

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
  font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Regular" }),
  adjust_window_size_when_changing_font_size = false,

  text_background_opacity = 1,
  window_background_opacity = 0.98,

  -- Custom Keybindings
  disable_default_key_bindings = true,
  keys = {
    -- Search
    {
      key = "f",
      mods = "SUPER",
      action = wezterm.action.Search({ CaseSensitiveString = "" }),
    },
    {
      key = "F",
      mods = "CTRL|SHIFT",
      action = wezterm.action.Search({ CaseSensitiveString = "" }),
    },

    -- Copy & Paste
    { key = "C", mods = "CTRL", action = wezterm.action.CopyTo("Clipboard") },
    { key = "c", mods = "SUPER", action = wezterm.action.CopyTo("Clipboard") },
    { key = "V", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "v", mods = "SUPER", action = wezterm.action.PasteFrom("Clipboard") },

    -- Font size
    { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "=", mods = "SUPER", action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
    { key = "-", mods = "SUPER", action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
    { key = "0", mods = "SUPER", action = wezterm.action.ResetFontSize },

    -- The debug overlay
    { key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },

    -- Exiting
    {
      key = "w",
      mods = "SUPER",
      action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    { key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
  },
}
