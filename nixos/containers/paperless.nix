{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "paperless";
  tsUrl = "https://${containerName}.quoll-ratio.ts.net";
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

        services.paperless = {
          enable = true;
          port = port;
          database.createLocally = true;
          settings = {
            PAPERLESS_URL = tsUrl;
            PAPERLESS_ALLOWED_HOSTS = tsUrl;
            PAPERLESS_CSRF_TRUSTED_ORIGINS = tsUrl;
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
