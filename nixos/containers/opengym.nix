{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  # Container name
  containerName = "opengym";
  # Port configuration for Tailscale networking
  apiPort = 3000;
  webPort = 8080;
  port = webPort;
  # Data and media paths
  dataPath = "/var/lib/opengym/data";
  mediaPath = "/var/lib/opengym/media";
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

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.oci-containers = {
          backend = "podman";

          # API service - Node.js backend with WebAuthn
          # Built from source - openGym repo cloned via fetchGit
          containers.opengym-api = {
            autoStart = true;
            # Build from ./api directory in the cloned repo
            build = ./api;
            environment = {
              PORT = toString apiPort;
              DATA_DIR = dataPath;
              RP_ID = config.networking.hostName;
              ORIGIN = "https://${config.networking.hostName}.quoll-ratio.ts.net";
              RP_NAME = "openGym";
            };
            volumes = [
              "${dataPath}:${dataPath}:rw"
            ];
            extraOptions = [
              "--restart=unless-stopped"
              "--network=host"
            ];
            autoRemoveOnStop = false;
          };

          # Web service - nginx serving React frontend
          # Built from source - root of cloned repo with web/Dockerfile
          containers.opengym-web = {
            autoStart = true;
            # Build from root with web/Dockerfile
            build = ./.;
            dockerfile = "web/Dockerfile";
            environment = {
              # nginx listens on port 80 internally, tailscale-serve exposes on 443
            };
            volumes = [
              "${mediaPath}/img:/usr/share/nginx/html/img:ro"
              "${mediaPath}/gif:/usr/share/nginx/html/gif:ro"
            ];
            extraOptions = [
              "--restart=unless-stopped"
              "--network=host"
            ];
            autoRemoveOnStop = false;
          };
        };

        # Pre-create data directories with correct permissions
        environment.etc."containers/containers.conf".text = lib.mkForce ''
          [engine]

          [containers]
          keyring = false
        '';

        system.stateVersion = stateVersion;
      };
  };
}
