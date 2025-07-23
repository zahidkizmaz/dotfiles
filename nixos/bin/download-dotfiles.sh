# download dotfiles from GitHub repository
if [ ! -d "$HOME/dotfiles" ]; then
  echo "Cloning dotfiles to $HOME/dotfiles..."
  git clone git@github.com:zahidkizmaz/dotfiles.git "$HOME/dotfiles"
else
  echo "Dotfiles already exist in $HOME/dotfiles, skipping clone."
fi
