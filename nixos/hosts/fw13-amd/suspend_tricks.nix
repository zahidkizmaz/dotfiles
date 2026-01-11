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

        # Verify what's still enabled
        echo "Remaining enabled wakeup sources:"
        cat /proc/acpi/wakeup | grep enabled || echo "None (good!)"
      '';
    };
  };

  # Unbind UCSI before suspend (proper workaround for driver limitation)
  systemd.services.suspend-ucsi = {
    description = "Unbind UCSI before suspend (driver doesn't support runtime PM)";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "suspend-ucsi" ''
        # Unbind UCSI ACPI driver
        if [ -e /sys/bus/acpi/drivers/ucsi_acpi/USBC000:00 ]; then
          echo "USBC000:00" > /sys/bus/acpi/drivers/ucsi_acpi/unbind
        fi
      '';
    };
  };

  # Rebind UCSI after wake
  systemd.services.resume-ucsi = {
    description = "Rebind UCSI after wake";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "resume-ucsi" ''
        # Rebind UCSI ACPI driver
        if [ -e /sys/bus/acpi/drivers/ucsi_acpi/bind ]; then
          echo "USBC000:00" > /sys/bus/acpi/drivers/ucsi_acpi/bind
        fi
        sleep 1
      '';
    };
  };

  # Force NVMe into low power state during suspend
  systemd.services.nvme-suspend = {
    description = "Put NVMe into low power state before suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "nvme-suspend" ''
        # Set NVMe to lowest power state
        # State 4 is typically the deepest non-volatile power state
        ${pkgs.nvme-cli}/bin/nvme set-feature /dev/nvme0 -f 0x02 -v 4 2>/dev/null || true

        echo "NVMe set to low power state"
      '';
    };
  };

  # Restore NVMe to active state after wake
  systemd.services.nvme-resume = {
    description = "Restore NVMe to active state after wake";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "nvme-resume" ''
        # Set NVMe back to active state (state 0)
        ${pkgs.nvme-cli}/bin/nvme set-feature /dev/nvme0 -f 0x02 -v 0 2>/dev/null || true

        echo "NVMe restored to active state"
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
        echo "Voltage Now: $(cat /sys/class/power_supply/BAT1/voltage_now)" >> "$LOG"

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

  systemd.services.wakeup-monitor-before = {
    description = "Monitor wakeup improvements before suspend";
    before = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "monitor-wakeups" ''
        LOG="/var/log/wakeup-monitor.log"

        echo "=== Sleeing at $(date) ===" > "$LOG"
        # Total wakeup count
        WAKEUP_COUNT=$(cat /sys/power/wakeup_count)
        echo "BEFORE SLEEP: Total wakeup count: $WAKEUP_COUNT" >> "$LOG"
        echo "BEFORE SLEEP: Voltage Now: $(cat /sys/class/power_supply/BAT1/voltage_now)" >> "$LOG"
        echo "BEFORE SLEEP: Battery: $(cat /sys/class/power_supply/BAT1/capacity)%" >> "$LOG"
        echo "" >> "$LOG"
      '';
    };
  };
}
