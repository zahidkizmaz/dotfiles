{ ... }:

{
  imports = [ ./settings.nix ];

  containers.homeassistant = {
    autoStart = true;

    config =
      { config, lib, ... }:
      {

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
            "philips_js"
            "raspberry_pi"
            "recorder"
            "shopping_list"
            "usb"
            "zha"
          ];

          config = {
            http.server_host = [
              "0.0.0.0"
              "192.168.178.24"
              "pi4b.quoll-ratio.ts.net"
              "::"
            ];
            http.server_port = 8111;
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
            allowedTCPPorts = [ 8111 ];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        system.stateVersion = "24.11";
      };
  };
}
