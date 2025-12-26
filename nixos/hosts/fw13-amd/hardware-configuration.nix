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
  boot.kernelModules = [
    "kvm-amd"
    "amd-pstate"
  ];
  boot.kernelParams = [
    "rcu_nocbs=all"
    "rcutree.enable_rcu_lazy=1"

    "amd_pstate=active"
    "mem_sleep_default=s2idle"
    "amdgpu.dcdebugmask=0x10"

    # USB autosuspend
    "usbcore.autosuspend=1"
    "usbcore.autosuspend_delay_ms=100"

    # Thunderbolt - allow D3
    "thunderbolt.dyndbg=+p"

    # remove the line below in case usb4 issues
    # should help with the system sleep
    "acpi_mask_gpe=0x10"
  ];

  # WiFi power saving (for Intel WiFi cards)
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=1 power_level=5 uapsd_disable=0
    options iwlmvm power_scheme=3
  '';

  hardware.enableRedistributableFirmware = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
