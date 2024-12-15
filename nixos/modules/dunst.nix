{ pkgs, user, ... }:
{

  environment.systemPackages = with pkgs; [
    dunst
    libnotify
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="BAT1", ENV{POWER_SUPPLY_STATUS}=="Discharging", ENV{POWER_SUPPLY_CAPACITY_LEVEL}=="Critical", RUN+="${pkgs.libnotify}/bin/notify-send -i battery-empty -u critical 'Low Battery!' "
  '';

  system.userActivationScripts = {
    dunst-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/dunst/.config/dunst /home/${user}/.config/dunst
      '';
  };
}
