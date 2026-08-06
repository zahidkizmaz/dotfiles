{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.tailscaleExitNode;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
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
      package = pkgs-unstable.tailscale;
      openFirewall = true;
      useRoutingFeatures = "server";
      authKeyFile = config.age.secrets.tailscale-lab.path;
      extraSetFlags = [ "--advertise-exit-node" ];
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
