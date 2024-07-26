{ pkgs, ... }:
{
  imports = [
    ./disko.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 64 * 1024; # 64GB
  }];

  networking = {
    hostName = "fw13-amd";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    firefox
    gitMinimal
  ];

  system.stateVersion = "24.05";
}
