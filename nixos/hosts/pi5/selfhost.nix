{ pkgs, config, ... }:
let
  # Ping uptime-kuma only on successful backup (mirrors containers/backup.nix).
  hassBackupWebhook = "https://status.quoll-ratio.ts.net/api/push/2WgItgD5FrVJXAl5pWNX6MNJkXs2mAHc?status=up&msg=OK&ping=";
  afterBackupScript = pkgs.writeShellApplication {
    name = "afterBackup";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      if [ -n "$WEBHOOK_URL" ] && [ "$SERVICE_RESULT" = "success" ]; then
        curl -fsS "$WEBHOOK_URL" > /dev/null 2>&1 || true
      fi
    '';
  };
in
{
  services = {
    devmon.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libsecret

    # Cloud
    filen-cli
  ];

  # Auto-mount backup SanDisk drive
  fileSystems."/backup" = {
    device = "/dev/disk/by-label/sandisk-backup";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
      "compress=zstd"
    ];
  };

  system.activationScripts.script.text = # bash
    ''
      if [ -e /dev/ttyACM0 ]; then
        chmod a+rwx /dev/ttyACM0
      fi
    '';

  # Ping uptime-kuma only on successful backup (mirrors containers/backup.nix).
  # Weekly restic backup of HA's own automatic backups (tars in
  # /var/lib/hass/backups, on the root filesystem) to Filen.
  services.restic.backups."backup-hass" = {
    initialize = true;
    passwordFile = config.age.secrets.restic-password.path;
    rcloneConfigFile = config.age.secrets.rclone-config-filen.path;
    repository = "rclone:filen-backend:backup-hass/";
    paths = [ "/var/lib/hass/backups" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
    extraOptions = [ "rclone.program=${pkgs.rclone}/bin/rclone" ];
    pruneOpts = [ "--keep-weekly 4" ];
    backupCleanupCommand = "${afterBackupScript}/bin/afterBackup '${hassBackupWebhook}'";
  };
}
