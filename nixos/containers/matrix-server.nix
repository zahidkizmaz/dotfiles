{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  port = 6167;
  containerName = "matrix";
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
    extraFlags = [
      "--capability=CAP_NET_ADMIN"
      "--capability=CAP_SYS_ADMIN"
    ];
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

        services.matrix-continuwuity = {
          enable = true;
          admin.enable = true;
          package = pkgs.matrix-continuwuity_latest;
          settings.global = {
            # Tailnet MagicDNS name; also what Element is configured with.
            server_name = "matrix.quoll-ratio.ts.net";
            allow_federation = false;
            allow_registration = false;
            allow_encryption = true;
            allow_announcements_check = false;
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
