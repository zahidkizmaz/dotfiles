{
  config,
  pkgs,
  user,
  ...
}:
let
  backupText = # bash
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

      copyFromContainer "immich" "/var/lib/immich" "/home/${user}/backup/immich/"
      copyFromContainer "paperless" "/var/lib/paperless" "/home/${user}/backup/paperless/"
    '';

  backupScript = pkgs.writeShellApplication {
    name = "backup";
    runtimeInputs = with pkgs; [ bash ];
    text = backupText;
  };
in
{
  environment.systemPackages = [
    backupScript
  ];

  services = {
    restic.backups = {
      localbackup = {
        initialize = true;
        passwordFile = config.age.secrets.restic-password.path;
        paths = [
          "/home/${user}/backups"
          "/home/${user}/music"
        ];
        repository = "/home/${user}/restic/";
        timerConfig = {
          OnCalendar = "04:00";
          Persistent = true;
        };
        backupPrepareCommand = backupText;
      };
    };
  };
}
