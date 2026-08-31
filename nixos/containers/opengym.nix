{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "opengym";
  apiPort = 3000;
  webPort = 8080;
  port = webPort;
  dataPath = "/var/lib/opengym/data";
  mediaPath = "/var/lib/opengym/media";
  opengym-src = fetchGit {
    url = "https://github.com/arvids-unavailable/openGym";
    rev = "c42ba6b98e3776af5981f20c05ba392238799670";
  };
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
          # Built from auto-cloned openGym repo
          containers.opengym-api = {
            autoStart = true;
            # Path to api directory within the cloned repo
            build = "${opengym-src}/api";
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
          # Built from same auto-cloned openGym repo
          containers.opengym-web = {
            autoStart = true;
            # Path to the root of the cloned repo (web/Dockerfile is at web/Dockerfile relative to repo root)
            build = "${opengym-src}";
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
