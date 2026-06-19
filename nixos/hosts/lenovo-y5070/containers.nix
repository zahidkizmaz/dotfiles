{ config, ... }:

{
  imports = [
    ../../modules/host-networking.nix
    ../../containers
  ];

  hostNetworking = {
    enable = true;
    externalInterface = "enp9s0";
    tailscaleAuthKey = config.age.secrets.tailscale-lab.path;
  };

  appContainers = {
    enable = true;
    containers = {
      ollama = {
        enable = true;
        models = [
          "gemma4:e4b"
          "gemma4:e2b"
        ];
      };
      hermes-agent = {
        enable = true;
      };
      vane = {
        enable = true;
      };
    };

    # Remote backup to Filen (no local backup drive on this host)
    backup = {
      enable = true;
      resticPassword = config.age.secrets.restic-password.path;
      targets = [
        {
          name = "filen";
          type = "rclone";
          rcloneConfig = config.age.secrets.rclone-config-filen.path;
          remotePath = "filen-backend:backup-y5070/";
          schedule = "Fri *-*-* 04:30:00";
          prune = [ "--keep-weekly 3" ];
        }
      ];
      containers = [
        {
          name = "hermes";
          containerPath = "/var/lib/containers/storage/volumes/hermes-data/_data";
          backupFolderName = "hermes";
        }
      ];
    };
  };
}
