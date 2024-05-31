{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    copyq
    dconf
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
