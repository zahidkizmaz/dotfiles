{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    copyq
    dunst
    grim
    networkmanagerapplet
    pcmanfm
    playerctl
    slurp
    tofi
    wl-clipboard
  ];

  programs.dconf.enable = true;

  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/tofi/.config/tofi /home/${user}/.config/tofi
        ln -sfn /home/${user}/dotfiles/dunst/.config/dunst /home/${user}/.config/dunst
        ln -sfn /home/${user}/dotfiles/easyeffects/.config/easyeffects /home/${user}/.config/easyeffects
      '';
  };
}
