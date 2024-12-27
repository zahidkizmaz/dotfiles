if command -v "zeesh-update" >/dev/null 2>&1; then
  printf "\nUpdating zeesh plugins\n"
  zeesh-update
fi

if command -v "bat" >/dev/null 2>&1; then
  printf "\nBuilding bat cache\n"
  bat cache --build
fi

if command -v "tldr" >/dev/null 2>&1; then
  printf "\nUpdating tldr\n"
  tldr --update
fi

if command -v "brew" >/dev/null 2>&1; then
  printf "\nUpdating brew packages\n"
  brew update && brew upgrade && brew upgrade --cask && brew cleanup && brew autoremove
fi

if command -v "nvim" >/dev/null 2>&1; then
  printf "\nUpdating nvim packages\n"
  nvim --headless -c "Lazy! sync" -c "TSUpdateSync all" +qa
fi
