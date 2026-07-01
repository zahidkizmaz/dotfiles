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

  # Containers enabled on this host (IPs are centrally defined in containers/default.nix)
  appContainers = {
    enable = true;
    containers = {
      immich = {
        enable = true;
        hostname = "immich";
      };
      searx = {
        enable = true;
        hostname = "search";
      };
      karakeep = {
        enable = true;
        hostname = "keep";
      };
      stirling-pdf = {
        enable = true;
        hostname = "pdf";
      };
      navidrome = {
        enable = true;
        hostname = "music";
      };
      monitoring = {
        enable = true;
        hostname = "monitoring";
      };
      paperless = {
        enable = true;
        hostname = "paperless";
      };
      mealie = {
        enable = true;
        hostname = "meal";
      };
      ntfy = {
        enable = true;
        hostname = "ntfy";
      };
      uptime-kuma = {
        enable = true;
        hostname = "status";
      };
      dns = {
        enable = true;
        hostname = "dns";
      };
      watch = {
        enable = true;
        hostname = "watch";
      };
      trilium = {
        enable = true;
        hostname = "notes";
      };
      forgejo = {
        enable = true;
        hostname = "forgejo";
      };
      runner = {
        enable = true;
        hostname = "runner";
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
          successWebhook = "https://status.quoll-ratio.ts.net/api/push/8kR99oH7iUybBZngZSHjhnHGvP4RsW2n?status=up&msg=OK&ping=";
        }
        {
          name = "filen";
          type = "rclone";
          enabled = true;
          rcloneConfig = config.age.secrets.rclone-config-filen.path;
          remotePath = "filen-backend:backups/";
          schedule = "Fri *-*-* 04:30:00";
          prune = [ "--keep-weekly 3" ];
          successWebhook = "https://status.quoll-ratio.ts.net/api/push/cZZIgM4jInHDWQLDR6uKbWEInIHBujIu?status=up&msg=OK&ping=";
        }
      ];
      containers = [
        {
          name = "immich";
          containerPath = "/var/lib/immich";
          backupFolderName = "immich";
        }
        {
          name = "trilium";
          containerPath = "/var/lib/trilium";
          backupFolderName = "trilium";
        }
        {
          name = "paperless";
          containerPath = "/var/lib/paperless/export";
          backupFolderName = "paperless";
        }
        {
          name = "mealie";
          containerPath = "/var/lib/private/mealie";
          backupFolderName = "mealie";
        }
        {
          name = "uptime-kuma";
          containerPath = "/var/lib/private/uptime-kuma";
          backupFolderName = "uptime-kuma";
        }
        {
          name = "karakeep";
          containerPath = "/var/lib/karakeep";
          backupFolderName = "karakeep";
        }
        {
          name = "monitoring";
          containerPath = "/var/lib/grafana/data";
          backupFolderName = "grafana";
        }
        {
          name = "forgejo";
          containerPath = "/var/lib/forgejo";
          backupFolderName = "forgejo";
        }
      ];
    };
  };
}
