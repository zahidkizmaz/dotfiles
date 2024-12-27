{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany # web browser
    geary # email reader
    evince # document viewer
  ];

  environment.systemPackages = with pkgs; [
    copyq
    wl-clipboard

    gnome-tweaks
    # extensions
    gnomeExtensions.window-gestures
    gnomeExtensions.caffeine
  ];
}
