{ inputs, pkgs, stateVersion, user, system, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  home-manager = {
    users = { "${user}" = import ./home.nix; };
    extraSpecialArgs = { inherit inputs user system stateVersion; };
  };


  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  networking = {
    hostName = "y5070";
  };

  services = {
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_MAX_PERF_ON_AC = "100";
        CPU_MAX_PERF_ON_BAT = "30";
        STOP_CHARGE_THRESH_BAT1 = "95";
        STOP_CHARGE_THRESH_BAT0 = "95";
      };
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };

  time.timeZone = "Europe/Berlin";

  system.stateVersion = stateVersion;
}
