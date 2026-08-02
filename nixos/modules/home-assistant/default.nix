{ pkgs, inputs, ... }:
let
  port = 8123;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  imports = [
    (import ../../containers/tailscale-serve.nix {
      tailscalePort = 443;
      localPort = port;
      inherit pkgs;
    })
    ./postgres.nix
    ./themes/default.nix
  ];

  services.home-assistant = {
    enable = true;
    package = pkgs-unstable.home-assistant;
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
      "mcp_server"
      "met"
      "mobile_app"
      "my"
      "ntfy"
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
      mini-graph-card
      universal-remote-card
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      ha_mcp_tools
    ];
    config = {
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
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
      api = { }; # enables REST API
      default_config = { };
      system_health = { };
      system_log = { };
      zeroconf = { };
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
    };
  };

  # HA fails to start when these !include files don't exist yet; create them
  # if missing, but never touch existing ones (backups restored later win).
  systemd.services.home-assistant.preStart = # bash
    ''
      [ -e /var/lib/hass/automations.yaml ] || touch /var/lib/hass/automations.yaml
      [ -e /var/lib/hass/scripts.yaml ] || touch /var/lib/hass/scripts.yaml
    '';
}
