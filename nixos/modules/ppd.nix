{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
  };
in
{
  services = {
    power-profiles-daemon = {
      enable = true;
      package = pkgs-unstable.power-profiles-daemon;
    };

    # Disable conflicting services
    tlp.enable = false;
    auto-cpufreq.enable = false;
  };

  services.udev.extraRules = ''
    # Set power-saver profile when battery is discharging
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="BAT1", ENV{POWER_SUPPLY_STATUS}=="Discharging", RUN+="${pkgs-unstable.power-profiles-daemon}/bin/powerprofilesctl set power-saver"

    # Set performance profile when battery is charging
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="BAT1", ENV{POWER_SUPPLY_STATUS}=="Charging", RUN+="${pkgs-unstable.power-profiles-daemon}/bin/powerprofilesctl set performance"
  '';
}
