{
  inputs,
  pkgs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
in
{
  # bitwarden depends on electron-39 which is EOL. Track upstream fix:
  # https://github.com/bitwarden/clients/pull/20448
  # Remove this override once nixpkgs bumps the electron dep.
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
    "electron-40.10.5"
  ];

  programs = {
    localsend.enable = true;
  };

  environment.systemPackages = [
    # Media players
    pkgs.mpv

    # Chat
    pkgs.telegram-desktop
    pkgs.fractal

    # PW manager
    pkgs.bitwarden-desktop
    pkgs.ente-auth

    # Note taking
    pkgs-unstable.joplin-desktop
    pkgs.trilium-desktop

    # Cloud
    pkgs.filen-cli
    pkgs.filen-desktop

    # Browsers
    pkgs.brave
    pkgs.firefox-bin
    pkgs.librewolf

    # Utilities
    pkgs-unstable.nwg-displays
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.gwenview
    pkgs.kdePackages.partitionmanager
    pkgs.kdePackages.qt6ct
  ];
}
