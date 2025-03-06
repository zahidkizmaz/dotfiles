{
  inputs,
  lib,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = system; };
in
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

  environment.shells = [ pkgs-unstable.nushell ];
  environment.systemPackages = [ pkgs-unstable.nushell ];

  services.nix-daemon.enable = true;
}
