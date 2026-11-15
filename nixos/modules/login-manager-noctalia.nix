{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
  # PR #183: start fingerprint auth without pressing Enter. Not merged yet, so
  # track the fork's branch instead of the released version from unstable.
  noctalia-greeter = pkgs-unstable.noctalia-greeter.overrideAttrs (_: {
    src = pkgs-unstable.fetchFromGitHub {
      owner = "AdityaKr015";
      repo = "noctalia-greeter";
      rev = "fb9daa9471fe1e6cdb8504678fe1cd5592c1d9aa";
      hash = "sha256-AHqcFM0pAENr01cPuKf6JMf/UDj/RM7Vm1LyXZSKeaM=";
    };
  });
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
    package = noctalia-greeter;
    # The greeter's wlroots compositor reads XCursor themes only, not hyprcursor.
    cursorTheme = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
    };
    settings = {
      # PR #183: start pam_fprintd when the password step appears, no Enter needed.
      auth.auto_start_pam = true;
      # Empty submit still allowed to reach PAM (passwordless/smartcard).
      auth.allow_empty_password = true;
      appearance.scheme = "Catppuccin";
      cursor.size = 18;
      keyboard.layout = "us";
    };
  };
}
