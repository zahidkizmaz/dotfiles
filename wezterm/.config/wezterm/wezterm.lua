local wezterm = require("wezterm")

local function set_font_size(window)
  local window_dimensions = window:get_dimensions()
  local dpi = window_dimensions.dpi
  local width = window_dimensions.pixel_width
  local height = window_dimensions.pixel_height

  local font_size = 12
  if width > 1920 and height > 1080 and dpi < 80 then
    font_size = 14
  end

  local overrides = window:get_config_overrides() or {}
  overrides.font_size = font_size
  window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, _)
  set_font_size(window)
end)

wezterm.on("window-config-reloaded", function(window, _)
  set_font_size(window)
end)

local custom_mocha = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
custom_mocha.indexed = { [16] = "#000000" } -- Make ipython shell autocomplete readable

local function get_modifier()
  if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    return "ALT"
  end
  return "SUPER"
end
local modifier = get_modifier()

return {
  window_padding = {
    top = 4,
    left = 2,
    right = 2,
    bottom = 0,
  },
  enable_tab_bar = false,
  window_decorations = "RESIZE",
  color_schemes = { ["custom_mocha"] = custom_mocha },
  color_scheme = "custom_mocha",
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
    { key = "c", mods = modifier, action = wezterm.action.CopyTo("Clipboard") },
    { key = "V", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
    { key = "v", mods = modifier, action = wezterm.action.PasteFrom("Clipboard") },

    -- Font size
    { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
    { key = "=", mods = modifier, action = wezterm.action.IncreaseFontSize },
    { key = "-", mods = modifier, action = wezterm.action.DecreaseFontSize },
    { key = "-", mods = modifier, action = wezterm.action.DecreaseFontSize },
    { key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },
    { key = "0", mods = modifier, action = wezterm.action.ResetFontSize },

    -- The debug overlay
    { key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },

    -- Exiting
    {
      key = "w",
      mods = "SUPER",
      action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    { key = "q", mods = modifier, action = wezterm.action.QuitApplication },
  },
}
