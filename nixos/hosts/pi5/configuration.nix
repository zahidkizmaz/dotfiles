{ stateVersion, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    raspberry-pi.firmware = {
      # Enable activation script to populate firmware on the ESP
      enable = true;
      # ESP is at /boot (disko layout), not /boot/firmware
      path = "/boot";
      # U-Boot chainload: firmware → u-boot.bin → extlinux.conf → kernel
      uboot.enable = true;
    };
  };
  networking = {
    hostName = "home";
    wireless.enable = false;
    firewall.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "us";
  };
  time.timeZone = "Europe/Berlin";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  systemd.settings.Manager = {
    DefaultCPUAccounting = true;
    DefaultIOAccounting = true;
    DefaultBlockIOAccounting = true;
    DefaultMemoryAccounting = true;
    DefaultTasksAccounting = true;
  };

  nixpkgs.overlays = [
    # deadnix: skip
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  atticClient.enable = true;

  nix.settings.trusted-users = [ "@wheel" ];

  system.stateVersion = stateVersion;
}
