{ stateVersion, ... }:
{
  containers.nginx = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.20";
    localAddress = "192.168.100.12";
    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        services.nginx = {
          enable = true;
          statusPage = true;
        };

        system.stateVersion = stateVersion;

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 ];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
  };
}
