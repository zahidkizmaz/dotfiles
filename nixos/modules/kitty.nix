{ pkgs, user, ... }:
{

  environment.systemPackages = with pkgs; [
    kitty
    starship
    tmux
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "IosevkaTerm" "Noto" ]; })
    noto-fonts-color-emoji
  ];

  system.userActivationScripts = {
    kitty-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/kitty/.config/kitty /home/${user}/.config/kitty
        ln -sfn /home/${user}/dotfiles/starship/.config/starship.toml /home/${user}/.config/starship.toml
        ln -sfn /home/${user}/dotfiles/tmux/.config/tmux /home/${user}/.config/tmux
      '';
  };
}
