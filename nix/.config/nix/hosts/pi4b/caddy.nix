{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."localhost".extraConfig = ''
      encode zstd gzip

      reverse_proxy /home/* 127.0.0.1:8123
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
