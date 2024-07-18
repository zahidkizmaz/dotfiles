{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    copyq
    dconf
    dunst
    grim
    networkmanagerapplet
    pcmanfm
    playerctl
    slurp
    tofi
    wl-clipboard
  ];


  system.activationScripts = {
    desktop-env.text =
      ''
        ln -sfn ../../dunst/.config/dunst /home/${user}/.config/dunst/
        ln -sfn ../../tofi/.config/tofi /home/${user}/.config/tofi/
      '';
  };
}
