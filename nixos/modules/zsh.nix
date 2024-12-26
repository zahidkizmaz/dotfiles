{ pkgs, ... }:
{
  programs = {
    zsh.enable = true;
    direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    atuin
    bat
    delta
    fd
    fzf
    jq
    ripgrep
    zoxide
  ];
}
