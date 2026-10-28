{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
in
{
  # The noctalia-greeter module is not in 26.05 yet, so import it from unstable.
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/display-managers/noctalia-greeter.nix"
  ];

  # Only exists in unstable; 26.05 installs the pkexec wrapper unconditionally.
  options.security.polkit.enablePkexecWrapper = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config.services.displayManager.noctalia-greeter = {
    enable = true;
    package = pkgs-unstable.noctalia-greeter;
    # The greeter's wlroots compositor reads XCursor themes only, not hyprcursor.
    cursorTheme = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
    };
    settings = {
      # Let an empty submit start pam_fprintd instead of demanding a password.
      auth.allow_empty_password = true;
      appearance.scheme = "Catppuccin";
      cursor.size = 18;
      keyboard.layout = "us";
    };
  };
}
