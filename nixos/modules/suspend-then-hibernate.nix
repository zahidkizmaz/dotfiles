{ ... }:
{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    powerKey = "suspend-then-hibernate";
    powerKeyLongPress = "poweroff";
  };
}
