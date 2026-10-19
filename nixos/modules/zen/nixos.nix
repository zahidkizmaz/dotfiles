{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  prefs = (import ./shared.nix).prefs // {
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "layout.css.devPixelsPerPx" = "1.5";

    # hardware acceleration
    "gfx.color_management.native_srgb" = true;
    "media.hardware-video-decoding.force-enabled" = true;
  };
in
{
  environment.systemPackages = [
    (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta.override {
      extraPolicies = (import ./shared.nix).policies;
      extraPrefs = lib.concatLines (
        lib.mapAttrsToList (
          name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
        ) prefs
      );
    })
  ];
}
