{
  stateVersion,
  localAddress,
  hostAddress,
  port,
  inputs,
  user,
  ...
}:
let
  containerName = "ad";
  filters = [
    "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
    "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt"
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
  ];
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "identity";
    enableTun = true;
    ephemeral = false;
    hostAddress = hostAddress;
    localAddress = localAddress;
    bindMounts = {
      "/etc/ssh/lab" = {
        hostPath = "/home/${user}/.ssh/lab";
        isReadOnly = true;
      };
    };
    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = [
          ./container-common.nix
          (import ./container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              port
              ;
          })
        ];

        services.adguardhome = {
          enable = true;
          mutableSettings = false;
          openFirewall = true;
          settings = {
            inherit filters;
            port = port;
            http.address = "0.0.0.0";
            dns = {
              ratelimit = 0;
              bind_hosts = [ "0.0.0.0" ];
              upstream_dns = [
                "9.9.9.9"
                "1.1.1.1"
                "1.0.0.1"
              ];
              bootstrap_dns = [
                "9.9.9.10"
                "149.112.112.10"
                "2620:fe::10"
                "2620:fe::fe:10"
              ];
            };
          };
        };

        system.stateVersion = stateVersion;
      };
  };
}
