{ pkgs, ... }:
{
  imports = [ ./dunst.nix ./icons.nix ];
  environment.systemPackages = with pkgs; [
    brightnessctl
    copyq
    grim
    networkmanagerapplet
    pcmanfm
    playerctl
    slurp
    tofi
    wl-clipboard
  ];

  programs.dconf.enable = true;
}
