# app -> callable
declare -A appMappings=(
  [aichat]="aichat"
  [atuin]="atuin"
  [anyrun]="anyrun"
  [bat]="bat"
  [ctags]="ctags"
  [direnv]="direnv"
  [easyeffects]="easyeffects"
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

if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles to $HOME/dotfiles..."
  git clone git@github.com:zahidkizmaz/dotfiles.git "$HOME/dotfiles"
fi
cd "$HOME/dotfiles/" || exit
for app in "${!appMappings[@]}"; do
  cmd="${appMappings[$app]}"
  if command -v "$cmd" >/dev/null 2>&1; then
    stow -v 2 -St ~ "$app"
  fi
done
