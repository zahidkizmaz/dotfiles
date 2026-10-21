{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "runner";
  runnerConfigFile = "/data/runner-config.yml";
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
              ;
          })
        ];

        age.secrets.forgejo-runner-config = {
          file = ../secrets/forgejo-runner1-config.age;
          mode = "0444";
        };

        networking.firewall.allowedTCPPorts = [ ];
        networking.hostName = "runner";

        virtualisation.podman = {
          enable = true;
          dockerSocket.enable = true;
          defaultNetwork.settings.dns_enabled = true;
          autoPrune = {
            enable = true;
            dates = "weekly";
            flags = [ "--filter until=24h" ];
          };
        };
        virtualisation.oci-containers = {
          backend = "podman";
          containers."forgejo-runner" = {
            autoStart = true;
            image = "data.forgejo.org/forgejo/runner@sha256:ca3d5eea46004789a175d1369eec6829d3ea9bfbe2011a06625b4bdaa55f7552";
            user = "0:0";
            volumes = [
              "/run/docker.sock:/var/run/docker.sock"
              "${config.age.secrets.forgejo-runner-config.path}:${runnerConfigFile}:ro"
            ];
            cmd = [
              "forgejo-runner"
              "daemon"
              "--config"
              runnerConfigFile
            ];

          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
