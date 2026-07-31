{ stateVersion, ... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";

  networking = {
    hostName = "home";
    wireless.enable = false;
    firewall.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  time.timeZone = "Europe/Berlin";

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
