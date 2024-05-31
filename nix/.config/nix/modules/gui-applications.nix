{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Media players
    spotify
    mpv

    # Chat
    telegram-desktop

    # PW manager
    bitwarden

    # Note taking
    joplin-desktop

    # Browsers
    brave
    librewolf
  ];
}
