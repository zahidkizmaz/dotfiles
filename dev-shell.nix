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
      yamlfmt
    ];
    shellHook = ''
      prek install
    '';
  };
}
