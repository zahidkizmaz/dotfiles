# app -> callable
declare -A appMappings=(
  [aichat]="aichat"
  [anyrun]="anyrun"
  [atuin]="atuin"
  [bat]="bat"
  [ctags]="ctags"
  [direnv]="direnv"
  [dunst]="dunst"
  [easyeffects]="easyeffects"
  [ghostty]="ghostty"
  [git]="git"
  [hypr]="hyprctl"
  [ipython]="ipython"
  [kitty]="kitty"
  [mpv]="mpv"
  [nix]="nix"
  [nushell]="nu"
  [nvim]="nvim"
  [pgcli]="pgcli"
  [rustfmt]="rustfmt"
  [starship]="starship"
  [tmux]="tmux"
  [tofi]="tofi"
  [waybar]="waybar"
  [yazi]="yazi"
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
