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

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.oci-containers = {
          backend = "podman";
          containers.hermes-agent = {
            autoStart = true;
            image = "docker.io/nousresearch/hermes-agent@sha256:46a555b8461fc43829fb591799231adf8d5fde971c1466fd172f335cfc014137";
            volumes = [
              "hermes-data:/opt/data:rw"
            ];
            environment = {
              HERMES_HOME = "/opt/data";
            };
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
            # Dashboard binds to 127.0.0.1:8080 (localhost) — with host
            # networking, this IS the NixOS container's localhost, so
            # tailscale-serve can reach it directly. No port publishing,
            # no --insecure needed.
            cmd = [
              "dashboard"
              "--port"
              "8080"
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
