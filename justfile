alias s := stow
alias sl := stow-linux
alias sm := stow-mac

default:
    just --list

stow arg:
    stow --adopt -vSt ~ {{ arg }}

_stow-common:
    just stow aichat
    just stow atuin
    just stow bat
    just stow copyq
    just stow ctags
    just stow direnv
    just stow easyeffects
    just stow gh-dash
    just stow ghostty
    just stow git
    just stow ipython
    just stow kitty
    just stow mpv
    just stow nushell
    just stow nvim
    just stow opencode
    just stow pgcli
    just stow rustfmt
    just stow starship
    just stow tmux
    just stow yazi
    just stow zsh

stow-linux: _stow-common
    just stow dunst
    just stow hypr
    just stow nix
    just stow nwg-displays
    just stow tofi
    just stow udiskie
    just stow waybar

stow-mac: _stow-common

gen-pi4b-sd-image:
    nix build .#nixosConfigurations.pi4b.config.formats.sd-aarch64 -o ./pi4b.sd
