{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs = {
    hyprland.enable = true;
    hyprland.withUWSM = true;
    hyprland.package = pkgs-unstable.hyprland;
    hyprlock.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs-unstable; [
    hypridle
    hyprlock
    hyprsunset
    hyprpolkitagent
    hyprland-qt-support
  ];

  systemd.user.services."hyprsunset-automate" = {
    serviceConfig = {
      Type = "simple";
    };
    enable = true;
    startAt = "*:0/1";
    path = with pkgs-unstable; [
      bash
      hyprsunset
    ];
    script = ''
      START_HOUR=21
      STOP_HOUR=9

      declare -i current_hour
      current_hour=$(date +%k)

      if ((START_HOUR > STOP_HOUR)); then
        if ((current_hour >= START_HOUR || current_hour < STOP_HOUR)); then
          if ! pgrep -x hyprsunset >/dev/null; then
            echo "INFO: Starting hyprsunset current_hour:$current_hour"
            "${pkgs-unstable.hyprsunset}/bin/hyprsunset" -t 3500
          fi
        else
          echo "INFO: Stopping hyprsunset current_hour:$current_hour"
          pkill -x hyprsunset
        fi
      else
        if ((current_hour >= START_HOUR && current_hour < STOP_HOUR)); then
          if ! pgrep -x hyprsunset >/dev/null; then
            echo "INFO: Starting hyprsunset current_hour:$current_hour"
            "${pkgs-unstable.hyprsunset}/bin/hyprsunset" -t 3500
          fi
        else
          echo "INFO: Stopping hyprsunset current_hour:$current_hour"
          pkill -x hyprsunset
        fi
      fi
    '';
  };
}
