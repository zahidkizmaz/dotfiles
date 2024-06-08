{ ... }:

{
  services.adguardhome = {
    enable = false;
    port = 3000;
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
