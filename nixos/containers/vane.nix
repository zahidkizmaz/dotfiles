{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  port = 3000;
  containerName = "vane";
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

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.oci-containers = {
          backend = "podman";
          containers.vane = {
            autoStart = true;
            image = "docker.io/itzcrazykns1337/vane@sha256:aaf9da6bf76f01480c3e755388421029982e819773cbcecdcf0e9621a10e0690";
            environment = {
              SEARXNG_API_URL = "http://search.quoll-ratio.ts.net:8080";
            };
            volumes = [
              "vane-data:/home/vane/data:rw"
            ];
            extraOptions = [
              "--restart=unless-stopped"
              # Share the NixOS container's network so Vane can reach
              # ollama at 192.168.100.25:11434 and searxng via
              # search.quoll-ratio.ts.net:8080.
              "--network=host"
            ];
            autoRemoveOnStop = false;
          };
        };

        environment.etc."containers/containers.conf".text = lib.mkForce ''
          [engine]

          [containers]
          keyring = false
        '';

        system.stateVersion = stateVersion;
      };
  };
}
