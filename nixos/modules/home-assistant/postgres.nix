{ pkgs, ... }:
{
  services.home-assistant.config = {
    recorder.db_url = "postgresql://@/hass";
  };
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "hass" ];
    ensureUsers = [
      {
        name = "hass";
        ensureDBOwnership = true;
      }
    ];
  };
}
