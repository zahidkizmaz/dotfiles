{ pkgs, ... }:

{
  services = {
    power-profiles-daemon.enable = true;

    # Disable conflicting services
    tlp.enable = false;
    auto-cpufreq.enable = false;
  };

  services.udev.extraRules = ''
    # Set power-saver profile when AC is unplugged
    SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"

    # Set performance profile when AC is plugged in
    SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"
  '';
}
