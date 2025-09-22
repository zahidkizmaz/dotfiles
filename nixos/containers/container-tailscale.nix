{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.agenix.nixosModules.default ];
  age = {
    identityPaths = [ "/etc/ssh/lab" ];
    secrets = {
      tailscale-lab = {
        file = ../secrets/tailscale-lab.age;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    ethtool
    networkd-dispatcher
  ];
  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale-lab.path;
    };
    networkd-dispatcher = {
      enable = true;
      rules."50-tailscale" = {
        onState = [ "routable" ];
        script = ''
          ${lib.getExe pkgs.ethtool} -K eth0 rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };
}
