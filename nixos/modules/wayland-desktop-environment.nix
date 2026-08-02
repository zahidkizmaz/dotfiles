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

  environment = {
    # Chromium-based and Electron apps use native Wayland instead of XWayland.
    # The nixpkgs chromium wrapper picks this up to add --ozone-platform-hint=auto.
    variables.NIXOS_OZONE_WL = "1";
  };

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
