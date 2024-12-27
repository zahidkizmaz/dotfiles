{ pkgs, ... }:
let
  link-dotfiles = pkgs.writeShellApplication {
    name = "link-dotfiles";
    runtimeInputs = with pkgs;[ bash gitMinimal stow ];
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
}
