{ config, ... }:

{
  imports = [
    ../../modules/host-networking.nix
    ../../containers
  ];

  # Host networking (NAT + host tailscale)
  hostNetworking = {
    enable = true;
    externalInterface = "enp2s0";
    tailscaleAuthKey = config.age.secrets.tailscale-lab.path;
  };

  # EXACT same containers with EXACT same IPs
  appContainers = {
    enable = true;
    containers = {
      immich = {
        localAddress = "192.168.100.11";
      };
      searx = {
        localAddress = "192.168.100.13";
      };
      karakeep = {
        localAddress = "192.168.100.14";
      };
      stirling-pdf = {
        localAddress = "192.168.100.15";
      };
      navidrome = {
        localAddress = "192.168.100.16";
      };
      monitoring = {
        localAddress = "192.168.100.17";
      };
      paperless = {
        localAddress = "192.168.100.18";
      };
      mealie = {
        localAddress = "192.168.100.19";
      };
      ntfy = {
        localAddress = "192.168.100.20";
      };
      uptime-kuma = {
        localAddress = "192.168.100.21";
      };
      dns = {
        localAddress = "192.168.100.22";
      };
      watch = {
        localAddress = "192.168.100.23";
      };
      trilium = {
        localAddress = "192.168.100.24";
      };
    };

    # Backup with multiple targets (local drive + filen remote)
    backup = {
      enable = true;
      resticPassword = config.age.secrets.restic-password.path;
      targets = [
        {
          name = "local";
          type = "local";
          enabled = true;
          mountPath = "/backup";
          device = "/dev/disk/by-label/backup-drive";
          fsType = "btrfs";
          mountOptions = [
            "defaults"
            "noatime"
            "nofail"
            "compress=zstd"
          ];
          schedule = "03:00";
          prune = [ "--keep-daily 3" ];
        }
        {
          name = "filen";
          type = "rclone";
          enabled = true;
          rcloneConfig = config.age.secrets.rclone-config-filen.path;
          remotePath = "filen-backend:backups/";
          schedule = "Fri *-*-* 04:30:00";
          prune = [ "--keep-weekly 3" ];
        }
      ];
      containers = [
        {
          name = "immich";
          containerPath = "/var/lib/immich";
          backupFolderName = "immich";
        }
        {
          name = "notes";
          containerPath = "/var/lib/trilium";
          backupFolderName = "trilium";
        }
        {
          name = "paperless";
          containerPath = "/var/lib/paperless/export";
          backupFolderName = "paperless";
        }
        {
          name = "meal";
          containerPath = "/var/lib/private/mealie";
          backupFolderName = "mealie";
        }
        {
          name = "status";
          containerPath = "/var/lib/private/uptime-kuma";
          backupFolderName = "uptime-kuma";
        }
        {
          name = "keep";
          containerPath = "/var/lib/karakeep";
          backupFolderName = "karakeep";
        }
        {
          name = "monitoring";
          containerPath = "/var/lib/grafana/data";
          backupFolderName = "grafana";
        }
      ];
    };
  };
}
