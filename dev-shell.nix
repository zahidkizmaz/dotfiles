{ pkgs }: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      nixd
      nixpkgs-fmt
      deadnix
      stow
      stylua
      just
      pre-commit
    ];
  };
}
