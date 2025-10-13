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
      "hue"
      "met"
      "my"
      "philips_js"
      "raspberry_pi"
      "recorder"
      "usb"
      "zha"
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
    };

  };
}
