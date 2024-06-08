{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."pi4b.quoll-ratio.ts.net".extraConfig = ''
      log
      encode zstd gzip

      reverse_proxy 127.0.0.1:8123
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
