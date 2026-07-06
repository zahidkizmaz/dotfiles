{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
in
{
  programs = {
    hyprland.enable = true;
    hyprland.package = pkgs-unstable.hyprland;
  };
  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = false;
  };
  security.polkit.enable = true;

  environment.systemPackages = with pkgs-unstable; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    hyprland-qt-support
    libnotify
  ];
}
