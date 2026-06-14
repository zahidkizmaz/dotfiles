{
  config,
  pkgs,
  lib,
  user,
  ...
}:
let
  cfg = config.appContainers.backup;

  copyCommands = lib.concatStringsSep "\n" (
    lib.map (c: ''
      copyFromContainer "${c.name}" "${c.containerPath}" "${cfg.hostBackupFolder}/${c.backupFolderName}/"
    '') cfg.containers
  );

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
      ${copyCommands}
    '';

  prepareBackupScript = pkgs.writeShellApplication {
    name = "prepareBackup";
    runtimeInputs = with pkgs; [ bash ];
    text = prepareBackupText;
  };

  afterBackupScript = pkgs.writeShellApplication {
    name = "afterBackup";
    runtimeInputs = with pkgs; [ bash ];
    text = ''
      if [ -d ${cfg.hostBackupFolder} ]; then
        echo "Cleaning ${cfg.hostBackupFolder} ..."
        rm -rf ${cfg.hostBackupFolder}
      fi
    '';
  };

  localTargets = lib.filter (t: t.enabled && t.type == "local") cfg.targets;
  rcloneTargets = lib.filter (t: t.enabled && t.type == "rclone") cfg.targets;

  localMounts = lib.optionalAttrs (localTargets != [ ]) (
    lib.listToAttrs (
      lib.map (t: {
        name = "${t.mountPath}";
        value = {
          device = t.device;
          fsType = t.fsType;
          options = t.mountOptions;
        };
      }) localTargets
    )
  );
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rclone
      pkgs.restic
      prepareBackupScript
      afterBackupScript
    ];
    fileSystems = localMounts;
    services.restic.backups = lib.listToAttrs (
      lib.map (t: {
        name = "backup-${t.name}";
        value = {
          initialize = true;
          passwordFile = cfg.resticPassword;
          paths = [
            cfg.hostBackupFolder
            "/home/${user}/music"
          ];
          repository = if t.type == "local" then "${t.mountPath}/backups/" else t.remotePath;
          timerConfig = {
            OnCalendar = t.schedule;
            Persistent = true;
          };
          backupPrepareCommand = prepareBackupText;
          backupCleanupCommand = afterBackupScript.text;
          pruneOpts = t.prune;
          extraOptions = lib.optional (t.type == "rclone") "rclone.program=${pkgs.rclone}/bin/rclone";
        }
        // lib.optionalAttrs (t.type == "rclone") {
          rcloneConfigFile = t.rcloneConfig;
        };
      }) (localTargets ++ rcloneTargets)
    );
  };
}
