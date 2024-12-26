{ pkgs, ... }:
let
  link-dotfiles = pkgs.writeShellApplication {
    name = "link-dotfiles";
    runtimeInputs = with pkgs;[ bash stow ];
    text = builtins.readFile ../bin/link-dotfiles.sh;
  };
  daily-update = pkgs.writeShellApplication {
    name = "daily-update";
    runtimeInputs = with pkgs;[ bash ];
    text = builtins.readFile ../bin/daily-update.sh;
  };
in
{
  environment.systemPackages = with pkgs; [
    gitMinimal
    gh
    link-dotfiles
    daily-update
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
