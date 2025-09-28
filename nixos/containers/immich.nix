{
  stateVersion,
  localAddress,
  hostAddress,
  port,
  inputs,
  user,
  bridgeInterface,
  ...
}:
let
  containerName = "immich";
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
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
    allowedDevices = [
      {
        node = "/dev/net/tun";
        modifier = "rwm";
      }
    ];
    # https://man7.org/linux/man-pages/man7/capabilities.7.html
    additionalCapabilities = [
      # Needed for tailscale
      "CAP_NET_ADMIN"
      "CAP_NET_RAW"
      # Not specifically needed for anything, but useful in a container setting
      "CAP_MKNOD"
    ];
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
        };

        system.stateVersion = stateVersion;
      };
  };
}
