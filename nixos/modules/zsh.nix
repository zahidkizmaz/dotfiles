{ pkgs, is_darwin ? false, ... }:
let
  shellInit =
    if is_darwin then /*bash*/''
      [[ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]] && source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    '' else "";
in
{
  programs = {
    zsh = {
      enable = true;
      shellInit = shellInit;
    };
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
    yazi
    zoxide
  ];
}
