remove_dir_if_not_symlink() {
  local dir="$1"
  if [ -d "$dir" ] && [ ! -L "$dir" ]; then
    rm -rf "$dir"
    echo "Removed directory: $dir. Because it is not a symlink"
  fi
}

# app -> callable
declare -A appMappings=(
  [aichat]="aichat"
  [atuin]="atuin"
  [bat]="bat"
  [copyq]="copyq"
  [ctags]="ctags"
  [direnv]="direnv"
  [dunst]="dunst"
  [easyeffects]="easyeffects"
  ["gh-dash"]="gh-dash"
  [ghostty]="ghostty"
  [git]="git"
  [httpie]="http"
  [hypr]="hyprctl"
  [ipython]="ipython"
  [kitty]="kitty"
  [mpv]="mpv"
  [nix]="nix"
  [nushell]="nu"
  [nvim]="nvim"
  [opencode]="opencode"
  ["nwg-displays"]="nwg-displays"
  [pgcli]="pgcli"
  [rustfmt]="rustfmt"
  [sesh]="sesh"
  [starship]="starship"
  [tmux]="tmux"
  [tofi]="tofi"
  [udiskie]="udiskie"
  [vicinae]="vicinae"
  [waybar]="waybar"
  [yazi]="yazi"
  [zsh]="zsh"
)

# Clone dotfiles from GH
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles to $HOME/dotfiles..."
  clone_cmd="git clone git@github.com:zahidkizmaz/dotfiles.git $HOME/dotfiles"
  if ! $clone_cmd; then
    echo "SSH clone failed, falling back to HTTPS. Remember to set the remote directory to SSH later."
    git clone https://github.com/zahidkizmaz/dotfiles.git "$HOME/dotfiles"
  fi
fi

# Make sure some apps are symlinked
remove_dir_if_not_symlink "$HOME/.config/hypr/"
remove_dir_if_not_symlink "$HOME/.config/kitty/"

cd "$HOME/dotfiles/" || exit
for app in "${!appMappings[@]}"; do
  cmd="${appMappings[$app]}"
  if command -v "$cmd" >/dev/null 2>&1; then
    stow -v 2 -St ~ "$app"
  fi
done
