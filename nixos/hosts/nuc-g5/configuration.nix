{ config, pkgs, lib, user, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];


  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32 * 1024; # 32GB
  }];


  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  console = { keyMap = "us"; };
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";
  networking = {
    hostName = "nuc-g5";
    useDHCP = lib.mkDefault true;
  };

  security.sudo.wheelNeedsPassword = false;
  users.users.${user} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "input" "wheel" "video" "audio" "storage" ];
  };

  environment.systemPackages = with pkgs; [
    gitMinimal
    neovim
  ];

  system.stateVersion = "24.05";
}
