-- Reload config
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Basic keybinds
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + Q", hl.dsp.window.kill())
hl.bind("SUPER + SHIFT + M", hl.dsp.exit())
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/vicinae-toggle.sh"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("tofi-drun --drun-launch=true"))

-- Focus movement
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Window movement
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Window modes
hl.bind("SUPER + M", hl.dsp.window.fullscreen())
hl.bind("SUPER + F", hl.dsp.window.float())

-- Workspace switching
hl.bind("CTRL + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("CTRL + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("CTRL + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("CTRL + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("CTRL + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("CTRL + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("CTRL + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("CTRL + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("CTRL + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("CTRL + 0", hl.dsp.focus({ workspace = 10 }))

-- Move window to workspace
hl.bind("CTRL + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("CTRL + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("CTRL + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("CTRL + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("CTRL + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("CTRL + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("CTRL + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("CTRL + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("CTRL + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("CTRL + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Workspace scrolling
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse bindings
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.resize())

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-volume.sh 1%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-volume.sh 1%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-volume.sh toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

-- Brightness control
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-brigtness.sh 1%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-brigtness.sh 1%-"))

-- Application shortcuts
hl.bind("SUPER + SHIFT + x", hl.dsp.exec_cmd("copyq toggle"))
hl.bind(
  "SUPER + SHIFT + P",
  hl.dsp.exec_cmd(
    [[grim -g "$(slurp)" - | satty -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png"]]
  )
)
hl.bind("SUPER + CTRL + Q", hl.dsp.exec_cmd("hyprlock"))

-- Resize submap
hl.define_submap("resize", "escape", function()
  hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
end)

-- Activate resize submap
hl.bind("ALT + R", hl.dsp.submap("resize"))
