{ stateVersion, ... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";
  # SD card has a single FAT partition mounted at /boot
  boot.loader.raspberry-pi.firmwarePath = "/boot";

  networking = {
    hostName = "home";
    wireless.enable = false;
    firewall.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
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

  atticClient.enable = true;

  nix.settings.trusted-users = [ "@wheel" ];

  system.stateVersion = stateVersion;
}
