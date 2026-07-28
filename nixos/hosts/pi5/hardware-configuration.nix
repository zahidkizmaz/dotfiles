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
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
