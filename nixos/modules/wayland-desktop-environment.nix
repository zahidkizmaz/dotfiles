{ pkgs, ... }:
{
  imports = [
    ./dunst.nix
    ./icons.nix
  ];
  environment.systemPackages = with pkgs; [
    brightnessctl
    copyq
    grim
    kdePackages.dolphin
    networkmanagerapplet
    playerctl
    satty
    slurp
    tofi
    udiskie
    wl-clipboard
  ];

  programs = {
    dconf.enable = true;
    uwsm.enable = true;
  };
  services = {
    udisks2.enable = true;
  };
}
