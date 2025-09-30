{ user, ... }:
{
  system.activationScripts.createBackupFolder.text = ''
    if [ ! -d /home/${user}/backup ]; then
      echo "Creating /home/${user}/backup ..."
      mkdir /home/${user}/backup
    fi
  '';
}
