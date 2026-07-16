{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
      extraFlags = [
        "--force-cleanup"
      ];
    };
    casks = [
      "android-studio"
      "bettercapture"
      "camo-studio"
      "copyq"
      "ghostty"
      "hammerspoon"
      "keepingyouawake"
      "orbstack"
      "raycast"
      "sf"
    ];
  };
}
