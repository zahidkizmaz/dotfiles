{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./postgres.nix
    (import ../../containers/container-tailscale.nix {
      port = 8123;
      inherit
        config
        inputs
        lib
        pkgs
        ;
    })
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
      homeassistant = {
        name = "Home";
        country = "DE";
        unit_system = "metric";
        time_zone = "Europe/Berlin";
      };
    };

  };
}
