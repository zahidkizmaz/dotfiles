{ ... }:
{
  services = {
    devmon.enable = true;
  };

  system.activationScripts.script.text = # bash
    ''
      chmod a+rwx /dev/ttyACM0
    '';
}
