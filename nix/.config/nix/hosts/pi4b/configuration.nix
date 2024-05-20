{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "pi4b";
    networkmanager.enable = true;
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.178.24";
      prefixLength = 24;
    }];
    wireless.enable = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [ 22 80 443 ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };
  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    gitMinimal
    magic-wormhole
    neovim
  ];

  system.stateVersion = "24.05";
}
