{ inputs, ... }:
let
  microvm = inputs.microvm.nixosModules;
in
{
  imports = [
    microvm.host
    ./immich.nix
  ];
}
