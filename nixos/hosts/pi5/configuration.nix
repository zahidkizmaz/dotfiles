{ lib, stateVersion, ... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";

  # zfs is enabled by default in nixpkgs' profiles/base.nix but is unused here
  # (no pools); disabling it avoids pulling the zfs kernel module (and with it
  # the kernel dev output) into the closure.
  boot.supportedFilesystems.zfs = lib.mkForce false;

  networking = {
    hostName = "home";
    wireless.enable = false;
    firewall.enable = true;
  };

  tailscaleExitNode.enable = true;

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

  # fsck/panic/network-watchdog yes; hardware watchdog NOT enabled because
  # systemd's PID1 feed is unreliable on BCM2712 (reboot-loop risk) -- test
  # on-box before flipping piResilience.hardwareWatchdog to true.
  piResilience.enable = true;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  nix.settings.trusted-users = [ "@wheel" ];

  system.stateVersion = stateVersion;
}
