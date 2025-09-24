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
    hostAddress = "${hostAddress}";
    localAddress = "${localAddress}";
    bindMounts = {
      "/etc/ssh/lab" = {
        hostPath = "/home/${user}/.ssh/lab";
        isReadOnly = true;
      };
    };
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

        services.immich = {
          enable = true;
          port = 8080;
          host = "${localAddress}";
        };

        system.stateVersion = stateVersion;
        networking = {
          hostName = containerName;
          firewall = {
            enable = true;
            trustedInterfaces = [ "ve-*" ];
            allowedTCPPorts = [ port ];
            allowedUDPPorts = [ 41641 ]; # Tailscale default port
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
  };
}
