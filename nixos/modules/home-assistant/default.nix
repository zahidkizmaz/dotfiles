{ pkgs, ... }:
let
  port = 8123;
in
{
  imports = [
    (import ../../containers/tailscale-serve.nix {
      tailscalePort = 443;
      localPort = port;
      inherit pkgs;
    })
    ./postgres.nix
  ];

  services.home-assistant = {
    enable = true;
    extraPackages =
      python3Packages: with python3Packages; [
        # postgresql support
        psycopg2
      ];
    extraComponents = [
      "default_config"
      "esphome"
      "file"
      "homekit"
      "hue"
      "isal" # Intelligent Storage Acceleration
      "met"
      "mobile_app"
      "my"
      "philips_js"
      "raspberry_pi"
      "recorder"
      "roborock"
      "usb"
      "zha"
    ];
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      bubble-card
      clock-weather-card
      hourly-weather
      mushroom
    ];

    config = {
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
        server_host = [ "127.0.0.1" ];
        server_port = port;
      };
      homeassistant = {
        name = "Home";
        country = "DE";
        unit_system = "metric";
        time_zone = "Europe/Berlin";
      };
      frontend = {
        themes = "!include_dir_merge_named themes/";
      };
      default_config = { };
      system_health = { };
      system_log = { };
      zeroconf = { };
    };

  };
}
