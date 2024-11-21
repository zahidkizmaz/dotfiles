{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    gitMinimal
  ];

  system.userActivationScripts = {
    clone-dotfiles.text =
      ''
        if [ ! -d "$HOME/dotfiles" ]; then
            echo "Cloning dotfiles to $HOME/dotfiles..."
            ${pkgs.git}/bin/git clone git@github.com:zahidkizmaz/dotfiles.git $HOME/dotfiles
        fi
      '';
  };
}
