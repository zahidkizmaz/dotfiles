{ pkgs, ... }:
let
  firefox = pkgs.firefox;
  url = "https://home.quoll-ratio.ts.net";
  homeAssistantDashboardDesktop = pkgs.makeDesktopItem {
    name = "home-assistant-dashboard";
    desktopName = "Home Assistant Dashboard";
    comment = "Open Home Assistant dashboard in Firefox fullscreen kiosk mode";
    icon = "${firefox}/share/icons/hicolor/48x48/apps/firefox.png";
    exec = "${firefox}/bin/firefox --kiosk --no-remote --new-window ${url}";
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
