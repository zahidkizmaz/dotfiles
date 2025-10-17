{ ... }:
{
  xdg.desktopEntries.home-assistant = {
    name = "Home Assistant Dashboard";
    genericName = "Home Automation Dashboard";
    comment = "Open Home Assistant dashboard in Firefox";
    exec = "firefox --kiosk https://home.quoll-ratio.ts.net";
    icon = "firefox";
    categories = [
      "Utility"
      "Network"
    ];
    terminal = false;
  };
}
