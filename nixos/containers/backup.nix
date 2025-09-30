{ user, backupFolder, ... }:
{
  system.activationScripts.createBackupFolder.text = ''
    if [ ! -d /home/${user}/backup/${backupFolder} ]; then
      echo "Creating /home/${user}/backup/${backupFolder} ..."
      mkdir -p /home/${user}/backup/${backupFolder}
    fi
  '';
}
