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
      "camo-studio"
      "copyq"
      "ghostty"
      "hammerspoon"
      "logi-options+"
      "orbstack"
      "raycast"
    ];
  };
}
