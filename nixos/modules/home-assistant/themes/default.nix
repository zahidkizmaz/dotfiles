{ pkgs, ... }:
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
      ExecStart = "${pkgs.writeShellScript "copy-themes" ''
        mkdir -p /var/lib/hass/themes
        cp -r ${themesDir}/*.yaml /var/lib/hass/themes/
        chown -R hass:hass /var/lib/hass/themes
      ''}";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
