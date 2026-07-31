# Placeholder — will be regenerated on-device after initial install
{ lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "uas"
  ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  # /boot/firmware (FAT firmware partition) is provided by the sd-image module

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
