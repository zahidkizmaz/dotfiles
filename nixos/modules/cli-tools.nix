{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };
in
{
  programs = {
    direnv = {
      enable = true;
      package = pkgs-unstable.direnv;
      nix-direnv = {
        enable = true;
        package = pkgs-unstable.nix-direnv;
      };
    };
  };

  environment.systemPackages = with pkgs-unstable; [
    atuin
    bat
    delta
    eza
    fd
    fzf
    gitMinimal
    httpie
    jq
    just
    jwt-cli
    lnav
    nix-fast-build
    ouch
    ripgrep
    stow
    tree
    unzip
    watchman
    yazi
    zip
    zoxide
  ];
}
