{ pkgs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.settings = {
      Settings = {
        AutoConnect = true;
      };
    };
  };
  hardware.firmware = [ pkgs.wireless-regdb ];
  environment.systemPackages = [ pkgs.iw ];
}
