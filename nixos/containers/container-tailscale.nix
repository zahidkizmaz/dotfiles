{
  lib,
  inputs,
  pkgs,
  config,
  port,
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
      openFirewall = true;
      authKeyFile = config.age.secrets.tailscale-lab.path;
      authKeyParameters.ephemeral = true;
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
  system.activationScripts.tailscale-serve = {
    text = ''
      tailscale up
      tailscale serve --http=80 localhost:${toString port}
    '';
  };
}
