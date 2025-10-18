{ pkgs, ... }:
let
  librewolf = pkgs.librewolf;
  url = "https://home.quoll-ratio.ts.net";
  homeAssistantDashboardDesktop = pkgs.makeDesktopItem {
    name = "home-assistant-dashboard";
    desktopName = "Home Assistant Dashboard";
    comment = "Open Home Assistant dashboard in Librewolf fullscreen kiosk mode";
    icon = ./home-assistant.svg;
    exec = "${librewolf}/bin/librewolf --kiosk --no-remote --new-window ${url}";
    categories = [
      "Utility"
      "Network"
    ];
    terminal = false;
  };
in
{
  environment.systemPackages = [ homeAssistantDashboardDesktop ];
}
