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

  services = {
    tailscale = {
      enable = true;
      openFirewall = true;
      interfaceName = "userspace-networking";
      authKeyFile = config.age.secrets.tailscale-lab.path;
    };
  };
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve HTTP Proxy";
    wants = [ "tailscaled.service" ];
    after = [ "tailscaled.service" ];
    path = with pkgs; [
      jq
      tailscale
    ];

    serviceConfig = {
      RestartSec = 5;
      Restart = "on-failure";
      ExecStartPre = ''
        state=$(tailscale status --json | jq -r .BackendState)
        if [ "$state" != "Running" ]; then
          echo "Tailscale backend not running, aborting start."
          sleep 3
          exit 1
        fi
      '';
      ExecStart = "tailscale serve --https=443 localhost:${toString port}";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.tailscaled-autoconnect.serviceConfig = lib.mkIf config.boot.isContainer {
    Type = lib.mkForce "exec";
  };
}
