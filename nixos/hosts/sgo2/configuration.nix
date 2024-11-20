{ lib, modulesPath, stateVersion, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 10 * 1024; # 10GB
  }];

  console = { keyMap = "us"; };
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";
  networking = {
    hostName = "sgo2";
    useDHCP = lib.mkDefault true;
    firewall.enable = true;
  };

  system.stateVersion = stateVersion;
}
