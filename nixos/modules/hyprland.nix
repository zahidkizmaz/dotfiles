{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs = {
    hyprland.enable = true;
    hyprland.package = pkgs-unstable.hyprland;
    hyprlock.enable = true;
  };
  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = false;
  };
  security.polkit.enable = true;

  environment.systemPackages = with pkgs-unstable; [
    hypridle
    hyprlock
    hyprsunset
    hyprpolkitagent
    hyprland-qt-support
    rose-pine-hyprcursor
  ];

  systemd.user.services.custom-hyprpolkitagent = {
    description = "Hyprland Polkit Authentication Agent";
    # Start with the graphical session (works both with and without UWSM)
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    # Only run inside a Wayland session (same as upstream)
    unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs-unstable.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = "5s";
      Slice = "session-*.slice";
      TimeoutStopSec = "5s";
    };
  };
}
