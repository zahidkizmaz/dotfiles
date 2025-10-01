{ pkgs, user, ... }:
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

        echo "Copying files using machinectl form $CONTAINER_NAME"
        machinectl copy-from "$CONTAINER_NAME" "$CONTAINER_PATH" "$HOST_DEST"
      }

      copyFromContainer "immich" "/va/lib/immich" "/home/${user}/backup/immich/"
    '';
  };
in
{
  environment.systemPackages = [
    backupScript
  ];
}
