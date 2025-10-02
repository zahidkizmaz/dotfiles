{
  lib,
  inputs,
  pkgs,
  config,
  port,
  ...
}:
let
  checkTailscaleScript = pkgs.writeShellScript "check-tailscale" ''
    state=$(${pkgs.tailscale}/bin/tailscale status --json | ${pkgs.jq}/bin/jq -r .BackendState)
    if [ "$state" != "Running" ]; then
      echo "Tailscale backend not running, aborting start."
      exit 1
    fi
  '';
in
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

    serviceConfig = {
      RestartSec = 5;
      Restart = "on-failure";
      ExecStartPre = "${checkTailscaleScript}";
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --https=443 localhost:${toString port}";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.tailscaled-autoconnect.serviceConfig = lib.mkIf config.boot.isContainer {
    Type = lib.mkForce "exec";
  };
}
