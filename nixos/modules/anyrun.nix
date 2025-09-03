{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  environment.systemPackages = [
    pkgs-unstable.anyrun
  ];
}
