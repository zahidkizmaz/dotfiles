{ pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; };

  copyq-fix = pkgs.writeShellApplication {
    name = "copyq-fix";
    runtimeInputs = with pkgs; [ bash ];
    text = builtins.readFile ./scripts/copyq_fix.sh;
  };
in
{
  environment.systemPackages = [
    copyq-fix
  ]
  ++ (with pkgs-unstable; [
    bruno
    docker
    docker-compose
    nh
    utm
  ]);
}
