{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "forgejo";
  webPort = 3000;
  tsUrl = "https://${containerName}.quoll-ratio.ts.net";
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "identity";
    enableTun = true;
    ephemeral = false;
    hostAddress = hostAddress;
    localAddress = localAddress;
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
          ./container-common.nix
          (import ./container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              ;
            port = webPort;
          })
        ];

        networking.firewall.allowedTCPPorts = [ webPort ];

        services = {
          forgejo = {
            enable = true;
            stateDir = "/var/lib/forgejo";
            database = {
              type = "postgres";
              createDatabase = true;
            };
            dump.enable = true;
            settings = {
              server.ROOT_URL = tsUrl;
              server.START_SSH_SERVER = true;
              server.DISABLE_SSH = false;
              mirror.ENABLED = true;
            };
          };
          postgresql = {
            enable = true;
            package = pkgs.postgresql_18;
          };
        };

        # forgejo's built-in SSH server needs CAP_NET_BIND_SERVICE for port 22.
        # Remove PrivateUsers to avoid nested user namespace conflicts.
        systemd.services.forgejo.serviceConfig = {
          PrivateUsers = lib.mkForce false;
          CapabilityBoundingSet = lib.mkForce [ "CAP_NET_BIND_SERVICE" ];
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        };

        system.stateVersion = stateVersion;
      };
  };
}
