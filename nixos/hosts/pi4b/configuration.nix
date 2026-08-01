{ stateVersion, ... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";

  # Keep the SoC cool instead of boosting to 1.5GHz
  hardware.raspberry-pi.config.all.options = {
    arm_freq = {
      enable = true;
      value = 1200;
    };
  };
  powerManagement.cpuFreqGovernor = "ondemand";

  networking = {
    hostName = "pi4b";
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
