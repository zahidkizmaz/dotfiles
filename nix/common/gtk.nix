{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gtk3
    papirus-icon-theme
    (catppuccin-gtk.override {
      accents = [ "pink" ]; # You can specify multiple accents here to output multiple themes
      size = "compact";
      tweaks = [ "rimless" "black" ]; # You can also specify multiple tweaks here
      variant = "mocha";
    })
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
    };
  };
}
