{ ... }:
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
      "met"
      "file"
      "hue"
      "ios"
      "mqtt"
      "raspberry_pi"
      "usb"
      "zha"
      "my"
      "shopping_list"
      "philips_js"
    ];
  };
}
