{ pkgs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  hardware = {
    enableAllFirmware = true;
    wirelessRegulatoryDatabase = true;
    firmware = [ pkgs.wireless-regdb ];
  };
  environment.systemPackages = [ pkgs.iw ];
}
