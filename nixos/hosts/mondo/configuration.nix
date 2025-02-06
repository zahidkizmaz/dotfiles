{
  pkgs,
  lib,
  system,
  config,
  ...
}:
{
  nixpkgs.hostPlatform = lib.mkDefault system;
  system = {
    stateVersion = 5;

    keyboard = {
      enableKeyMapping = true;
      swapLeftCtrlAndFn = true;
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

  # Make nix daemon work
  programs = {
    zsh = {
      shellInit = ''
        [[ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]] && source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      '';
    };
  };
}
