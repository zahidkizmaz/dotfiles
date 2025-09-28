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
        # imports = [
        #   (import ./container-tailscale.nix {
        #     inherit
        #       config
        #       inputs
        #       lib
        #       pkgs
        #       port
        #       ;
        #   })
        # ];

        services.immich = {
          enable = true;
          port = port;
          host = "${localAddress}";
        };

        system.stateVersion = stateVersion;
      };
  };
}
