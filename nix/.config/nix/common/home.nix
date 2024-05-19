{ config, pkgs, inputs, ... }:

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

  programs.firefox = {
    enable = true;
    profiles.zahid = {
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.compactmode.show" = true;
        "browser.download.panel.shown" = true;
        "dom.security.https_only_mode" = true;
        "extensions.pocket.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };
      search.force = true;

      bookmarks = [
        {
          name = "Arch Linux";
          tags = [ ];
          keyword = "arch";
          url = "https://archlinux.org/";
        }
        {
          name = "Github";
          tags = [ ];
          keyword = "gh";
          url = "https://github.com/";
        }
      ];

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        clearurls
        darkreader
        facebook-container
        ublock-origin
        startpage-private-search
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
