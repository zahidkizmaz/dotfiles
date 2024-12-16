{ pkgs, user, ... }:
let
  lowBatteryNotification = pkgs.writeShellApplication {
    name = "low-battery-notification";
    runtimeInputs = [ pkgs.libnotify ];
    text /*bash*/ = ''
      #! ${pkgs.runtimeShell}

      set -x
      echo "Hello zahid"
      notify-send -i battery-empty -u critical 'Low Battery!'
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    dunst
    libnotify
    lowBatteryNotification
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="BAT1", ENV{POWER_SUPPLY_STATUS}=="Discharging", ATTR{capacity_level}=="Critical|Low", RUN+="${lowBatteryNotification}/bin/low-battery-notification"
  '';

  system.userActivationScripts = {
    dunst-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/dunst/.config/dunst /home/${user}/.config/dunst
      '';
  };
}
