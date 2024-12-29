{ pkgs }: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      deadnix
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
