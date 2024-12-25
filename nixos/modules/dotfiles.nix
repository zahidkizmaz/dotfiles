{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    gitMinimal
  ];

  system.activationScripts = {
    clone-dotfiles.text /*bash*/ =
      ''
        if [ ! -d "$HOME/dotfiles" ]; then
            echo "Cloning dotfiles to $HOME/dotfiles..."
            ${pkgs.git}/bin/git clone git@github.com:zahidkizmaz/dotfiles.git $HOME/dotfiles
        fi
      '';
  };
}
