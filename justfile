alias s := stow
alias sl := stow-linux
alias sm := stow-mac

default:
  just --list

stow arg:
  stow --adopt -vSt ~ {{arg}}

_stow-common:
  just stow atuin
  just stow bat
  just stow ctags
  just stow direnv
  just stow easyeffects
  just stow fzf
  just stow git
  just stow ipython
  just stow kitty
  just stow nvim
  just stow pgcli
  just stow rustfmt
  just stow starship
  just stow tmux
  just stow zsh

stow-linux: _stow-common
  just stow dunst
  just stow hypr
  just stow nix
  just stow tofi
  just stow waybar

stow-mac: _stow-common
