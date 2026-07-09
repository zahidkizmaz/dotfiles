{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "hermes";
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
              ;
            port = 8080;
          })
        ];

        age.secrets.forgejo-hermes-token = {
          file = ../secrets/forgejo-hermes-token.age;
          mode = "0444";
        };

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.oci-containers = {
          backend = "podman";
          containers.hermes-agent = {
            autoStart = true;
            # https://hub.docker.com/r/nousresearch/hermes-agent/tags
            image = "docker.io/nousresearch/hermes-agent@sha256:4d78cd97e9fd875b4e22cb787f24c9715f7761fce3c8b6dcee301096def3415c";
            environment = {
              HERMES_HOME = "/opt/data";
            };
            volumes = [
              "hermes-data:/opt/data:rw"
              "${config.age.secrets.forgejo-hermes-token.path}:/run/secrets/forgejo-token:ro"
            ];
            # s6-overlay needs these capabilities for process supervision:
            #   SETUID/SETGID/CHOWN: privilege dropping
            #   DAC_OVERRIDE/FOWNER: create supervision lock files in /run/service
            #   SYS_ADMIN: privileged operations during service startup
            capabilities = {
              SETUID = true;
              SETGID = true;
              CHOWN = true;
              DAC_OVERRIDE = true;
              FOWNER = true;
              SYS_ADMIN = true;
            };
            extraOptions = [
              "--tmpfs=/tmp:rw,noexec,nosuid,size=64M"
              "--tmpfs=/run:rw,nosuid,size=64M"
              "--restart=unless-stopped"
              # Share the NixOS container's network so the agent can reach
              # ollama at 192.168.100.25:11434 and tailscale DNS names.
              "--network=host"
            ];
            # --host 0.0.0.0 accepts any Host header (needed behind
            # tailscale-serve). --insecure disables OAuth gate (no provider
            # configured). Safe — only reachable via tailscale-serve.
            cmd = [
              "dashboard"
              "--port"
              "8080"
              "--host"
              "0.0.0.0"
              "--insecure"
              "--skip-build"
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
