{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.package = pkgs.catppuccin-qt5ct;
  };

  gtk = {
    enable = true;

    font = {
      name = "Arimo";
      size = 12;
    };

    cursorTheme = {
      size = 36;
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Catppuccin-GTK-Pink-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "pink" ];
        shade = "dark";
        size = "standard";
        tweaks = [ "macos" ];
      };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
