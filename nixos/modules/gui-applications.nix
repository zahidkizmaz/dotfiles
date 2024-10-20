{ inputs, pkgs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  environment.systemPackages = [
    # Media players
    pkgs.mpv

    # Chat
    pkgs.telegram-desktop
    pkgs.element-desktop

    # PW manager
    pkgs.bitwarden

    # Note taking
    pkgs-unstable.joplin-desktop

    # Browsers
    pkgs.brave
    pkgs.firefox
    pkgs.librewolf
  ];
}
