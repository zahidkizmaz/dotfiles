{ inputs, pkgs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; };
  nushell_pkgs = with pkgs-unstable; [
    # These are used as external_completer in nushell
    carapace
    fish
    nushell
    nushellPlugins.polars
  ];
in
{
  programs = {
    direnv.enable = true;
  };

  environment.systemPackages =
    nushell_pkgs
    ++ (with pkgs-unstable; [
      atuin
      bat
      delta
      eza
      fd
      fzf
      gitMinimal
      jq
      just
      ouch
      ripgrep
      stow
      tree
      unzip
      yazi
      zip
      zoxide
    ]);
}
