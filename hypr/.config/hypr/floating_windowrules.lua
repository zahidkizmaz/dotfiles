-- ── Generic dialog popups ───────────────────────────────────────────────────
-- These title-based patterns catch application modal dialogs, file pickers,
-- and other transient popups regardless of application class.

local dialog_titles = {
  "^(Open File)(.*)$",
  "^(Select a File)(.*)$",
  "^(Save As)(.*)$",
  "^(Save File)(.*)$",
  "^(Open Folder)(.*)$",
  "^(Choose)(.*)$",
  "^(Library)(.*)$",
  "^(File Upload)(.*)$",
  "^(Authentication Required)(.*)$",
  "^(Connect to)(.*)$",
  "^(Confirm to Replace)(.*)$",
  "^(Moving)(.*)$",
  "^(Copying)(.*)$",
  "^(Extracting)(.*)$",
  "^(Progress)(.*)$",
  "^(Preparing)(.*)$",
  ".*Dialog.*",
  ".*wants to.*",
}

for _, title in ipairs(dialog_titles) do
  hl.window_rule({ match = { title = title }, float = true })
  hl.window_rule({ match = { title = title }, center = true })
end

-- ── Portal / file chooser dialogs ───────────────────────────────────────────

local portal_classes = {
  "^(xdg-desktop-portal-gtk)$",
  "^(Xdg-desktop-portal-gtk)$",
  "^(xdg-desktop-portal-hyprland)$",
  "^(Xdg-desktop-portal-hyprland)$",
  "^org.freedesktop.impl.portal.*$",
}

for _, class in ipairs(portal_classes) do
  hl.window_rule({ match = { class = class }, float = true })
  hl.window_rule({ match = { class = class }, center = true })
  hl.window_rule({ match = { class = class }, border_size = 0 })
  hl.window_rule({ match = { class = class }, no_blur = true })
  hl.window_rule({ match = { class = class }, size = { "monitor_w*0.82", "monitor_h*0.50" } })
end

-- ── System utility windows ──────────────────────────────────────────────────

hl.window_rule({ match = { class = ".*blueman.*" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "^(blueberry\\.py)$" }, float = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "Pavucontrol" }, float = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })

hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, size = { "monitor_w*0.45", "monitor_h*0.45" } })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, size = { "monitor_w*0.45", "monitor_h*0.45" } })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, size = { "monitor_w*0.45", "monitor_h*0.45" } })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, center = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, center = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, center = true })

-- ── KDE utility windows ─────────────────────────────────────────────────────

local kde_classes = {
  "org.kde.ark",
  "org.kde.kcharselect",
  "org.kde.kgpg",
  "org.kde.kcalc",
  "org.kde.kcachegrind",
  "org.kde.ktimer",
  "org.kde.skanpage",
  "org.kde.partitionmanager",
  "org.kde.kwalletmanager5",
  "org.kde.filelight",
  "org.gnome.FileRoller",
}

for _, class in ipairs(kde_classes) do
  hl.window_rule({ match = { class = class }, float = true })
end

-- ── Other application windows ───────────────────────────────────────────────

hl.window_rule({ match = { class = "com.github.hluk.copyq" }, float = true })
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, center = true })
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, size = { "monitor_w*0.35", "monitor_h*0.35" } })
hl.window_rule({ match = { class = "com.github.hluk.copyq" }, stay_focused = true })

-- JetBrains IDEs: prevent splash/project picker from stealing focus
hl.window_rule({ match = { class = "jetbrains-.*" }, no_initial_focus = true })

-- Dialog class names (catches GTK/Qt dialogs not matched by title)
hl.window_rule({ match = { class = ".*[Dd]ialog.*" }, float = true })

-- Steam popup dialogs
hl.window_rule({ match = { title = "^(Friends List)$" }, float = true })
hl.window_rule({ match = { title = "^(Steam Settings)$" }, float = true })
hl.window_rule({ match = { class = "^(steam)$" }, float = true })
hl.window_rule({ match = { class = ".*steam.*" }, float = true })

-- Apps that work best as floating windows
hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true })
hl.window_rule({ match = { class = "^(Signal)$" }, float = true })
hl.window_rule({ match = { class = "^(eog)$" }, float = true })

-- Zotero: reference manager — float at a reasonable size
hl.window_rule({ match = { class = "^(Zotero)$" }, float = true })
hl.window_rule({ match = { class = "^(Zotero)$" }, size = { "monitor_w*0.45", "monitor_h*0.45" } })
hl.window_rule({ match = { class = "org.manjaro.pamac.manager" }, float = true })
hl.window_rule({ match = { class = "Pamac-manager" }, float = true })
hl.window_rule({ match = { class = "org.keepassxc.KeePassXC" }, float = true })

-- ── Per-app floating defaults ───────────────────────────────────────────────
-- When floated, these apps open at a sensible size and centered.

hl.window_rule({ match = { class = "kitty" }, size = { 1600, 900 } })
hl.window_rule({ match = { class = "kitty" }, center = true })
hl.window_rule({ match = { class = "firefox" }, size = { 1200, 800 } })
hl.window_rule({ match = { class = "org.kde.dolphin" }, size = { 1000, 700 } })
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, size = { 800, 600 } })

-- ── Picture-in-Picture windows ──────────────────────────────────────────────

local pip_title = "^([Pp]icture[%-]?[Ii]n[%-]?[Pp]icture)(.*)$"

hl.window_rule({ match = { title = pip_title }, float = true })
hl.window_rule({ match = { title = pip_title }, pin = true })
hl.window_rule({ match = { title = pip_title }, keep_aspect_ratio = true })
hl.window_rule({ match = { title = pip_title }, size = { "monitor_w*0.15", "monitor_h*0.15" } })
hl.window_rule({ match = { title = pip_title }, move = { "monitor_w*0.82", "monitor_h*0.09" } })

-- ── Game performance ─────────────────────────────────────────────────────────
-- Immediate mode (direct scanout) prevents stutter and tearing in fullscreen
-- games run through Wine/Proton, Steam, or natively.

hl.window_rule({ match = { class = ".*%.exe" }, immediate = true })
hl.window_rule({ match = { class = "^steam_app.*" }, immediate = true })
hl.window_rule({ match = { class = ".*[Mm]inecraft.*" }, immediate = true })

-- ── No border / no blur on file upload and portal windows ───────────────────

hl.window_rule({ match = { title = "File Upload$" }, border_size = 0 })
hl.window_rule({ match = { title = "File Upload$" }, no_blur = true })
