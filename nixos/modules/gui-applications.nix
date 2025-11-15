{ inputs, pkgs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; };
in
{
  environment.systemPackages = [
    # Media players
    pkgs.mpv
    pkgs.freetube

    # Chat
    pkgs.telegram-desktop
    pkgs.fractal

    # PW manager
    pkgs.bitwarden
    pkgs.ente-auth

    # Note taking
    pkgs-unstable.joplin-desktop

    # Cloud
    pkgs.filen-cli
    pkgs.filen-desktop

    # Browsers
    pkgs.brave
    pkgs.firefox-bin
    pkgs.librewolf-bin

    # Utilities
    pkgs.nwg-displays
    pkgs.kdePackages.partitionmanager
    pkgs.kdePackages.qt6ct
  ];
}
