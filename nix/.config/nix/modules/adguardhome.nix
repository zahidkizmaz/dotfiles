{ ... }:

{
  services.adguardhome = {
    enable = true;
    port = 3000;
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
