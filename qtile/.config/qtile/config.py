import os
import re
import subprocess
from typing import List  # noqa: F401
from typing import Any, Dict

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from src.choices import Colors

mod = "mod1"
terminal = "kitty"

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        ["mod4"],
        "space",
        lazy.spawn("rofi -show drun"),
        desc="Run rofi",
    ),
    Key(
        [mod],
        "Tab",
        lazy.spawn(
            'rofi -show window -kb-accept-entry "!Alt-Tab,!Alt+Alt_L,Return" -kb-row-down "Alt+Tab" -selected-row 1'
        ),
        desc="Run rofi window switcher",
    ),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                ["control"],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                ["control", "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

LAYOUT_DEFAULTS = {
    "border_focus": Colors.CATPUCCIN_WHITE.value,
    "border_normal": Colors.CATPUCCIN_BLACK.value,
    "margin": 8,
    "border_width": 3,
}
layouts = [
    layout.MonadTall(**LAYOUT_DEFAULTS),
    layout.Max(**LAYOUT_DEFAULTS),
]

BAR_SIZE: int = 24
BAR_MARGIN: List[int] = [4, 10, 0, 10]
WIDGET_DEFAULTS: Dict[str, Any] = dict(
    fontsize=14,
    padding=4,
    font="OpenDyslexic Nerd Font",
)

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text=" ",
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                    **WIDGET_DEFAULTS,
                ),
                widget.CurrentLayout(
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                    **WIDGET_DEFAULTS,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.GroupBox(
                    borderwidth=4,
                    active=Colors.PURE_WHITE.value,
                    inactive=Colors.DARK_BLACK.value,
                    block_highlight_text_color=Colors.CATPUCCIN_CYAN.value,
                    this_current_screen_border=Colors.CATPUCCIN_CYAN.value,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                    highlight_method="line",
                    **WIDGET_DEFAULTS,
                ),
                widget.Spacer(),
                widget.WindowName(**WIDGET_DEFAULTS),
                widget.Spacer(length=10),
                widget.Systray(
                    **WIDGET_DEFAULTS,
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.BatteryIcon(
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Battery(
                    charge_char="+",
                    discharge_char="",
                    unknown_char="",
                    format="{char}{percent:2.0%}",
                    **WIDGET_DEFAULTS,
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Volume(
                    emoji=True,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.PulseVolume(
                    **WIDGET_DEFAULTS,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.TextBox(
                    "",
                    fontsize=26,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Backlight(
                    backlight_name="intel_backlight",
                    **WIDGET_DEFAULTS,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.CATPUCCIN_BLUE.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Clock(
                    **WIDGET_DEFAULTS,
                    format="%d.%m.%y - %H:%M",
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
                widget.Spacer(
                    length=10,
                    background=Colors.DARK_YELLOW.value,
                    foreground=Colors.DARK_BLACK.value,
                ),
            ],
            size=BAR_SIZE,
            margin=BAR_MARGIN,
        )
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title=re.compile(r".*copyq*", re.IGNORECASE)),
    ]
)


auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


wmname = "LG3D"
