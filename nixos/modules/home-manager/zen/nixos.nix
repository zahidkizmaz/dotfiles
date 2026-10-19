{ inputs, ... }:
let
  shared = import ./shared.nix;

  # Linux-only prefs on top of the shared set.
  prefs = shared.prefs // {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "layout.css.devPixelsPerPx" = "1.5";

    # hardware acceleration
    "gfx.color_management.native_srgb" = true;
    "media.hardware-video-decoding.force-enabled" = true;
  };
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    inherit (shared) policies;
    profiles.default.settings = prefs;
  };
}
