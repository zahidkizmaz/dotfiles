{ pkgs, user, ... }:
{

  programs = {
    zsh.enable = true;
    direnv.enable = true;
  };


  environment.systemPackages = with pkgs; [
    atuin
    bat
    delta
    fd
    fzf
    jq
    ripgrep
    zoxide
  ];

  system.userActivationScripts = {
    zsh-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/atuin/.config/atuin /home/${user}/.config/atuin
        ln -sfn /home/${user}/dotfiles/bat/.config/bat /home/${user}/.config/bat
        ln -sfn /home/${user}/dotfiles/zsh/.config/zsh /home/${user}/.config/zsh
        ln -sfn /home/${user}/dotfiles/zsh/.zshenv /home/${user}/.zshenv
      '';
  };
}
