{ config, pkgs, ... }:
{
  services = {
    devmon.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libsecret

    # Cloud
    filen-cli
  ];

  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
      authKeyFile = config.age.secrets.tailscale-lab.path;
    };
  };

  system.activationScripts.script.text = # bash
    ''
      chmod a+rwx /dev/ttyACM0
    '';
}
