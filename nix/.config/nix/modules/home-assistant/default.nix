{ config, ... }:
{
  imports = [
    ./postgres.nix
  ];

  networking.firewall.allowedTCPPorts = [ 8123 ];

  services.home-assistant = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      # postgresql support
      psycopg2
    ];
    extraComponents = [
      "default_config"
      "esphome"
      "file"
      "hue"
      "ios"
      "met"
      "mqtt"
      "my"
      "philips_js"
      "raspberry_pi"
      "recorder"
      "shopping_list"
      "usb"
      "zha"
    ];

    config = {
      recorder.db_url = "postgresql://@/hass";
      homeassistant = {
        name = "Home";
        country = "DE";
        unit_system = "metric";
        time_zone = "Europe/Berlin";
        latitude = config.age.secrets.home_longitude.path;
        longitude = config.age.secrets.home_longitude.path;
        elevation = config.age.secrets.home_elevation.path;
      };
    };

  };
}
