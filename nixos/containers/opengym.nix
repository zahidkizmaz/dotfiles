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
  webPort = 8080;
  port = webPort;
  dataPath = "/var/lib/opengym/data";
  mediaPath = "/var/lib/opengym/media";
  projectDir = "/opt/opengym";
  opengymSrc = fetchGit {
    url = "https://github.com/zahidkizmaz/openGym";
    rev = "59ea86197d6d5a55cc016c11f67de428f18cfb14";
    shallow = true;
  };
  opengymEnv = ''
    RP_ID=gym.quoll-ratio.ts.net
    ORIGIN=https://gym.quoll-ratio.ts.net
    RP_NAME=openGym
    WEB_PORT=${toString webPort}
  '';
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

        environment.systemPackages = with pkgs; [
          podman-compose
          rsync
        ];

        systemd.tmpfiles.rules = [
          "d ${projectDir} 0755 root root -"
          "d ${dataPath} 0755 root root -"
          "d ${mediaPath} 0755 root root -"
        ];

        systemd.services.opengym-setup = {
          description = "Sync openGym source and env";
          wantedBy = [ "multi-user.target" ];
          before = [ "opengym-compose.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            set -euo pipefail
            mkdir -p ${projectDir} ${dataPath} ${mediaPath}
            ${pkgs.rsync}/bin/rsync -a --delete \
              --exclude=/data --exclude=/media --exclude=/.env --exclude=/.git \
              ${opengymSrc}/ ${projectDir}/
            printf %s ${lib.escapeShellArg opengymEnv} > ${projectDir}/.env
            ${pkgs.coreutils}/bin/ln -sfn ${dataPath} ${projectDir}/data
            ${pkgs.coreutils}/bin/ln -sfn ${mediaPath} ${projectDir}/media
          '';
        };

        systemd.services.opengym-compose = {
          description = "openGym podman compose up";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network-online.target"
            "opengym-setup.service"
          ];
          wants = [ "network-online.target" ];
          requires = [ "opengym-setup.service" ];
          path = with pkgs; [
            podman
            podman-compose
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            WorkingDirectory = projectDir;
            ExecStart = "${pkgs.podman-compose}/bin/podman-compose -f ${projectDir}/docker-compose.yml up -d --build";
            ExecStop = "${pkgs.podman-compose}/bin/podman-compose -f ${projectDir}/docker-compose.yml down";
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
