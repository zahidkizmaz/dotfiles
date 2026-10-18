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
      "hammerspoon"
      "keepingyouawake"
      "orbstack"
      "raycast"
      "salesforce-cli"
      "zen"
    ];
  };
}
