{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    casks = [
      "android-studio"
      "camo-studio"
      "copyq"
      "ghostty"
      "hammerspoon"
      "orbstack"
      "raycast"
    ];
  };
}
