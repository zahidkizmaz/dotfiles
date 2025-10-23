{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "ntfy";
  url = "https://${containerName}.quoll-ratio.ts.net";
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

        services.ntfy-sh = {
          enable = true;
          settings = {
            listen-http = ":${toString port}";
            base-url = url;
            upstream-base-url = "https://ntfy.sh"; # Needed for IOS setup see: https://docs.ntfy.sh/config/#ios-instant-notifications
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
