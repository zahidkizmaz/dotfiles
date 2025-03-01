{ pkgs, ... }:
{
  programs = {
    direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    atuin
    bat
    delta
    eza
    fd
    fish # used as an external completer for nushell
    fzf
    jq
    ripgrep
    yazi
    zoxide
  ];
}
