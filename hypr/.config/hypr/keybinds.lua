-- Reload config
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Basic keybinds
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + Q", hl.dsp.window.kill())
hl.bind("SUPER + SHIFT + M", hl.dsp.exit())
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/vicinae-toggle.sh"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("tofi-drun | xargs hyprctl dispatch exec --"))

-- Focus movement
hl.bind("SUPER + H", hl.dsp.focus("l"))
hl.bind("SUPER + L", hl.dsp.focus("r"))
hl.bind("SUPER + K", hl.dsp.focus("u"))
hl.bind("SUPER + J", hl.dsp.focus("d"))
hl.bind("ALT + Tab", hl.dsp.workspace.move("previous"))

-- Window movement
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move("l"))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move("r"))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move("u"))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move("d"))

-- Window modes
hl.bind("SUPER + M", hl.dsp.window.fullscreen())
hl.bind("SUPER + F", hl.dsp.window.float())

-- Workspace switching
hl.bind("CTRL + 1", hl.dsp.workspace.move(1))
hl.bind("CTRL + 2", hl.dsp.workspace.move(2))
hl.bind("CTRL + 3", hl.dsp.workspace.move(3))
hl.bind("CTRL + 4", hl.dsp.workspace.move(4))
hl.bind("CTRL + 5", hl.dsp.workspace.move(5))
hl.bind("CTRL + 6", hl.dsp.workspace.move(6))
hl.bind("CTRL + 7", hl.dsp.workspace.move(7))
hl.bind("CTRL + 8", hl.dsp.workspace.move(8))
hl.bind("CTRL + 9", hl.dsp.workspace.move(9))
hl.bind("CTRL + 0", hl.dsp.workspace.move(10))

-- Move window to workspace
hl.bind("CTRL + SHIFT + 1", hl.dsp.window.move("workspace:1"))
hl.bind("CTRL + SHIFT + 2", hl.dsp.window.move("workspace:2"))
hl.bind("CTRL + SHIFT + 3", hl.dsp.window.move("workspace:3"))
hl.bind("CTRL + SHIFT + 4", hl.dsp.window.move("workspace:4"))
hl.bind("CTRL + SHIFT + 5", hl.dsp.window.move("workspace:5"))
hl.bind("CTRL + SHIFT + 6", hl.dsp.window.move("workspace:6"))
hl.bind("CTRL + SHIFT + 7", hl.dsp.window.move("workspace:7"))
hl.bind("CTRL + SHIFT + 8", hl.dsp.window.move("workspace:8"))
hl.bind("CTRL + SHIFT + 9", hl.dsp.window.move("workspace:9"))
hl.bind("CTRL + SHIFT + 0", hl.dsp.window.move("workspace:10"))

-- Special workspace
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move("special:magic"))

-- Workspace scrolling
hl.bind("SUPER + mouse_down", hl.dsp.workspace.move("e+1"))
hl.bind("SUPER + mouse_up", hl.dsp.workspace.move("e-1"))

-- Mouse bindings
hl.bind("SUPER + mouse:272", hl.dsp.window.move())
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
    "grim -g \"$(slurp)\" -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/screenshow-$(date '+%Y%m%d-%H:%M:%S').png"
  )
)
hl.bind("SUPER + CTRL + Q", hl.dsp.exec_cmd("hyprlock"))

-- Resize submap
hl.define_submap("resize", "escape", function()
  hl.bind("l", hl.dsp.window.resize("10 0"), { repeating = true })
  hl.bind("h", hl.dsp.window.resize("-10 0"), { repeating = true })
  hl.bind("k", hl.dsp.window.resize("0 -10"), { repeating = true })
  hl.bind("j", hl.dsp.window.resize("0 10"), { repeating = true })
end)

-- Activate resize submap
hl.bind("ALT + R", hl.dsp.submap("resize"))
