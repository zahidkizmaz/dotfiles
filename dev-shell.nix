{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      deadnix
      fixjson
      just
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
