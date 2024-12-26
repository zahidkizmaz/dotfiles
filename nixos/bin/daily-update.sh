if command -v "zeesh-update" >/dev/null 2>&1; then
  echo "Updating zeesh plugins"
  zeesh-update
fi

if command -v "bat" >/dev/null 2>&1; then
  echo "Building bat cache"
  bat cache --build
fi

if command -v "tldr" >/dev/null 2>&1; then
  echo "Updating tldr"
  tldr --update
fi

if command -v "brew" >/dev/null 2>&1; then
  echo "Updating brew packages"
  brew update && brew upgrade && brew upgrade --cask && brew cleanup && brew autoremove
fi

if command -v "nvim" >/dev/null 2>&1; then
  echo "Updating nvim packages"
  nvim --headless -c "Lazy! sync" -c "TSUpdateSync all" +qa
fi
