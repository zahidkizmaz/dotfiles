{ config, inputs, pkgs, lib, modulesPath, stateVersion, user, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" "uas" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  hardware.firmware = [
    pkgs.ivsc-firmware
  ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/047c901f-696a-444e-ae42-59f9ba7d42a2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D7A0-0D40";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 10 * 1024; # 10GB
  }];

  console = { keyMap = "us"; };
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";
  networking = {
    hostName = "sgo2";
    useDHCP = lib.mkDefault true;
    firewall.enable = true;
  };

  home-manager = {
    users = { "${user}" = import ./home.nix; };
    extraSpecialArgs = { inherit inputs user stateVersion; };
  };
  nix.settings.trusted-users = [ "root" "${user}" "@wheel" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = stateVersion;
}
