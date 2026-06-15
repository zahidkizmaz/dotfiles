{
  pkgs,
  user,
  inputs,
  system,
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
    Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };
  services.thermald.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  time.timeZone = "Europe/Berlin";

  system.stateVersion = stateVersion;
}
