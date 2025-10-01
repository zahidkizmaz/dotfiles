{
  config,
  pkgs,
  user,
  ...
}:
let
  backupScript = pkgs.writeShellApplication {
    name = "backup";
    runtimeInputs = with pkgs; [ bash ];
    text = ''
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
    '';
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
        ];
        repository = "/home/${user}/restic/";
        timerConfig = {
          OnCalendar = "01:05";
          Persistent = true;
        };
        backupPrepareCommand = "backup";
      };
    };
  };
}
