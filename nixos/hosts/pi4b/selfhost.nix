{ pkgs, ... }:
{
  services = {
    devmon.enable = true;
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libsecret

    # Cloud
    filen-cli
  ];

  system.activationScripts.script.text = # bash
    ''
      chmod a+rwx /dev/ttyACM0
    '';
}
