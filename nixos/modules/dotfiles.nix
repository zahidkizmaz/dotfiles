{ pkgs, ... }:
let
  download-dotfiles = pkgs.writeShellApplication {
    name = "download-dotfiles";
    runtimeInputs = with pkgs; [
      bash
      gitMinimal
    ];
    text = builtins.readFile ../bin/download-dotfiles.sh;
  };
  link-dotfiles = pkgs.writeShellApplication {
    name = "link-dotfiles";
    runtimeInputs = with pkgs; [
      bash
      gitMinimal
      stow
    ];
    text = builtins.readFile ../bin/link-dotfiles.sh;
  };
  daily-update = pkgs.writeShellApplication {
    name = "daily-update";
    runtimeInputs = with pkgs; [ bash ];
    text = builtins.readFile ../bin/daily-update.sh;
  };
in
{
  environment.systemPackages = with pkgs; [
    gitMinimal
    gh
    gh-dash

    download-dotfiles
    link-dotfiles
    daily-update
  ];
}
