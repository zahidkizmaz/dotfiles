{
  inputs,
  stateVersion,
  user,
  system,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/latest-kernel.nix
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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024; # 64GB
    }
  ];

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    powerKey = "suspend-then-hibernate";
    powerKeyLongPress = "poweroff";
  };

  networking = {
    hostName = "fw13-amd";
  };
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "us";
  };

  time.timeZone = "Europe/Berlin";

  system.stateVersion = stateVersion;
}
