-- Float rules
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, float = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })
hl.window_rule({ match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Open File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Choose wallpaper)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, float = true })
hl.window_rule({ match = { title = "^(Authentication Required)(.*)$" }, float = true })
hl.window_rule({ match = { title = ".*Dialog.*" }, float = true })
hl.window_rule({ match = { class = ".*blueman.*" }, float = true })
hl.window_rule({ match = { class = "^(steam)$" }, float = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ match = { class = ".*steam.*" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "Pavucontrol" }, float = true })
hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true })
hl.window_rule({ match = { class = "org.kde.ark" }, float = true })
hl.window_rule({ match = { class = "org.kde.kcharselect" }, float = true })
hl.window_rule({ match = { class = "org.kde.kgpg" }, float = true })
hl.window_rule({ match = { class = "org.kde.kcalc" }, float = true })
hl.window_rule({ match = { class = "org.kde.kcachegrind" }, float = true })
hl.window_rule({ match = { class = "org.kde.ktimer" }, float = true })
hl.window_rule({ match = { class = "org.kde.skanpage" }, float = true })
hl.window_rule({ match = { class = "org.kde.partitionmanager" }, float = true })
hl.window_rule({ match = { class = "org.manjaro.pamac.manager" }, float = true })
hl.window_rule({ match = { class = "Pamac-manager" }, float = true })
hl.window_rule({ match = { class = "org.keepassxc.KeePassXC" }, float = true })
hl.window_rule({ match = { class = "org.kde.kwalletmanager5" }, float = true })
hl.window_rule({ match = { class = "org.kde.filelight" }, float = true })

-- Size rules
hl.window_rule({ match = { class = "kitty" }, size = { 1600, 900 } })
hl.window_rule({ match = { class = "firefox" }, size = { 1200, 800 } })
hl.window_rule({ match = { class = "org.kde.dolphin" }, size = { 1000, 700 } })
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, size = { 800, 600 } })
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, size = { "monitor_w*0.35", "monitor_h*0.35" } })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, size = { "monitor_w*0.82", "monitor_h*0.50" } })
hl.window_rule({
  match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" },
  size = { "monitor_w*0.15", "monitor_h*0.15" },
})
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, size = { "monitor_w*0.45", "monitor_h*0.45" } })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, size = { "monitor_w*0.45", "monitor_h*0.45" } })

-- Center rules
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, center = true })
hl.window_rule({ match = { title = "^(Open File)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Choose wallpaper)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" }, center = true })
hl.window_rule({ match = { title = "^(Authentication Required)(.*)$" }, center = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, center = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, center = true })
hl.window_rule({ match = { class = "kitty" }, center = true })

-- Stay focused rules
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, stay_focused = true })
hl.window_rule({ match = { title = "(pinentry-)(.*)" }, stay_focused = true })

-- Move rules
hl.window_rule({
  match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" },
  move = { "monitor_w*0.82", "monitor_h*0.09" },
})

-- Pin and keep aspect ratio rules
hl.window_rule({ match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" }, pin = true })
hl.window_rule({ match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" }, keep_aspect_ratio = true })

-- Border size rules
hl.window_rule({ match = { class = "Xdg-desktop-portal-gtk$" }, border_size = 0 })
hl.window_rule({ match = { title = "File Upload$" }, border_size = 0 })

-- No blur rules
hl.window_rule({ match = { class = "Xdg-desktop-portal-gtk$" }, no_blur = true })
hl.window_rule({ match = { title = "File Upload$" }, no_blur = true })

-- Browser: hide the screen-sharing notification bar (the "Hide" button on it is broken on Wayland)
hl.window_rule({ match = { title = ".*is sharing.*" }, workspace = "special silent" })

-- Smart gaps: no border/rounding on non-floating windows in single-tiled workspaces
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
