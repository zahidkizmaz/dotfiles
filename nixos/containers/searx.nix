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

        services.searx = {
          enable = true;
          redisCreateLocally = true;
          settings = {
            use_default_settings = true;
            server = {
              port = port;
              bind_address = "0.0.0.0";
            };
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
