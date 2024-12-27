{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hicolor-icon-theme
    papirus-icon-theme
  ];

  xdg.icons.enable = true;
}
