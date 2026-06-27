{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  containerName = "forgejo";
  webPort = 3000;
  sshPort = 2222; # non-privileged port; forgejo's systemd service drops CAP_NET_BIND_SERVICE
  tsUrl = "https://${containerName}.quoll-ratio.ts.net";
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

        networking.firewall.allowedTCPPorts = [
          webPort
          sshPort
        ];

        services = {
          forgejo = {
            enable = true;
            stateDir = "/var/lib/forgejo";
            database = {
              type = "postgres";
              createDatabase = true;
            };
            dump.enable = true;
            settings = {
              server.ROOT_URL = tsUrl;
              server.START_SSH_SERVER = true;
              server.DISABLE_SSH = false;
              server.SSH_PORT = sshPort;
              server.SSH_LISTEN_PORT = sshPort;
              mirror.ENABLED = true;
            };
          };
          postgresql = {
            enable = true;
            package = pkgs.postgresql_18;
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
