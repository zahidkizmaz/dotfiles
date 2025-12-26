{ pkgs, ... }:
{
  systemd.services.disable-wakeups = {
    description = "Disable i2c and serio wakeup sources";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "disable-wakeups" ''
        # Disable i2c-PIXA3854:00 (ambient light sensor / touchpad)
        # This is causing 6913 wakeup events!
        for i2c in /sys/devices/platform/AMDI0010:03/i2c-*/i2c-PIXA3854:00/power/wakeup; do
          if [ -e "$i2c" ]; then
            echo "disabled" > "$i2c"
            echo "Disabled wakeup for: $i2c"
          fi
        done

        # Alternative path for i2c device
        for i2c in /sys/bus/i2c/devices/i2c-PIXA3854:00/power/wakeup; do
          if [ -e "$i2c" ]; then
            echo "disabled" > "$i2c"
            echo "Disabled wakeup for: $i2c"
          fi
        done

        # Disable serio0 (keyboard/touchpad PS/2 interface)
        # This is causing 1045 wakeup events!
        if [ -e /sys/devices/platform/i8042/serio0/power/wakeup ]; then
          echo "disabled" > /sys/devices/platform/i8042/serio0/power/wakeup
          echo "Disabled wakeup for: serio0"
        fi

        # Disable all USB-C power delivery wakeups
        for usbc in /sys/devices/platform/USBC000:00/*/power/wakeup; do
          if [ -e "$usbc" ]; then
            echo "disabled" > "$usbc"
            echo "Disabled wakeup for: $(basename $(dirname $usbc))"
          fi
        done

        # Disable USB-C UCSI wakeups (Framework expansion card ports)
        for ucsi in /sys/devices/platform/USBC000:00/power/wakeup \
                    /sys/devices/platform/USBC000:00/*/power/wakeup \
                    /sys/class/power_supply/ucsi-source-psy-*/wakeup; do
          if [ -e "$ucsi" ]; then
            echo "disabled" > "$ucsi" 2>/dev/null || true
          fi
        done

        # Disable ACPI wakeup sources (except power button)
        if [ -e /proc/acpi/wakeup ]; then
          # Disable GPP6, GP11, GP12 (PCIe bridges)
          echo "GPP6" > /proc/acpi/wakeup 2>/dev/null || true
          echo "GP11" > /proc/acpi/wakeup 2>/dev/null || true
          echo "GP12" > /proc/acpi/wakeup 2>/dev/null || true

          # Disable USB controllers (you can still use USB, just can't wake from it)
          # echo "XHC0" > /proc/acpi/wakeup 2>/dev/null || true # this one seems to be the external keyboard
          echo "XHC1" > /proc/acpi/wakeup 2>/dev/null || true
          echo "XHC3" > /proc/acpi/wakeup 2>/dev/null || true
          echo "XHC4" > /proc/acpi/wakeup 2>/dev/null || true

          # Disable Thunderbolt NHI controllers
          echo "NHI0" > /proc/acpi/wakeup 2>/dev/null || true
          echo "NHI1" > /proc/acpi/wakeup 2>/dev/null || true

          echo "Disabled ACPI wakeup sources"
        fi

        # Internal keyboard (serio0/PS2) - re-enable if it exists
        if [ -e /sys/devices/platform/i8042/serio0/power/wakeup ]; then
          echo "enabled" > /sys/devices/platform/i8042/serio0/power/wakeup
          echo "Enabled keyboard wake for: serio0 (internal)"
        fi

        # Verify what's still enabled
        echo "Remaining enabled wakeup sources:"
        cat /proc/acpi/wakeup | grep enabled || echo "None (good!)"
      '';
    };
  };

  # ===== Monitor Improvements =====
  systemd.services.wakeup-monitor = {
    description = "Monitor wakeup improvements";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "monitor-wakeups" ''
        LOG="/var/log/wakeup-monitor.log"

        echo "=== Wake at $(date) ===" >> "$LOG"

        # Total wakeup count
        WAKEUP_COUNT=$(cat /sys/power/wakeup_count)
        echo "Total wakeup count: $WAKEUP_COUNT" >> "$LOG"

        # Top wakeup sources
        echo "" >> "$LOG"
        echo "Top 5 wakeup sources:" >> "$LOG"
        cat /sys/kernel/debug/wakeup_sources | sort -k6 -rn | head -6 >> "$LOG"

        # Check if our fixes are working
        echo "" >> "$LOG"
        echo "i2c-PIXA3854 wakeup status:" >> "$LOG"
        for i2c in /sys/devices/platform/AMDI0010:03/i2c-*/i2c-PIXA3854:00/power/wakeup; do
          if [ -e "$i2c" ]; then
            echo "  Status: $(cat $i2c)" >> "$LOG"
          fi
        done

        echo "serio0 wakeup status:" >> "$LOG"
        if [ -e /sys/devices/platform/i8042/serio0/power/wakeup ]; then
          echo "  Status: $(cat /sys/devices/platform/i8042/serio0/power/wakeup)" >> "$LOG"
        else
          echo "  Device not found (possibly disabled by kernel param)" >> "$LOG"
        fi

        echo "" >> "$LOG"
        echo "Battery: $(cat /sys/class/power_supply/BAT1/capacity)%" >> "$LOG"
        echo "" >> "$LOG"
      '';
    };
  };
}
