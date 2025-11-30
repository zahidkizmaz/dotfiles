{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
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
      httpie
      jq
      just
      jwt-cli
      ouch
      ripgrep
      stow
      tree
      unzip
      watchman
      yazi
      zip
      zoxide
    ]);
}
