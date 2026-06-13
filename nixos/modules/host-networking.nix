{
  config,
  lib,
  pkgs,
  inputs,
  user,
  stateVersion,
  ...
}:
{
  options.hostNetworking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    externalInterface = lib.mkOption {
      type = lib.types.str;
      default = "enp2s0";
    };
    tailscaleAuthKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf config.hostNetworking.enable {
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = config.hostNetworking.externalInterface;
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv4.conf.all.forwarding" = 1;
    };

    services.tailscale = lib.mkIf (config.hostNetworking.tailscaleAuthKey != null) {
      enable = true;
      openFirewall = true;
      authKeyFile = config.hostNetworking.tailscaleAuthKey;
    };
  };
}
