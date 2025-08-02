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
    pkgs.element-desktop

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
    pkgs.firefox
    pkgs.librewolf

    # Utilities
    pkgs.kdePackages.partitionmanager
    pkgs.kdePackages.qt6ct
  ];
}
