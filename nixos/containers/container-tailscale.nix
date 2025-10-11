{
  lib,
  inputs,
  pkgs,
  config,
  port,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
    (import ./tailscale-serve.nix {
      inherit pkgs;
      tailscalePort = 443;
      localPort = port;
    })
  ];
  age = {
    identityPaths = [ "/etc/ssh/lab" ];
    secrets = {
      tailscale-lab = {
        file = ../secrets/tailscale-lab.age;
      };
    };
  };

  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      interfaceName = "userspace-networking";
      useRoutingFeatures = "client";
      authKeyFile = config.age.secrets.tailscale-lab.path;
    };
  };

  networking = {
    firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  systemd.services.tailscaled-autoconnect.serviceConfig = lib.mkIf config.boot.isContainer {
    Type = lib.mkForce "exec";
  };
}
