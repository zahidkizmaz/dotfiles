{
  pkgs,
  lib,
  system,
  ...
}:
{
  nixpkgs.hostPlatform = lib.mkDefault system;
  system = {
    stateVersion = 5;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };
      dock = {
        autohide = true;
      };
    };
  };

  environment.shells = [ pkgs.nushell ];
  system.activationScripts.set_sh.text # bash
    = ''
      chsh -s /run/current-system/sw/bin/nu
    '';

  services.nix-daemon.enable = true;
  # # TODO: convert to nushell?
  # # Make nix daemon work
  # programs = {
  #   zsh = {
  #     shellInit = ''
  #       [[ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]] && source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  #     '';
  #   };
  # };
}
