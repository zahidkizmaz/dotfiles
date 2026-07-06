{
  pkgs,
  inputs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (inputs.nixpkgs-unstable.lib.getName pkg) [
        "claude-code"
        "android-studio"
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
    google-cloud-sdk
    nh
    nodejs_24
    python314
    python314Packages.uv
    unixtools.watch
    utm
  ]);
}
