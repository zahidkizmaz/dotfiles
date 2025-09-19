{
  stateVersion,
  localAddress,
  hostAddress,
  port,
  ...
}:
{
  containers.paperless-ngx = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";
    forwardPorts = [
      {
        hostPort = port;
        containerPort = port;
        protocol = "tcp";
      }
    ];
    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        services.paperless = {
          enable = true;
          port = 8080;
          address = "${localAddress}";
        };

        system.stateVersion = stateVersion;
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ port ];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
  };
}
