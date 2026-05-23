hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 4,
    border_size = 2,
    col = {
      active_border = "$pink",
      inactive_border = "$surface0",
    },
    layout = "dwindle",
    allow_tearing = false,
  },
  dwindle = {
    force_split = 2,
    preserve_split = true,
  },
  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    initial_workspace_tracking = 0,
    mouse_move_focuses_monitor = true,
    focus_on_activate = true,
  },
  binds = {
    hide_special_on_workspace_change = true,
  },
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },
})
