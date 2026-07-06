{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  environment.systemPackages = with pkgs-unstable; [
    libcamera
  ];
}
