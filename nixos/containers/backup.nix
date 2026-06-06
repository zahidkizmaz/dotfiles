{
  config,
  pkgs,
  user,
  ...
}:
let
  hostBackupFolder = "/home/${user}/backups";
  externalDriveLabel = "backup-drive";
  externalDriveMountPath = "/backup";
  externalDriveBackupFolder = "${externalDriveMountPath}/backups/";
  prepareBackupText = # bash
    ''
      copyFromContainer() {
        CONTAINER_NAME=$1
        CONTAINER_PATH=$2
        HOST_DEST=$3
        if [ ! -d "$HOST_DEST" ]; then
          mkdir -p "$HOST_DEST"
        fi

        echo "Copying files using machinectl from $CONTAINER_NAME: $CONTAINER_PATH -> $HOST_DEST"
        machinectl copy-from "$CONTAINER_NAME" "$CONTAINER_PATH" "$HOST_DEST"
      }

      copyFromContainer "immich" "/var/lib/immich" "${hostBackupFolder}/immich/"
      copyFromContainer "notes" "/var/lib/trilium" "${hostBackupFolder}/trilium/"
      copyFromContainer "paperless" "/var/lib/paperless/export" "${hostBackupFolder}/paperless/"
      copyFromContainer "meal" "/var/lib/private/mealie" "${hostBackupFolder}/mealie/"
      copyFromContainer "status" "/var/lib/private/uptime-kuma" "${hostBackupFolder}/uptime-kuma/"
      copyFromContainer "keep" "/var/lib/karakeep" "${hostBackupFolder}/karakeep/"
      copyFromContainer "monitoring" "/var/lib/grafana/data" "${hostBackupFolder}/grafana/"
    '';

  prepareBackupScript = pkgs.writeShellApplication {
    name = "prepareBackup";
    runtimeInputs = with pkgs; [ bash ];
    text = prepareBackupText;
  };

  afterBackupText = # bash
    ''
      if [ -d ${hostBackupFolder} ]; then
        echo "Cleaning ${hostBackupFolder} ..."
        rm -rf ${hostBackupFolder}
      fi
    '';
  afterBackupScript = pkgs.writeShellApplication {
    name = "afterBackup";
    runtimeInputs = with pkgs; [ bash ];
    text = afterBackupText;
  };

in
{
  environment.systemPackages = [
    pkgs.rclone
    pkgs.restic
    prepareBackupScript
    afterBackupScript
  ];

  fileSystems."${externalDriveMountPath}" = {
    device = "/dev/disk/by-label/${externalDriveLabel}";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
      "compress=zstd"
    ];
  };

  services = {
    restic.backups = {
      localBackup = {
        initialize = true;
        passwordFile = config.age.secrets.restic-password.path;
        paths = [
          hostBackupFolder
          "/home/${user}/music"
        ];
        repository = externalDriveBackupFolder;
        timerConfig = {
          OnCalendar = "03:00";
          Persistent = true;
        };
        backupPrepareCommand = prepareBackupText;
        backupCleanupCommand = afterBackupText;
        pruneOpts = [
          "--keep-daily 3"
        ];
      };
      remoteBackup = {
        initialize = true;
        repository = "rclone:filen-backend:backups/";
        passwordFile = config.age.secrets.restic-password.path;
        rcloneConfigFile = config.age.secrets.rclone-config-filen.path;
        paths = [
          hostBackupFolder
          "/home/${user}/music"
        ];
        timerConfig = {
          OnCalendar = "Fri *-*-* 04:30:00";
          Persistent = true;
        };
        backupPrepareCommand = prepareBackupText;
        backupCleanupCommand = afterBackupText;
        pruneOpts = [
          "--keep-weekly 3"
        ];
        extraOptions = [
          "rclone.program=${pkgs.rclone}/bin/rclone"
        ];
      };
    };
  };
}
