{ inputs, lib, ... }:
let
  zen = import ./shared.nix;
  zenProfile = name: id: {
    inherit id;
    # Profile Groups database name; must be 8 hex chars
    storeId = builtins.substring 0 8 (builtins.hashString "sha256" name);
    settings = zen.prefs;
    keyboardShortcutsVersion = 21;
    # ctrl+<n> switches macOS desktops instead of Zen spaces
    keyboardShortcuts = map (n: {
      id = "zen-workspace-switch-${toString n}";
      disabled = true;
    }) (lib.range 1 10);
  };
in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    inherit (zen) policies;
    profiles = {
      work = zenProfile "work" 0;
      personal = zenProfile "personal" 1;
    };
  };
}
