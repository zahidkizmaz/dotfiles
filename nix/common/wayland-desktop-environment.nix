{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blueman
    copyq
    dunst
    grim
    networkmanagerapplet
    playerctl
    slurp
    tofi
    wl-clipboard
    xdg-utils
  ];
}
