{ pkgs, ... }:
{
  imports = [
    ./icons.nix
    ./wayland-env.nix
  ];
  environment.systemPackages = with pkgs; [
    brightnessctl
    copyq
    glib
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
