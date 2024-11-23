{ inputs, pkgs, lib, modulesPath, stateVersion, user, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = stateVersion;
}
