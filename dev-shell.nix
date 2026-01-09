{ pkgs }:
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      deadnix
      fixjson
      just
      nixd
      nixfmt
      pre-commit
      stow
      stylua
      shfmt
      yamlfmt
    ];
    shellHook = ''
      pre-commit install
    '';
  };
}
