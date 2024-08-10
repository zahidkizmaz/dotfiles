{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akonadi-contacts
    elisa
    kmail
    kmail-account-wizard
    kmailtransport
    konsole
    kontact
    konversation
    kpublictransport
    kruler
    kteatime
    ktouch
    kspaceduel
    ksquares
    ksudoku
    ktorrent
    kturtle
    kwallet
    marble
    oxygen
    plasma-browser-integration
    umbrello
  ];
}
