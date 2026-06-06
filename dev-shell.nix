{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      deadnix
      fixjson
      just
      nix-fast-build
      nixd
      nixfmt
      prek
      shfmt
      stow
      stylua
      taplo
      yamlfmt
    ];
    shellHook = ''
      prek install -f --hook-type pre-commit
    '';
  };
}
