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

  nixpkgs.hostPlatform = lib.mkDefault system;
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
}
