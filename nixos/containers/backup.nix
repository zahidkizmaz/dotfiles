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
      copyFromContainer "meal" "/var/lib/mealie" "/home/${user}/backup/paperless/mealie"
    '';

  backupScript = pkgs.writeShellApplication {
    name = "backup";
    runtimeInputs = with pkgs; [ bash ];
    text = backupText;
  };

  rcloneWithFilen = pkgs.rclone.overrideAttrs {
    version = "1.69.1";
    src = pkgs.fetchFromGitHub {
      owner = "rclone";
      repo = "rclone";
      rev = "52018b0114a5591268512227dc6b0d378824d0da";
      hash = "sha256-b+8v4hflmU024qtrBRPP+gZuThOaoeR5KXhkFy+eW2o=";
    };
    vendorHash = "sha256-JT/XrjkeAFkFwzjYc5rCIVn0A86vXDuCzPqEw1dEeOY=";
  };
in
{
  environment.systemPackages = [
    pkgs.restic
    backupScript
    rcloneWithFilen # Not needed when https://github.com/rclone/rclone/pull/8537 is released
  ];

  services = {
    restic.backups = {
      localBackup = {
        initialize = true;
        passwordFile = config.age.secrets.restic-password.path;
        paths = [
          "/home/${user}/backup"
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
      remoteBackup = {
        initialize = true;
        repository = "rclone:filen-backend:backups/";
        passwordFile = config.age.secrets.restic-password.path;
        rcloneConfigFile = config.age.secrets.rclone-config-filen.path;
        paths = [
          "/home/${user}/backup"
          "/home/${user}/music"
        ];
        timerConfig = {
          OnCalendar = "Fri *-*-* 04:30:00";
          Persistent = true;
        };
        backupPrepareCommand = backupText;
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
