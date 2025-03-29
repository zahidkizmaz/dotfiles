{ pkgs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
  };
  hardware.firmware = [ pkgs.wireless-regdb ];
  environment.systemPackages = [ pkgs.iw ];
}
