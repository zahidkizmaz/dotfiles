{
  stateVersion,
  localAddress,
  hostAddress,
  port,
  inputs,
  ...
}:
let
  containerName = "paperless";
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    enableTun = true;
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";
    allowedDevices = [
      {
        modifier = "rwm";
        node = "/dev/net/tun";
      }
    ];
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
        imports = [
          (import ./container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              port
              ;
          })
        ];
        services.paperless = {
          enable = true;
          port = 8080;
          address = "${localAddress}";
        };

        system.stateVersion = stateVersion;
        networking = {
          hostName = containerName;
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
