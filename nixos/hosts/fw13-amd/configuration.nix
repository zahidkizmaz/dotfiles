{ pkgs, ... }:
{
  imports = [
    ./disko.nix
  ];

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
