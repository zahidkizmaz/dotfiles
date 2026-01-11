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
  containerName = "watch";
  domain = "${containerName}.quoll-ratio.ts.net";
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
    extraFlags = [
      "--capability=CAP_NET_ADMIN"
      "--capability=CAP_SYS_ADMIN"
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

        age = {
          identityPaths = [ "/etc/ssh/lab" ];
          secrets = {
            companion_env = {
              file = ../secrets/companion_env.age;
            };
            invidious_extra_conf = {
              file = ../secrets/invidious_extra_conf.age;
              mode = "0444";
            };
          };
        };

        services.invidious = {
          enable = true;
          port = port;
          address = "0.0.0.0";
          settings = {
            domain = domain;
            https_only = true;
            external_port = 443;
            invidious_companion = [
              {
                private_url = "http://localhost:8282/companion";
              }
            ];
          };
          extraSettingsFile = config.age.secrets.invidious_extra_conf.path;
        };

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
        virtualisation.oci-containers = {
          backend = "podman";
          containers = {
            invidious-companion = {
              autoStart = true;
              image = "quay.io/invidious/invidious-companion@sha256:cb28f5d7cb183a3eeee2664145e319497f22fa70afaf7111eb17fb636a937e9a";
              ports = [ "127.0.0.1:8282:8282" ];
              volumes = [
                "companioncache:/var/tmp/youtubei.js:rw"
              ];
              environmentFiles = [ config.age.secrets.companion_env.path ];
            };
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
