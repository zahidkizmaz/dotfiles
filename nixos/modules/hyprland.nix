{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs = {
    hyprland.enable = true;
    hyprland.withUWSM = true;
    hyprland.package = pkgs-unstable.hyprland;
    hyprlock.enable = true;
  };

  environment.systemPackages = with pkgs-unstable; [
    hypridle
    hyprlock
    hyprsunset
    lxqt.lxqt-policykit
  ];
}
