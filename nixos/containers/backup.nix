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
    '';

  backupScript = pkgs.writeShellApplication {
    name = "backup";
    runtimeInputs = with pkgs; [ bash ];
    text = backupText;
  };

  rcloneWithFilen = pkgs.rclone.overrideAttrs {
    version = "1.71.0";
    src = pkgs.fetchFromGitHub {
      owner = "FilenCloudDienste";
      repo = "filen-rclone";
      rev = "upstream-pr";
      hash = "sha256-b+8v4hflmU024qtrBRPP+gZuThOaoeR5KXhkFy+eW2o=";
    };
    vendorHash = "sha256-JT/XrjkeAFkFwzjYc5rCIVn0A86vXDuCzPqEw1dEeOY=";
  };
in
{
  environment.systemPackages = [
    backupScript
    rcloneWithFilen # Not needed when https://github.com/rclone/rclone/pull/8537 is released
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
        pruneOpts = [
          "--keep-daily 3"
        ];
      };
    };
  };
}
