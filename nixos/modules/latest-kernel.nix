{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
}
