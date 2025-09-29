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

    serviceConfig = {
      ExecStartPre = "${pkgs.bash}/bin/bash -c '
        for i in {1..12}; do
          state=$(${pkgs.tailscale}/bin/tailscale status --json | ${pkgs.jq}/bin/jq -r .BackendState)
          echo \"Tailscale backend state: $state\"
          if [ \"$state\" = \"Running\" ]; then
            exit 0
          fi
          sleep 5
        done
        echo \"Timed out waiting for Tailscale to be ready\" >&2
        exit 1
      '";
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --https=443 localhost:${toString port}";
      Restart = "always";
    };

    wantedBy = [ "multi-user.target" ];
  };
  systemd.services.tailscaled-autoconnect.serviceConfig = lib.mkIf config.boot.isContainer {
    Type = lib.mkForce "exec";
  };
}
