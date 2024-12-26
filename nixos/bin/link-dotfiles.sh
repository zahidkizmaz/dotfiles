#!/usr/bin/env bash
set -euo pipefail

# app -> callable
declare -A appMappings=(
  [atuin]="atuin"
  [bat]="bat"
  [ctags]="ctags"
  [direnv]="direnv"
  [dunst]="dunst"
  [fzf]="fzf"
  [git]="git"
  [ipython]="ipython"
  [hypr]="hyprctl"
  [kitty]="kitty"
  [nix]="nix"
  [nvim]="nvim"
  [pgcli]="pgcli"
  [rustfmt]="rustfmt"
  [starship]="starship"
  [tmux]="tmux"
  [tofi]="tofi"
  [waybar]="waybar"
  [zsh]="zsh"
)

cd "$HOME/dotfiles/"
for app in "${!appMappings[@]}"; do
  cmd="${appMappings[$app]}"
  if command -v "$cmd" >/dev/null 2>&1; then
    stow -v 2 -St ~ "$app"
  fi
done
