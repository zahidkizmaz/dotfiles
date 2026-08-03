{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.piResilience;
in
{
  options.piResilience = {
    enable = lib.mkEnableOption "power-loss/reboot resilience tweaks for headless Raspberry Pi hosts";

    hardwareWatchdog = lib.mkEnableOption ''
      the BCM2835 hardware watchdog driven by systemd (RuntimeWatchdogSec).
      Verified on Pi 4 (BCM2711). On Pi 5 (BCM2712) the systemd PID1
      watchdog feed is known to fail on some kernel configs, which would
      cause a reboot loop -- test before enabling there.
    '';
  };

  config = lib.mkIf cfg.enable {
    # Repair filesystems automatically at boot (power loss is expected) instead
    # of dropping to an emergency shell on a headless box.
    # Reboot after 10s of kernel panic instead of hanging forever.
    boot.kernelParams = [
      "fsck.repair=yes"
      "panic=10"
    ];

    # Reboot the box when the default gateway stops answering. Pings the
    # gateway, never an internet host, so an ISP outage never reboots the box
    # (router up, WAN down -> gateway still answers). "Gateway unreachable"
    # is indistinguishable from "our stack is wedged" and both are best
    # served by a reboot: harmless if the router died (cooldowns cap it at
    # one per 2h), curative if the stack is stuck (the only fix that works
    # without physical access). The carrier check above already rules out
    # cable-pulled/admin-down cases, where a reboot would be pure noise.
    systemd.services.pi-network-watchdog = {
      description = "Reboot when the default gateway becomes unreachable";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "pi-network-watchdog" ''
          set -u
          PATH=${
            lib.makeBinPath [
              pkgs.iproute2
              pkgs.iputils
              pkgs.gawk
              pkgs.coreutils
            ]
          }

          # All log lines go to stderr -> journald -> Loki (via the host's
          # Alloy agent). Prefix "pi-resilience:" so they're greppable.
          log() { echo "pi-resilience: $*" >&2; }

          marker=/var/lib/pi-resilience/last-reboot

          line="$(ip route show default | awk '/default/ {print; exit}')"
          if [ -z "$line" ]; then
            log "no default route, skipping (box may be unconfigured)"
            exit 0
          fi
          gateway="$(echo "$line" | awk '{print $3}')"
          iface="$(echo "$line" | awk '{print $5}')"

          # No physical link (cable unplugged, switch off, admin-down) -> do
          # nothing. A reboot can't restore a pulled cable, and this is also
          # the "user is poking at the box" case we must not fight. Covers
          # WiFi too: losing association drops carrier / goes DORMANT.
          if ip link show dev "$iface" | awk '(/NO-CARRIER/ || /state DOWN/ || /state DORMANT/ || /state LOWERLAYERDOWN/) {found=1} END {exit !found}'; then
            log "iface $iface has no carrier, skipping (cable unplugged / link down)"
            exit 0
          fi

          # Cooldown 1: let the box settle after boot.
          uptime_sec="$(awk '{print int($1)}' /proc/uptime)"
          if [ "$uptime_sec" -lt 1800 ]; then
            log "uptime ''${uptime_sec}s < 30min, skipping (boot cooldown)"
            exit 0
          fi

          # Cooldown 2: at most one reboot per 2h, even if the gateway stays
          # down; otherwise a long outage would cause a reboot loop. The
          # marker also records WHY the last reboot happened.
          if [ -f "$marker" ]; then
            last_ts="$(awk '{print $1}' "$marker")"
            if [ "$(( $(date +%s) - last_ts ))" -lt 7200 ]; then
              log "last reboot $(cat "$marker"), within 2h window, skipping"
              exit 0
            fi
          fi

          # 10 pings, fail only if >= 8 are lost (lenient: one flaky reply
          # keeps the box alive).
          fails=0
          i=0
          while [ "$i" -lt 10 ]; do
            ping -c 1 -W 5 "$gateway" >/dev/null 2>&1 || fails=$((fails + 1))
            i=$((i + 1))
          done
          if [ "$fails" -lt 8 ]; then
            exit 0
          fi

          reason="gateway $gateway (iface $iface) unreachable: $fails/10 pings lost, uptime ''${uptime_sec}s"
          log "REBOOTING: $reason"
          mkdir -p "$(dirname "$marker")"
          # Durable record: epoch first so cooldown logic can parse it; the
          # rest is the human-readable reason for post-mortem after reboot
          # (volatile journal may not survive the reboot).
          echo "$(date +%s) $reason" > "$marker"
          /run/current-system/sw/bin/systemctl reboot
        '';
      };
    };

    systemd.timers.pi-network-watchdog = {
      description = "Run the network watchdog every 2 minutes";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10m";
        OnUnitActiveSec = "2m";
        Unit = "pi-network-watchdog.service";
      };
    };

    # Hardware watchdog, only where verified (Pi 4). Pi 5 (BCM2712) has a
    # documented systemd PID1 feed failure that would reboot-loop the box.
    boot.kernelModules = lib.mkIf cfg.hardwareWatchdog [ "bcm2835_wdt" ];
    systemd.settings.Manager.RuntimeWatchdogSec = lib.mkIf cfg.hardwareWatchdog "15";
  };
}
