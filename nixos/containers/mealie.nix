{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "meal";
  port = 8080;
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
          mealie = {
            enable = true;
            port = port;
            database.createLocally = true;
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
