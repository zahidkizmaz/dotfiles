{ pkgs, user, ... }:
{

  environment.systemPackages = with pkgs; [
    dunst
    libnotify
  ];


  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/dunst/.config/dunst /home/${user}/.config/dunst
      '';
  };
}
