{pkgs, ...}: {
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hypridle
    hyprlock
    xdg-desktop-portal-hyprland
  ];
}
