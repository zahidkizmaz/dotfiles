{
  stateVersion,
  localAddress,
  hostAddress,
  port,
  inputs,
  user,
  ...
}:
let
  containerName = "immich";
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    enableTun = true;
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";
    bindMounts = {
      "/etc/ssh/lab" = {
        hostPath = "/home/${user}/.ssh/lab";
        isReadOnly = true;
      };
    };
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
              ;
          })
        ];

        services.immich = {
          enable = true;
          port = 8080;
          host = "${localAddress}";
        };

        system.stateVersion = stateVersion;
        networking = {
          hostName = containerName;
          firewall = {
            enable = false;
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
