{ pkgs, ... }:
let
  preScript = pkgs.writeShellScript "pre-suspend" ''
    set -e

    # === Log before-sleep state ===
    # Append (don't clobber) so history is kept across cycles. Cap at 1 MiB
    # because there is no logrotate entry for this file.
    LOG="/var/log/wakeup-monitor.log"
    if [ -f "$LOG" ] && [ "$(stat -c %s "$LOG" 2>/dev/null || echo 0)" -gt 1048576 ]; then
      mv -f "$LOG" "$LOG.1" || true
    fi
    {
      echo "=== Sleeping at $(date) ==="
      echo "BEFORE SLEEP: Total wakeup count: $(cat /sys/power/wakeup_count 2>/dev/null || echo '?')"
      echo "BEFORE SLEEP: Voltage Now: $(cat /sys/class/power_supply/BAT1/voltage_now 2>/dev/null || echo '?')"
      echo "BEFORE SLEEP: Battery: $(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo '?')%"
      echo ""
    } >> "$LOG"

    # === Disable UCSI / USB-C power-delivery wakeups ===
    # ucsi_acpi is no longer unbound across sleep: its PPM init stalls the
    # fingerprint reader for up to ~10s on resume. Re-assert the wakeup masks
    # before every sleep in case the driver recreated them.
    for ucsi in /sys/devices/platform/USBC000:00/power/wakeup \
                /sys/devices/platform/USBC000:00/*/power/wakeup \
                /sys/class/power_supply/ucsi-source-psy-*/wakeup; do
      if [ -e "$ucsi" ]; then
        echo "disabled" > "$ucsi" 2>/dev/null || true
      fi
    done

    # === NVMe low power ===
    ${pkgs.nvme-cli}/bin/nvme set-feature /dev/nvme0 -f 0x02 -v 4 2>/dev/null || true
    echo "pre: NVMe set to low power state"

    # === WiFi block ===
    if ${pkgs.util-linux}/bin/rfkill list wifi | grep -q "Soft blocked: no"; then
      echo "enabled" > /tmp/wifi-was-enabled
      ${pkgs.util-linux}/bin/rfkill block wifi
      echo "pre: WiFi blocked"
    else
      echo "disabled" > /tmp/wifi-was-enabled
    fi
  '';

  postScript = pkgs.writeShellScript "post-resume" ''
    # NOTE: no set -e — individual steps may fail without aborting the script.

    # === NVMe active state ===
    ${pkgs.nvme-cli}/bin/nvme set-feature /dev/nvme0 -f 0x02 -v 0 2>/dev/null || true
    echo "post: NVMe restored to active state"

    # === WiFi unblock ===
    if [ -f /tmp/wifi-was-enabled ]; then
      STATE=$(cat /tmp/wifi-was-enabled)
      if [ "$STATE" = "enabled" ]; then
        ${pkgs.util-linux}/bin/rfkill unblock wifi
        echo "post: WiFi unblocked"
      fi
      rm -f /tmp/wifi-was-enabled
    fi

    # === Log wakeup sources ===
    LOG="/var/log/wakeup-monitor.log"
    WAKEUP_COUNT=$(cat /sys/power/wakeup_count 2>/dev/null || echo "?")
    {
      echo "=== Woke at $(date) ==="
      echo "Total wakeup count: $WAKEUP_COUNT"
      echo "Voltage Now: $(cat /sys/class/power_supply/BAT1/voltage_now 2>/dev/null || echo '?')"
      echo ""

      echo "Top 10 wakeup sources (by event count):"
      if [ -r /sys/kernel/debug/wakeup_sources ]; then
        # Columns: name active event wakeup expire ... (filter out any header)
        ${pkgs.gawk}/bin/awk '$2 ~ /^[0-9]+$/' /sys/kernel/debug/wakeup_sources \
          | sort -k3 -rn | head -10 \
          | ${pkgs.gawk}/bin/awk '{ printf "  %-30s active=%-8s events=%-8s wakeups=%-8s\n", $1, $2, $3, $4 }'
      else
        echo "  (wakeup_sources not readable)"
      fi

      echo ""
      echo "i2c-PIXA3854 wakeup status:"
      for i2c in /sys/devices/platform/AMDI0010:03/i2c-*/i2c-PIXA3854:00/power/wakeup; do
        if [ -e "$i2c" ]; then
          echo "  Status: $(cat $i2c)"
        fi
      done

      echo "serio0 wakeup status:"
      if [ -e /sys/devices/platform/i8042/serio0/power/wakeup ]; then
        echo "  Status: $(cat /sys/devices/platform/i8042/serio0/power/wakeup)"
      else
        echo "  Device not found"
      fi

      echo "UCSI/USB-C wakeup status:"
      for ucsi in /sys/devices/platform/USBC000:00/power/wakeup /sys/class/power_supply/ucsi-source-psy-*/wakeup; do
        if [ -e "$ucsi" ]; then
          echo "  $(cat "$ucsi")  $ucsi"
        fi
      done

      echo ""
      echo "Battery: $(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo '?')%"
      echo ""
    } >> "$LOG"
  '';
