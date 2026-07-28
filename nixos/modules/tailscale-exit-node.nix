{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.tailscaleExitNode;
in
{
  options.tailscaleExitNode.wanInterface = lib.mkOption {
    type = lib.types.str;
    default = "eth0";
    description = "WAN interface for ethtool GRO optimization";
  };

  config = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "server";
      authKeyFile = config.age.secrets.tailscale-lab.path;
      extraUpFlags = [ "--advertise-exit-node" ];
    };

    environment.systemPackages = [ pkgs.ethtool ];

    boot.kernel.sysctl."net.ipv4.ip_forward" = true;
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;

    networking.firewall.checkReversePath = "loose";

    services.networkd-dispatcher = {
      enable = true;
      rules."50-tailscale-optimizations" = {
        onState = [ "routable" ];
        script = ''
          ${pkgs.ethtool}/bin/ethtool -K ${cfg.wanInterface} rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };
}
