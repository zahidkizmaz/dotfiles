{ ... }:
{
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
  };
  services.logind = {
    settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "suspend-then-hibernate";
      HandlePowerKeyLongPress = "poweroff";
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
