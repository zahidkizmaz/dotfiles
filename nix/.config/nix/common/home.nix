{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zahid";
  home.homeDirectory = "/home/zahid";

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  gtk = {
    enable = true;
    cursorTheme.name = "macOS-Monterey-Dark";
    cursorTheme.package = pkgs.apple-cursor;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
    theme.name = "Catppuccin-Mocha-Standard-Pink-Dark";
    theme.package = pkgs.catppuccin-gtk.override {
      accents = [ "pink" ];
      size = "standard";
      variant = "mocha";
    };
  };

  xdg.enable = true;
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
