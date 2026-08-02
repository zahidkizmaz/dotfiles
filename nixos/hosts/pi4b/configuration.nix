{ lib, stateVersion, ... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";

  # zfs is enabled by default in nixpkgs' profiles/base.nix but is unused here
  # (no pools); disabling it avoids pulling the zfs kernel module (and with it
  # the kernel dev output) into the closure.
  boot.supportedFilesystems.zfs = lib.mkForce false;

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

  # Compressed in-RAM swap absorbs memory spikes first; the SD swapfile
  # above stays only as a last-resort overflow so flash isn't written.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  # Keep logs off the SD card (they're shipped to Loki anyway).
  services.journald = {
    storage = "volatile";
    extraConfig = "RuntimeMaxUse=64M";
  };

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
