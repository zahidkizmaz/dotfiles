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
    let
      hiddenEntities = [
        "sensor.last_boot"
        "sensor.date"
      ];
    in
    {
      icloud = { };
      frontend = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
      history.exclude = {
        entities = hiddenEntities;
        domains = [
          "automation"
          "updater"
        ];
      };
      "map" = { };
      shopping_list = { };
      backup = { };
      logbook.exclude.entities = hiddenEntities;
      logger.default = "info";
      sun = { };
      config = { };
      mobile_app = { };

      cloud = { };
      network = { };
      zeroconf = { };
      system_health = { };
      default_config = { };
      system_log = { };
    };
}
