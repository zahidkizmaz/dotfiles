{ inputs, pkgs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    flavor = "mocha";
    accent = "pink";

    # Don't override all app settings automatically
    # Enable one by one
    enable = false;
    kvantum.enable = true;
    btop.enable = true;
    eza.enable = true;
    qt5ct.enable = true;
    brave.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "kvantum";
    };
  };

  gtk = {
    enable = true;

    font = {
      name = "Arimo";
      size = 14;
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

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "rose-pine-hyprcursor";
    size = 36;
    package = pkgs.rose-pine-hyprcursor;
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
