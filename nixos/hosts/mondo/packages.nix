{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; };
in
{
  environment.systemPackages = with pkgs-unstable; [
    heroku
  ];
}
