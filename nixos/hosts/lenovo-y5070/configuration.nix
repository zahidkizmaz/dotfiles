{
  pkgs,
  user,
  inputs,
  stateVersion,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager = {
    users = {
      "${user}" = import ./home.nix;
    };
    extraSpecialArgs = {
      inherit
        inputs
        user
        stateVersion
        ;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  networking.hostName = "y5070";

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };
  services.thermald.enable = true;

  # Keeps the CPU/GPU from boosting
  # when idle and caps charge on this always-plugged-in 2014 laptop.
  services.tlp = {
    enable = true;
    settings = {
      # CPU - powersave governor lets cores drop to idle clocks; boost stays
      # enabled so attic-auto-builder (dev shell builds) isn't crippled.
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MAX_PERF_ON_AC = "100";
      CPU_MAX_PERF_ON_BAT = "50";

      # PCIe ASPM - lets the GPU/SSD enter deep link power states
      PCIE_ASPM_ON_AC = "powersupersave";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # Battery - this machine lives on AC, cap charge to extend battery life
      STOP_CHARGE_THRESH_BAT0 = "80";
      STOP_CHARGE_THRESH_BAT1 = "80";

      # USB
      USB_AUTOSUSPEND = "1";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  time.timeZone = "Europe/Berlin";

  atticAutoBuilder = {
    buildDevShells = true;
    additionalDevShellSystems = [ "aarch64-linux" ];
    runFlakeUpdate = true;
  };

  atticClient = {
    enable = true;
    watch.enable = true;
  };

  system.stateVersion = stateVersion;
}
