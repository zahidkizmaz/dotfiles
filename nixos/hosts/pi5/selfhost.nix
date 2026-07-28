{ pkgs, config, ... }:
{
  services = {
    devmon.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libsecret

    # Cloud
    filen-cli
  ];

  # Auto-mount backup SanDisk drive
  fileSystems."/backup" = {
    device = "/dev/disk/by-label/sandisk-backup";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
      "compress=zstd"
    ];
  };

  system.activationScripts.script.text = # bash
    ''
      chmod a+rwx /dev/ttyACM0
    '';
}
