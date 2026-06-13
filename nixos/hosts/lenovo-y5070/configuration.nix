{
  config,
  pkgs,
  lib,
  user,
  inputs,
  system,
  stateVersion,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  home-manager = {
    users = {
      "${user}" = import ./home.nix;
    };
    extraSpecialArgs = {
      inherit
        inputs
        user
        system
        stateVersion
        ;
    };
  };

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
    Login.HandleLidSwitch = "ignore";
    Login.HandleLidSwitchExternalPower = "ignore";
    Login.HandleLidSwitchDocked = "ignore";
  };
  services.thermald.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  time.timeZone = "Europe/Berlin";

  # Host networking (NAT + host tailscale) - ready for future containers
  hostNetworking = {
    enable = true;
    externalInterface = "enp2s0"; # TODO: verify with `ip link`
    tailscaleAuthKey = config.age.secrets.tailscale-lab.path;
  };

  # NO containers enabled yet
  appContainers.enable = [ ];

  # Backup disabled (no containers to backup)
  appContainers.backup.enable = false;

  system.stateVersion = stateVersion;
}
