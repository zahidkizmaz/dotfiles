{
  config,
  lib,
  pkgs,
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

    # Helper scripts for container management
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "refresh-container-tailscale" ''
        set -euo pipefail

        if [ "$(id -u)" -ne 0 ]; then
          echo "error: this script must be run as root (use sudo)" >&2
          exit 1
        fi

        containers=$(${pkgs.nixos-container}/bin/nixos-container list 2>/dev/null || true)
        if [ -z "$containers" ]; then
          echo "No containers found."
          exit 0
        fi

        for c in $containers; do
          echo "=== Restarting tailscale in container: $c ==="
          ${pkgs.nixos-container}/bin/nixos-container run "$c" -- \
            systemctl restart tailscaled 2>&1 | sed 's/^/  /' || true
          echo ""
        done

        echo "Done. To verify serve endpoints:"
        echo "  tailscale serve status"
      '')

      (pkgs.writeShellScriptBin "pg-upgrade-container" (
        builtins.replaceStrings [ "@nixos_container@" ] [ "${pkgs.nixos-container}" ] (
          builtins.readFile ./pg-upgrade-container.sh
        )
      ))
    ];
  };
}
