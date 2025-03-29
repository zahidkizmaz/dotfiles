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
}
