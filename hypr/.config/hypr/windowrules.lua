-- Float rules
hl.window_rule({ name = "float", match = { class = "com.github.hluk.copyq" } })
hl.window_rule({ name = "float", match = { class = "^(xdg-desktop-portal-gtk)$" } })
hl.window_rule({ name = "float", match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(Open File)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(Select a File)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(Choose wallpaper)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(Open Folder)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(Save As)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(Library)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(File Upload)(.*)$" } })
hl.window_rule({ name = "float", match = { title = "^(Authentication Required)(.*)$" } })
hl.window_rule({ name = "float", match = { title = ".*Dialog.*" } })
hl.window_rule({ name = "float", match = { class = ".*blueman.*" } })
hl.window_rule({ name = "float", match = { class = "^(steam)$" } })
hl.window_rule({ name = "float", match = { class = "^(org.pulseaudio.pavucontrol)$" } })
hl.window_rule({ name = "float", match = { class = "^(nm-connection-editor)$" } })
hl.window_rule({ name = "float", match = { class = ".*steam.*" } })
hl.window_rule({ name = "float", match = { class = "blueman-manager" } })
hl.window_rule({ name = "float", match = { class = "Pavucontrol" } })
hl.window_rule({ name = "float", match = { class = "org.gnome.Calculator" } })
hl.window_rule({ name = "float", match = { class = "org.kde.ark" } })
hl.window_rule({ name = "float", match = { class = "org.kde.kcharselect" } })
hl.window_rule({ name = "float", match = { class = "org.kde.kgpg" } })
hl.window_rule({ name = "float", match = { class = "org.kde.kcalc" } })
hl.window_rule({ name = "float", match = { class = "org.kde.kcachegrind" } })
hl.window_rule({ name = "float", match = { class = "org.kde.ktimer" } })
hl.window_rule({ name = "float", match = { class = "org.kde.skanpage" } })
hl.window_rule({ name = "float", match = { class = "org.kde.partitionmanager" } })
hl.window_rule({ name = "float", match = { class = "org.manjaro.pamac.manager" } })
hl.window_rule({ name = "float", match = { class = "Pamac-manager" } })
hl.window_rule({ name = "float", match = { class = "org.keepassxc.KeePassXC" } })
hl.window_rule({ name = "float", match = { class = "org.kde.kwalletmanager5" } })
hl.window_rule({ name = "float", match = { class = "org.kde.filelight" } })

-- Size rules
hl.window_rule({ name = "size 1600 900", match = { class = "kitty" } })
hl.window_rule({ name = "size 1200 800", match = { class = "firefox" } })
hl.window_rule({ name = "size 1000 700", match = { class = "org.kde.dolphin" } })
hl.window_rule({ name = "size 800 600", match = { class = "org.gnome.Nautilus" } })
hl.window_rule({ name = "size (monitor_w*0.35) (monitor_h*0.35)", match = { class = "com.github.hluk.copyq" } })
hl.window_rule({ name = "size (monitor_w*0.82) (monitor_h*0.50)", match = { class = "^(xdg-desktop-portal-gtk)$" } })
hl.window_rule({
  name = "size (monitor_w*0.15) (monitor_h*0.15)",
  match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" },
})
hl.window_rule({ name = "size (monitor_w*0.45) (monitor_h*0.45)", match = { class = "^(org.pulseaudio.pavucontrol)$" } })
hl.window_rule({ name = "size (monitor_w*0.45) (monitor_h*0.45)", match = { class = "^(nm-connection-editor)$" } })

-- Center rules
hl.window_rule({ name = "center", match = { class = "com.github.hluk.copyq" } })
hl.window_rule({ name = "center", match = { title = "^(Open File)(.*)$" } })
hl.window_rule({ name = "center", match = { title = "^(Select a File)(.*)$" } })
hl.window_rule({ name = "center", match = { title = "^(Choose wallpaper)(.*)$" } })
hl.window_rule({ name = "center", match = { title = "^(Open Folder)(.*)$" } })
hl.window_rule({ name = "center", match = { title = "^(Save As)(.*)$" } })
hl.window_rule({ name = "center", match = { title = "^(Library)(.*)$" } })
hl.window_rule({ name = "center", match = { title = "^(File Upload)(.*)$" } })
hl.window_rule({ name = "center", match = { title = "^(Authentication Required)(.*)$" } })
hl.window_rule({ name = "center", match = { class = "^(org.pulseaudio.pavucontrol)$" } })
hl.window_rule({ name = "center", match = { class = "^(nm-connection-editor)$" } })
hl.window_rule({ name = "center", match = { class = "kitty" } })

-- Stay focused rules
hl.window_rule({ name = "stay_focused", match = { class = "com.github.hluk.copyq" } })
hl.window_rule({ name = "stay_focused", match = { title = "(pinentry-)(.*)" } })

-- Move rules
hl.window_rule({
  name = "move (monitor_w*0.82) (monitor_h*0.09)",
  match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" },
})

-- Pin and keep aspect ratio rules
hl.window_rule({ name = "pin", match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" } })
hl.window_rule({ name = "keep_aspect_ratio", match = { title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$" } })

-- Border size rules
hl.window_rule({ name = "border_size 0", match = { class = "Xdg-desktop-portal-gtk$" } })
hl.window_rule({ name = "border_size 0", match = { title = "File Upload$" } })

-- No blur rules
hl.window_rule({ name = "no_blur", match = { class = "Xdg-desktop-portal-gtk$" } })
hl.window_rule({ name = "no_blur", match = { title = "File Upload$" } })

-- Workspace assignment rules
hl.window_rule({ name = "workspace 1", match = { class = "firefox" } })
hl.window_rule({ name = "workspace 2", match = { class = "kitty" } })
hl.window_rule({ name = "workspace 3", match = { class = "org.kde.dolphin" } })
hl.window_rule({ name = "workspace 4", match = { class = "org.gnome.Nautilus" } })
hl.window_rule({ name = "workspace 5", match = { class = "org.kde.kdenlive" } })
hl.window_rule({ name = "workspace 6", match = { class = "org.gnome.builder" } })
hl.window_rule({ name = "workspace 7", match = { class = "org.kde.krita" } })
hl.window_rule({ name = "workspace 8", match = { class = "org.gnome.TextEditor" } })
hl.window_rule({ name = "workspace 9", match = { class = "org.kde.konsole" } })
hl.window_rule({ name = "workspace 10", match = { class = "org.kde.yakuake" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.ark" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.kcharselect" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.kgpg" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.kcalc" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.kcachegrind" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.ktimer" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.skanpage" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.partitionmanager" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.manjaro.pamac.manager" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "Pamac-manager" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.keepassxc.KeePassXC" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.kwalletmanager5" } })
hl.window_rule({ name = "workspace special:magic", match = { class = "org.kde.filelight" } })
hl.window_rule({ name = "workspace special silent", match = { title = ".*is sharing.*" } })

-- Smart gaps: no border/rounding on non-floating windows in single-tiled workspaces
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })
