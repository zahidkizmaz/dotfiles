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
  port = 3000;
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
              port
              ;
          })
        ];

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
              mirror.ENABLED = true;
            };
          };
          postgresql = {
            enable = true;
            package = pkgs.postgresql_18;
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
