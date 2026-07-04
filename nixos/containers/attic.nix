{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "attic";
  port = 8989;
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

        age.secrets.attic-jwt-secret = {
          file = ../secrets/attic-jwt-secret.age;
        };

        environment.systemPackages = with pkgs; [ attic-client ];

        services.atticd = {
          enable = true;
          mode = "monolithic";
          environmentFile = config.age.secrets.attic-jwt-secret.path;
          settings = {
            listen = "[::]:${toString port}";
          };
        };
        system.stateVersion = stateVersion;
      };
  };
}
