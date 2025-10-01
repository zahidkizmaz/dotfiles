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
  containerName = "immich";
in
{
  imports = [
    (import ./backup.nix {
      dataFolder = "/var/lib/immich";
      backupFolder = containerName;
      inherit user;
    })
  ];
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "pick";
    enableTun = true;
    ephemeral = false;
    hostAddress = hostAddress;
    localAddress = localAddress;
    bindMounts = {
      "/etc/ssh/lab" = {
        hostPath = "/home/${user}/.ssh/lab";
        isReadOnly = true;
      };
      immichData = {
        mountPoint = "/var/lib/immich:idmap";
        hostPath = "/home/${user}/backup/immich";
        isReadOnly = false;
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

        services.immich = {
          enable = true;
          port = port;
          host = "0.0.0.0";
        };

        system.stateVersion = stateVersion;
      };
  };
}
