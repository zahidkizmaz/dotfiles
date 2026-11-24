{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
  # PR #183: start fingerprint auth without pressing Enter. Not merged yet, so
  # track the fork's `fingerprint-autostart` branch instead of the released
  # version from unstable. The fork is still 1.7.0; keep version in sync so
  # versionCheckHook passes (it compares the binary's --version against the
  # derivation version).
  noctalia-greeter = pkgs-unstable.noctalia-greeter.overrideAttrs (_: {
    version = "1.7.0";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "AdityaKr015";
      repo = "noctalia-greeter";
      rev = "3d6d1630254a2e6b2d3a7b000a78ba3094772183";
      hash = "sha256-XEC+T5rPL7JcmrC02DB0seply1SDqJ8EY/CpoJXT3KY=";
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
