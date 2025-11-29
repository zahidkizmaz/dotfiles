{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs = {
    hyprland.enable = true;
    hyprland.package = pkgs-unstable.hyprland;
    hyprlock.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs-unstable; [
    hypridle
    hyprlock
    hyprsunset
    hyprpolkitagent
    hyprland-qt-support
    rose-pine-hyprcursor
  ];
}
