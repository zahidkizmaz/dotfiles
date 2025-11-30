{ pkgs, ... }:
{

  services = {
    desktopManager = {
      gnome.enable = true;
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };
  };

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    decibels # music player
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gnome-connections
    gnome-contacts
    gnome-maps
    gnome-tour
    orca
    seahorse # password manager
    totem # video player
    yelp # help viewer
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
