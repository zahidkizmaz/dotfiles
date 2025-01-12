{ pkgs, ... }:
{
  imports = [ ./aliases.nix ];
  programs = {
    zsh.enable = true;
    direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    atuin
    bat
    delta
    eza
    fd
    fzf
    jq
    ripgrep
    yazi
    zoxide
  ];
}
