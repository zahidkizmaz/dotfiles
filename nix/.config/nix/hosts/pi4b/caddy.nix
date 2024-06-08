{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."lab.home".extraConfig = ''
      reverse_proxy :8123
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
