{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs = {
    hyprland.enable = true;
    hyprland.package = pkgs-unstable.hyprland;
    hyprlock.enable = true;
  };
  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = false;
  };
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
