{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; };

  # atuin 18.21.0, the last Hydra-cached darwin build; unpin once
  # https://github.com/NixOS/nixpkgs/pull/574333 reaches nixos-unstable.
  pkgs-atuin = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/e322a4a91ec16f8951c3a4cce6964c67e5db6cd6.tar.gz";
    sha256 = "00s392z1lm2gj5p9b8f318a1ln9nvaclf09zh0fpx9anck31kikw";
  }) { system = pkgs.stdenv.hostPlatform.system; };
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
    pkgs-atuin.atuin
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
