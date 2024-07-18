{ lib, pkgs, user, ... }:
{
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  networking = {
    hostName = "pi4b";
    interfaces.eth0.useDHCP = true;
    wireless.enable = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [ 22 443 ];
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "input" "wheel" "video" "audio" "storage" ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };
  time.timeZone = "Europe/Berlin";

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16GB
  }];

  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  system.stateVersion = "24.05";
}