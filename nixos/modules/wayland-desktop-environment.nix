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
    networkmanagerapplet
    pcmanfm
    playerctl
    slurp
    tofi
    udiskie
    wl-clipboard
  ];

  programs.dconf.enable = true;
  services = {
    udisks2.enable = true;
  };
}
