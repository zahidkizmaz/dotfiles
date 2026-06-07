{ ... }:
{
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "2h";
  };
  services.logind = {
    settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
      HandlePowerKeyLongPress = "poweroff";
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
