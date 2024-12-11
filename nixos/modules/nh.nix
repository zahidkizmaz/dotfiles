{ user, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/${user}/dotfiles";
  };
}
