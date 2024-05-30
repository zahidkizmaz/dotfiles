alias s := stow
alias sl := stow-linux
alias sm := stow-mac

default:
  just --list

stow arg:
  stow -vSt ~ {{arg}}

_stow-common:
  just stow alacritty
  just stow atuin
  just stow bat
  just stow ctags
  just stow efm-langserver
  just stow fzf
  just stow git
  just stow kitty
  just stow git
  just stow nvim
  just stow pgcli
  just stow git
  just stow rustfmt
  just stow starship
  just stow rustfmt
  just stow tmux
  just stow wezterm
  just stow zsh

stow-linux: _stow-common
  just stow dunst
  just stow hypr
  just stow nix
  just stow tofi
  just stow waybar

stow-mac: _stow-common
