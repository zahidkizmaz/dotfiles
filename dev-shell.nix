{ pkgs }: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      deadnix
      fixjson
      just
      nixd
      nixpkgs-fmt
      pre-commit
      stow
      stylua
      shfmt
      yamlfmt
    ];
  };
}
