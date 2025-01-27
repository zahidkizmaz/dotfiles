{ pkgs, user, ... }:
let
  lowBatteryNotification = pkgs.writeShellApplication {
    name = "low-battery-notification";
    runtimeInputs = with pkgs; [
      libnotify
      dbus
    ];
    text # bash
      = ''
        capacity=$(cat /sys/class/power_supply/BAT1/capacity)
        notify-send -i battery-empty -u critical 'Low Battery!' "Battery level is $capacity%. Plug in your charger!"
      '';
  };
in
{
  environment.systemPackages = with pkgs; [
    dunst
    libnotify
    lowBatteryNotification
  ];

  systemd.services.low-battery-notification = {
    description = "Low Battery Notification Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lowBatteryNotification}/bin/low-battery-notification";
      User = "${user}";
      Environment = [
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="BAT1", ENV{POWER_SUPPLY_STATUS}=="Discharging", ATTR{capacity_level}=="Critical|Low", TAG+="systemd", ENV{SYSTEMD_WANTS}="low-battery-notification.service"
  '';
}
