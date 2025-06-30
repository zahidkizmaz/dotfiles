{ pkgs }:
let
  nvimConfigPath = ./nvim/.config/nvim;
  nvimScripts = [
    (pkgs.writeShellScriptBin "nv" ''
      set -x
      nvim -u ${nvimConfigPath}/init.lua
      set +x
    '')
  ];
in
{
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      deadnix
      fixjson
      just
      nixd
      nixfmt-rfc-style
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

  nvim = pkgs.mkShell {
    buildInputs = nvimScripts ++ import ./nixos/common/nvimPackages.nix { inherit pkgs; };
  };
}
