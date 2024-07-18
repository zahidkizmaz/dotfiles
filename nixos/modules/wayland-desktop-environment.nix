{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    copyq
    dconf
    dunst
    easyeffects
    grim
    networkmanagerapplet
    pcmanfm
    playerctl
    slurp
    tofi
    wl-clipboard
  ];

  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/tofi/.config/tofi /home/${user}/.config/tofi
        ln -sfn /home/${user}/dotfiles/dunst/.config/dunst /home/${user}/.config/dunst
      '';
  };
}
