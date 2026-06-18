{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "onecli";
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
      # SSH key for agenix tailscale secret decryption
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
              ;
            port = 10254;
          })
        ];

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        # Postgresql's systemd service uses mount namespacing that requires
        # dataDir to exist BEFORE the service starts (preStart runs too late).
        # The default dataDir uses StateDirectory; for custom paths like this,
        # we need tmpfiles to pre-create it.
        systemd.tmpfiles.rules = [
          "d /var/lib/onecli/postgres 0700 postgres postgres -"
        ];

        services.postgresql = {
          enable = true;
          package = pkgs.postgresql_18;
          dataDir = "/var/lib/onecli/postgres";
          ensureDatabases = [ "onecli" ];
          ensureUsers = [
            {
              name = "onecli";
              ensureDBOwnership = true;
            }
          ];
          authentication = ''
            local all all peer
            host all onecli 127.0.0.1/32 trust
            host all onecli ::1/128 trust
          '';
        };

        services.postgresqlBackup = {
          enable = true;
          databases = [ "onecli" ];
          location = "/var/backup/postgresql/onecli";
          compression = "zstd";
          startAt = "02:30";
        };

        # --- OneCLI (OCI container) ---
        virtualisation.oci-containers = {
          backend = "podman";
          containers.onecli = {
            autoStart = true;
            image = "ghcr.io/onecli/onecli@sha256:277208dd5c1ed8f667c937d54c67bd1e88b8b0dde32d30ebe5363b44498fa2fd";
            volumes = [
              "onecli-app:/app/data:rw"
            ];
            environment = {
              DATABASE_URL = "postgresql://onecli@localhost:5432/onecli";
            };
            autoRemoveOnStop = false;
            extraOptions = [
              "--cap-drop=ALL"
              "--security-opt=no-new-privileges"
              "--read-only"
              "--tmpfs=/tmp:rw,noexec,nosuid,size=64M"
              # Share host network to reach PostgreSQL on localhost:5432
              "--network=host"
              # Auto-restart if container crashes
              "--restart=unless-stopped"
            ];
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
