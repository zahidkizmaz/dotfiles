{ inputs, pkgs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
in
{
  environment.systemPackages = import ../common/nvimPackages.nix { pkgs = pkgs-unstable; };
}
