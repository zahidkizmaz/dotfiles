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
  containerName = "paperless";
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

        services.paperless = {
          enable = true;
          port = port;
          address = "0.0.0.0";
          settings = {
            PAPERLESS_ALLOWED_HOSTS = "${containerName}.quoll-ratio.ts.net";
            PAPERLESS_CORS_ALLOWED_HOSTS = "${containerName}.quoll-ratio.ts.net";
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
