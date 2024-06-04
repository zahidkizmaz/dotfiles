# NixOS Configuration

## Development Environment

Using [nix-direnv](https://github.com/nix-community/nix-direnv) with flakes.


Create a flake for development environment in a project folder.

```shell
nix flake new -t github:nix-community/nix-direnv .
direnv allow
```

### Example dev environment python poetry:

flake.nix file:
```nix
{
  description = "Basic python flake with virtualenv and poetry";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
        NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
            pkgs.stdenv.cc.cc
            pkgs.gcc.cc
            pkgs.glibc
            pkgs.zlib
            pkgs.rustc
            pkgs.cargo
          ];
          NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
          venvDir = ".venv";
          postVenvCreation = ''
            		pip install -U pip
            		poetry env use system
            		poetry install
            	'';
          packages = with pkgs; [
            python312
            python312Packages.venvShellHook
            poetry
          ];
          preShellHook = ''
              # https://github.com/astral-sh/ruff/issues/1699
              # https://github.com/NixOS/nixpkgs/issues/142383
              export POETRY_INSTALLER_NO_BINARY="ruff"
          ''
        };
      });
}
```
