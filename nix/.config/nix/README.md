# NixOS Configuration

## Development Environment

Using [nix-direnv](https://github.com/nix-community/nix-direnv) with flakes.


Create a flake for development environment in a project folder.

```shell
nix flake new -t github:nix-community/nix-direnv .
direnv allow
```

### Example dev environment:

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
        };
      });
}
```
