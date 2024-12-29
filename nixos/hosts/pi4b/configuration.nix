{ stateVersion, ... }:
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

  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };
  time.timeZone = "Europe/Berlin";

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16GB
  }];

  nixpkgs.overlays = [
    # deadnix: skip
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  system.stateVersion = stateVersion;
}
