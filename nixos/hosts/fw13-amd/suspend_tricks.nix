{ pkgs, ... }:
let
  preScript = pkgs.writeShellScript "pre-suspend" ''
    set -e

    # === Log before-sleep state ===
    LOG="/var/log/wakeup-monitor.log"
    {
      echo "=== Sleeping at $(date) ==="
      echo "BEFORE SLEEP: Total wakeup count: $(cat /sys/power/wakeup_count 2>/dev/null || echo '?')"
      echo "BEFORE SLEEP: Voltage Now: $(cat /sys/class/power_supply/BAT1/voltage_now 2>/dev/null || echo '?')"
      echo "BEFORE SLEEP: Battery: $(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo '?')%"
      echo ""
    } > "$LOG"

    # === Unbind UCSI ===
    if [ -e /sys/bus/platform/drivers/ucsi_acpi/USBC000:00 ]; then
      echo "USBC000:00" > /sys/bus/platform/drivers/ucsi_acpi/unbind
      echo "pre: UCSI unbound"
    fi

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
    # NOTE: no set -e — individual steps may fail without aborting the whole
    # script (e.g. UCSI rebind when device is already bound).

    # === Rebind UCSI ===
    if [ -e /sys/bus/platform/drivers/ucsi_acpi/bind ]; then
      echo "USBC000:00" > /sys/bus/platform/drivers/ucsi_acpi/bind 2>/dev/null && \
        echo "post: UCSI rebound" || \
        echo "post: UCSI already bound"
    fi
    sleep 1

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

      echo "Top 5 wakeup sources:"
      cat /sys/kernel/debug/wakeup_sources 2>/dev/null | sort -k6 -rn | head -6

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

        # Disable ACPI wakeup sources (except power button)
        if [ -e /proc/acpi/wakeup ]; then
          for dev in GPP6 GP11 GP12 XHC1 XHC3 XHC4 NHI0 NHI1; do
            echo "$dev" > /proc/acpi/wakeup 2>/dev/null || true
          done
          echo "Disabled ACPI wakeup sources"
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
