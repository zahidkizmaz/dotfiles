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
      "my"
      "shopping_list"
      "epson"
      "philips_js"
    ];
  };
}
