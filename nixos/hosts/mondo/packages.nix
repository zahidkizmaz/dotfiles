{
  pkgs,
  inputs,
  system,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (inputs.nixpkgs-unstable.lib.getName pkg) [
        "claude-code"
      ];
  };

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
    claude-code
    docker
    docker-compose
    gemini-cli
    nh
    unixtools.watch
    utm
  ]);
}
