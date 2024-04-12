{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    copyq
    dunst
    grim
    networkmanagerapplet
    pcmanfm
    playerctl
    slurp
    tofi
    wl-clipboard
  ];
}
