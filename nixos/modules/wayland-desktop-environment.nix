{ pkgs, ... }:
{
  imports = [
    ./icons.nix
  ];
  environment.systemPackages = with pkgs; [
    brightnessctl
    copyq
    grim
    playerctl
    satty
    slurp
    tofi
    udiskie
    vicinae
    wl-clipboard
  ];

  programs = {
    dconf.enable = true;
  };
  services = {
    udisks2.enable = true;
    upower.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_cosmos";
    };
  };
}
