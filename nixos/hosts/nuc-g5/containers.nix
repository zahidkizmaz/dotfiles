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
      immich.enable       = true;
      searx.enable        = true;
      karakeep.enable     = true;
      stirling-pdf.enable = true;
      navidrome.enable    = true;
      monitoring.enable   = true;
      paperless.enable    = true;
      mealie.enable       = true;
      ntfy.enable         = true;
      uptime-kuma.enable  = true;
      dns.enable          = true;
      watch.enable        = true;
      trilium.enable      = true;
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
