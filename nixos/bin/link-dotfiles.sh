# app -> callable
declare -A appMappings=(
  [aichat]="aichat"
  [anyrun]="anyrun"
  [atuin]="atuin"
  [bat]="bat"
  [copyq]="copyq"
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
  [sesh]="sesh"
  [starship]="starship"
  [tmux]="tmux"
  [tofi]="tofi"
  [udiskie]="udiskie"
  [waybar]="waybar"
  [yazi]="yazi"
  [zsh]="zsh"
)

if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles to $HOME/dotfiles..."
  clone_cmd="git clone git@github.com:zahidkizmaz/dotfiles.git $HOME/dotfiles"
  if ! $clone_cmd; then
    echo "SSH clone failed, falling back to HTTPS. Remember to set the remote directory to SSH later."
    git clone https://github.com/zahidkizmaz/dotfiles.git "$HOME/dotfiles"
  fi
fi
cd "$HOME/dotfiles/" || exit
for app in "${!appMappings[@]}"; do
  cmd="${appMappings[$app]}"
  if command -v "$cmd" >/dev/null 2>&1; then
    stow -v 2 -St ~ "$app"
  fi
done
