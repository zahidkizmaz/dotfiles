{
  inputs,
  stateVersion,
  user,
  system,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./suspend_tricks.nix
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.fwupd.enable = true;
  powerManagement.powertop.enable = true;

  nix.settings.secret-key-files = [ config.age.secrets.fw13-nix-signing.path ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024; # 64GB
    }
  ];

  networking = {
    hostName = "fw13-amd";
  };
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "us";
  };

  time.timeZone = "Europe/Berlin";

  system.stateVersion = stateVersion;

  # Increase the dbus-broker reload timeout. It defaults to 90s, which is
  # too short when dbus clients (e.g. shell, portal) take long to acknowledge
  # the reconfiguration during nixos-rebuild switch.
  systemd.user.services.dbus-broker.serviceConfig.TimeoutReloadSec = 300;
}
