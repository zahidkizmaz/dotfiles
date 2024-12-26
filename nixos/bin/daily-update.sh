if command -v "zeesh-update" >/dev/null 2>&1; then
  echo "\nUpdating zeesh plugins"
  zeesh-update
fi

if command -v "bat" >/dev/null 2>&1; then
  echo "\nBuilding bat cache"
  bat cache --build
fi

if command -v "tldr" >/dev/null 2>&1; then
  echo "\nUpdating tldr"
  tldr --update
fi

if command -v "brew" >/dev/null 2>&1; then
  echo "\nUpdating brew packages"
  brew update && brew upgrade && brew upgrade --cask && brew cleanup && brew autoremove
fi

if command -v "nvim" >/dev/null 2>&1; then
  echo "\nUpdating nvim packages"
  nvim --headless -c "Lazy! sync" -c "TSUpdateSync all" +qa
fi
