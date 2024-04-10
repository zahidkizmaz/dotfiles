{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blueman
    copyq
    dunst
    glib
    grim
    networkmanagerapplet
    playerctl
    slurp
    tofi
    wl-clipboard
    xdg-utils
  ];
}