in
{
  # =========================================================================
  # Boot: disable i2c, serio, and ACPI wakeup sources
  # =========================================================================
  systemd.services.disable-wakeups = {
    description = "Disable i2c, serio, and ACPI wakeup sources";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "disable-wakeups" ''
        # Disable i2c-PIXA3854:00 (ambient light sensor / touchpad)
        for i2c in /sys/devices/platform/AMDI0010:03/i2c-*/i2c-PIXA3854:00/power/wakeup; do
          if [ -e "$i2c" ]; then
            echo "disabled" > "$i2c"
            echo "Disabled wakeup for: $i2c"
          fi
        done
        for i2c in /sys/bus/i2c/devices/i2c-PIXA3854:00/power/wakeup; do
          if [ -e "$i2c" ]; then
            echo "disabled" > "$i2c"
            echo "Disabled wakeup for: $i2c"
          fi
        done

        # Disable serio0 (keyboard/touchpad PS/2 interface)
        if [ -e /sys/devices/platform/i8042/serio0/power/wakeup ]; then
          echo "disabled" > /sys/devices/platform/i8042/serio0/power/wakeup
          echo "Disabled wakeup for: serio0"
        fi

        # Disable UCSI / USB-C power-delivery wakeups. ucsi_acpi is no longer
        # unbound across sleep (its PPM init stalls the fingerprint reader),
        # so block its wakeups here instead.
        for ucsi in /sys/devices/platform/USBC000:00/power/wakeup \
                    /sys/devices/platform/USBC000:00/*/power/wakeup \
                    /sys/class/power_supply/ucsi-source-psy-*/wakeup; do
          if [ -e "$ucsi" ]; then
            echo "disabled" > "$ucsi" 2>/dev/null || true
            echo "Disabled wakeup for: $ucsi"
          fi
        done

        # Disable ACPI wakeup sources (except power button / XHC0).
        # /proc/acpi/wakeup is write-to-toggle, so only write devices that
        # are currently enabled — otherwise we'd re-enable disabled ones.
        if [ -e /proc/acpi/wakeup ]; then
          for dev in GPP6 GP11 GP12 XHC1 XHC3 XHC4 NHI0 NHI1; do
            if grep -qE "^''${dev}[[:space:]].*\*enabled" /proc/acpi/wakeup; then
              echo "$dev" > /proc/acpi/wakeup 2>/dev/null || true
              echo "Disabled ACPI wakeup: $dev"
            fi
          done
          echo "ACPI wakeup sources processed"
        fi

        echo "Remaining enabled wakeup sources:"
        cat /proc/acpi/wakeup 2>/dev/null | grep enabled || echo "None"
      '';
    };
  };

  # =========================================================================
  # Pre-suspend: runs before sleep.target (i.e. before the system suspends).
  # =========================================================================
  systemd.services.pre-suspend = {
    description = "Prepare system for suspend (UCSI, NVMe, WiFi)";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = preScript;
    };
  };

  # =========================================================================
  # Post-resume: uses powerManagement.resumeCommands which NixOS guarantees
  # to run after ANY sleep type (suspend, hibernate, suspend-then-hibernate,
  # hybrid-sleep). This is more reliable than After=systemd-suspend.service
  # which doesn't fire for suspend-then-hibernate.
  # =========================================================================
  # Run the post-resume script after ANY sleep type. The derivation path
  # is baked into the systemd-sleep hook at build time.
  powerManagement.resumeCommands = "${postScript}";
}
