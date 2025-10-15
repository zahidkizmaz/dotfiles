{ ... }:
let
  themesDir = ../themes;
in
{
  systemd.services.copyThemesToHass = {
    description = "Copy Home Assistant themes directory";
    wants = [ "network.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        mkdir -p /var/lib/hass/themes
        cp -r ${themesDir} /var/lib/hass/themes/
      '';
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
