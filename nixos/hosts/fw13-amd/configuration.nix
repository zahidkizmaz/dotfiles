{
  inputs,
  pkgs,
  stateVersion,
  user,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./filesystem-tricks.nix
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
        stateVersion
        ;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.fwupd.enable = true;
  powerManagement.powertop.enable = true;

  # AMD s2idle debugging: amd-s2idle, amd-pstate, amd-bios, psr.
  # `amd-s2idle --logind` imports the `dbus` (dbus-python) module, which the
  # nixpkgs derivation doesn't declare, so add it back until fixed upstream.
  environment.systemPackages = [
    (pkgs.amd-debug-tools.overridePythonAttrs (old: {
      dependencies = (old.dependencies or [ ]) ++ [ pkgs.python3Packages.dbus-python ];
    }))
  ];

  services.logind = {
    settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
    };
  };

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

  atticClient.enable = true;

  system.stateVersion = stateVersion;

  # Increase the dbus-broker reload timeout. It defaults to 90s, which is
  # too short when dbus clients (e.g. shell, portal) take long to acknowledge
  # the reconfiguration during nixos-rebuild switch.
  systemd.user.services.dbus-broker.serviceConfig.TimeoutReloadSec = 300;
}
