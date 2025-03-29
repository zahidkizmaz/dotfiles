{ pkgs, ... }:
{
  services.printing = {
    # Cups admin panel:
    # http://localhost:631/admin/
    enable = true;
    openFirewall = true;
    drivers = with pkgs; [
      gutenprint
      epson-escpr
    ];
  };
}
