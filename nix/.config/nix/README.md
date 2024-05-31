# NixOS Configuration

## Development Environment

Using [nix-direnv](https://github.com/nix-community/nix-direnv) with flakes.


Create a flake for development environment in a project folder.

```shell
nix flake new -t github:nix-community/nix-direnv .
direnv allow
```
