{ ... }:
{
  services = {
    devmon.enable = true;
    udisks2.enable = true;
  };

  system.activationScripts.script.text = # bash
    ''
      chmod a+rwx /dev/ttyACM0
    '';
}
