{ ... }:
{
  homebrew = {
    enable = true;
    brews = [ "awscli" "heroku" "gh" ];
    casks = [ "copyq" "hammerspoon" ];
  };
}
