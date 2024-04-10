{pkgs, ...}: {
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    dconf
    hypridle
    hyprlock
    xdg-desktop-portal-hyprland
  ];
}
