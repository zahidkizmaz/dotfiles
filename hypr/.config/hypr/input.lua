hl.config({
  input = {
    kb_layout = "us,de",
    kb_variant = ",qwerty",
    kb_options = "caps:escape, grp:alt_shift_toggle",
    follow_mouse = 2,
    float_switch_override_focus = 0,
    accel_profile = "flat",
    touchpad = {
      drag_lock = 1,
      drag_3fg = 1,
      natural_scroll = true,
      scroll_factor = 0.5,
    },
    sensitivity = 0.80,
  },
  gestures = {
    workspace_swipe_cancel_ratio = 0.15,
    workspace_swipe_create_new = true,
  },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "down", action = "special magic" })
hl.gesture({ fingers = 4, direction = "up", action = "dispatcher workspace previous" })
