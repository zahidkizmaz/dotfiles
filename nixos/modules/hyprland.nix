{ pkgs, ... }:
{
  programs = {
    hyprland.enable = true;
    hyprland.withUWSM = true;
    hyprlock.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hypridle
    hyprlock
    hyprsunset
    lxqt.lxqt-policykit
  ];
}
