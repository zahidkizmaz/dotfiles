{ pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
  };
  environment.systemPackages = [
    pkgs.wireless-regdb
  ];
}
