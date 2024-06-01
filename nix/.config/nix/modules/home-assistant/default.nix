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
  services.home-assistant.config =
    {
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };
}
