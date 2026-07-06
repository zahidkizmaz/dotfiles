{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
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
