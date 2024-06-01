{ pkgs, ... }:
{
  imports = [
    ./postgres.nix
  ];

  networking.firewall.allowedTCPPorts = [ 8123 ];

  services.home-assistant = {
    enable = true;
    package = (pkgs.home-assistant.override { extraPackages = ps: [ ps.psycopg2 ]; });
  };
}
