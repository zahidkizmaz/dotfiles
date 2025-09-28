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
    hostBridge = bridgeInterface;
    localAddress = "${localAddress}/24";
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
          port = 8080;
          host = "${localAddress}";
        };

        system.stateVersion = stateVersion;
        networking = {
          hostName = containerName;
          interfaces."eth0".useDHCP = true;

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
  };
}
