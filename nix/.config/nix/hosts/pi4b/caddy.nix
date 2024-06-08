{ ... }:

{
  services.caddy = {
    enable = true;
    extraConfig = ''
      log
      encode zstd gzip

      (network_paths) {
        handle_path /dns/* {
          reverse_proxy /* adguard:3000
        }

        handle_path /home/* {
          reverse_proxy /* adguard:3000
        }

        reverse_proxy /* localhost:8123
      }

      pi4b.quoll-ratio.ts.net {
        import network_paths
      }

      http://192.168.178.24 {
        import network_paths
      }
    '';
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
