{
  inputs,
  lib,
  system,
  user,
  stateVersion,
  pkgs,
  ...
}:
{
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      "${user}" = import ./home.nix;
    };
    extraSpecialArgs = {
      inherit
        inputs
        user
        system
        stateVersion
        ;
    };
  };
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true; # This fixes Touch ID for sudo not working inside tmux and screen.
  };

  system = {
    primaryUser = "${user}";
    stateVersion = 6;
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

  nixpkgs.hostPlatform = lib.mkDefault system;
}
