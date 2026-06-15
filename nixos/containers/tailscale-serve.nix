{
  pkgs,
  tailscalePort,
  localPort,
  ...
}:
let
  checkTailscale = pkgs.writeShellScript "check-tailscale" ''
    set -euo pipefail
    BACKEND=$(${pkgs.coreutils}/bin/timeout 10 \
      ${pkgs.tailscale}/bin/tailscale status --json 2>/dev/null \
      | ${pkgs.jq}/bin/jq -r '.BackendState // "NoState"')
    if [ "$BACKEND" != "Running" ]; then
      echo "Tailscale not ready (state=$BACKEND)"
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
      Type = "oneshot";
      RemainAfterExit = true;
      RestartSec = 5;
      Restart = "on-failure";
      ExecStartPre = "${checkTailscale}";
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=${toString tailscalePort} localhost:${toString localPort}";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
