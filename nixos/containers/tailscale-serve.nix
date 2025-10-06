{
  pkgs,
  tailscalePort,
  localPort,
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
  networking.firewall = {
    allowedTCPPorts = [ localPort ];
  };
  systemd.services."tailscale-serve-port-${toString localPort}" = {
    description = "Tailscale Serve HTTP Proxy";
    wants = [ "tailscaled.service" ];
    after = [ "tailscaled.service" ];

    serviceConfig = {
      RestartSec = 5;
      Restart = "on-failure";
      ExecStartPre = "${checkTailscaleScript}";
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --https=${toString tailscalePort} localhost:${toString localPort}";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
