{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Media players
    mpv

    # Chat
    telegram-desktop

    # PW manager
    bitwarden

    # Note taking
    joplin-desktop

    # Browsers
    brave
    firefox
    librewolf
  ];
}
