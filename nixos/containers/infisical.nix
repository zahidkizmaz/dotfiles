{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "infisical";
  tailscaleHostname = "vault";
  webPort = 8080;
  dataDir = "/var/lib/infisical";
  envFile = "${dataDir}/.env";
  backupDir = "${dataDir}/backup";
  tsUrl = "https://${tailscaleHostname}.quoll-ratio.ts.net";
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
              ;
            port = webPort;
          })
        ];

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        services = {
          postgresql = {
            enable = true;
            package = pkgs.postgresql_16;
            ensureDatabases = [ "infisical" ];
            ensureUsers = [
              {
                name = "infisical";
                ensureDBOwnership = true;
              }
            ];
            # The Infisical container uses the NixOS container's host network.
            # PostgreSQL is only reachable on loopback inside this container.
            authentication = lib.mkForce ''
              local all all trust
              host all all 127.0.0.1/32 trust
              host all all ::1/128 trust
            '';
          };

          postgresqlBackup = {
            enable = true;
            databases = [ "infisical" ];
            location = backupDir;
            compression = "zstd";
            startAt = "01:15";
          };

          redis.servers.infisical = {
            enable = true;
            bind = "127.0.0.1";
            port = 6379;
            appendOnly = true;
          };
        };

        virtualisation.oci-containers = {
          backend = "podman";
          containers.infisical = {
            autoStart = true;
            # https://hub.docker.com/r/infisical/infisical/tags
            image = "infisical/infisical:v0.167.4@sha256:80a3bb51bee4092b7332d000506d5740ba57b1c4d48550e50746fe9c5209715d";
            environmentFiles = [ envFile ];
            environment = {
              NODE_ENV = "production";
            };
            # Reuse the NixOS container network so Postgres/Redis stay loopback-only.
            extraOptions = [ "--network=host" ];
          };
        };

        systemd.tmpfiles.rules = [
          "d ${dataDir} 0700 root root -"
          "d ${backupDir} 0700 postgres postgres -"
        ];

        systemd.services.infisical-env = {
          description = "Generate Infisical runtime secrets";
          wantedBy = [ "multi-user.target" ];
          before = [ "podman-infisical.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            UMask = "0077";
          };
          script = ''
            set -euo pipefail
            mkdir -p ${dataDir}
            if [ ! -s ${envFile} ]; then
              encryption_key=$(${pkgs.openssl}/bin/openssl rand -hex 16)
              auth_secret=$(${pkgs.openssl}/bin/openssl rand -base64 32 | tr -d '\n')

              ${pkgs.coreutils}/bin/cat > ${envFile} <<EOF
            ENCRYPTION_KEY=$encryption_key
            AUTH_SECRET=$auth_secret
            DB_CONNECTION_URI=postgres://infisical@127.0.0.1:5432/infisical
            REDIS_URL=redis://127.0.0.1:6379
            SITE_URL=${tsUrl}
            EOF
            fi
            chmod 0600 ${envFile}
          '';
        };

        systemd.services.podman-infisical = {
          after = [
            "infisical-env.service"
            "postgresql.service"
            "redis-infisical.service"
          ];
          requires = [
            "infisical-env.service"
            "postgresql.service"
            "redis-infisical.service"
          ];
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
