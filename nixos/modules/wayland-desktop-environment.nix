{ pkgs, user, ... }:

{
  imports = [ ./dunst.nix ./icons.nix ];
  environment.systemPackages = with pkgs; [
    brightnessctl
    copyq
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
        ln -sfn /home/${user}/dotfiles/easyeffects/.config/easyeffects /home/${user}/.config/easyeffects
      '';
  };
}
