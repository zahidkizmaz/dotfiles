{ ... }:

{
  imports = [ ./settings.nix ];

  containers.adguard = {
    autoStart = true;

    config = { config, pkgs, lib, ... }: {
      services.adguardhome = {
        enable = true;
        port = 3000;
      };
      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 3000 ];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      system.stateVersion = "24.05";
    };
  };
}
