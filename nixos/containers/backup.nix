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

  rcloneWithFilen = pkgs.rclone.overrideAttrs {
    version = "1.72.1";
    src = pkgs.fetchFromGitHub {
      owner = "rclone";
      repo = "rclone";
      rev = "984d07c9c3f71f0a65d44064c2e4cda7c1878a0f";
      hash = "sha256-A97O2N21MdGDdDXa8TLCVlKy9TIRPrEQ43mzQOtfBO8=";
    };
    vendorHash = "sha256-ZEkZbP2r9PFAURkJNR1829VgaL1GXq72mt5Hnz5++kY=";
  };
in
{
  environment.systemPackages = [
    pkgs.restic
    prepareBackupScript
    afterBackupScript
    rcloneWithFilen # Not needed when https://github.com/rclone/rclone/pull/8537 is released
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
          "-o"
          "rclone.program=${rcloneWithFilen}/bin/rclone"
        ];
      };
    };
  };
}
