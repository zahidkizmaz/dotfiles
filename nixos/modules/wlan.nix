{ pkgs, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
  hardware.firmware = [ pkgs.wireless-regdb ];
  environment.systemPackages = [ pkgs.iw ];
}
