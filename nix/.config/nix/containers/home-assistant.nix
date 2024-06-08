{ ... }:

{
  imports = [ ./settings.nix ];

  containers.homeassistant = {
    autoStart = true;

    config = { config, pkgs, lib, ... }: {

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
          "met"
          "philips_js"
          "raspberry_pi"
          "recorder"
          "shopping_list"
          "usb"
          "zha"
        ];

        config = {
          http.server_port = 81234;
          homeassistant = {
            name = "Home";
            country = "DE";
            unit_system = "metric";
            time_zone = "Europe/Berlin";
          };
        };
      };

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 81234 ];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      system.stateVersion = "24.05";
    };
  };
}
