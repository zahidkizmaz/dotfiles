{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "amdgpu"
    "nvme"
    "thunderbolt"
    "ucsi_acpi"
    "usb_storage"
    "usbhid"
    "xhci_pci"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [
    "rcu_nocbs=all"
    "rcutree.enable_rcu_lazy=1"
  ];

  hardware.enableRedistributableFirmware = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
