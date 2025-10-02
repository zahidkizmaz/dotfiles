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
  containerName = "search";
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

        age = {
          identityPaths = [ "/etc/ssh/lab" ];
          secrets = {
            searx-secret = {
              file = ../secrets/searx-secret.age;
            };
          };
        };

        services.searx = {
          enable = true;
          redisCreateLocally = true;
          settings = {
            use_default_settings = true;
            server = {
              port = port;
              bind_address = "0.0.0.0";
              secret_key = "@SEARX_SECRET_KEY@";
            };
            environmentFile = config.age.secrets.searx-secret.path;
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
