{
  inputs,
  pkgs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
in
{
  programs = {
    localsend.enable = true;
  };

  # Thunar needs GVfs for trash:// and remote locations. `thunar-volman` is
  # deliberately not installed: udiskie already handles removable media.
  services.gvfs.enable = true;

  environment.systemPackages = [
    # Media players
    pkgs.mpv

    # Chat
    pkgs.telegram-desktop
    pkgs.fractal

    # PW manager
    pkgs-unstable.bitwarden-desktop
    pkgs.ente-auth

    # Note taking
    pkgs-unstable.joplin-desktop
    pkgs-unstable.trilium-desktop

    # Cloud
    pkgs.filen-cli
    pkgs.filen-desktop

    # Browsers
    pkgs.firefox-bin
    pkgs.librewolf

    # Utilities
    pkgs-unstable.nwg-displays
    # File manager (GTK, so the existing catppuccin GTK theme and Papirus icons
    # apply unchanged). Thunar's thumbnailer daemon is `tumbler`.
    pkgs.thunar
    pkgs.tumbler
    pkgs.kdePackages.gwenview
    pkgs.kdePackages.partitionmanager
    pkgs.kdePackages.qt6ct
  ];
}
