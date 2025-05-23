{
  lib,
  system,
  user,
  ...
}:
{

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
