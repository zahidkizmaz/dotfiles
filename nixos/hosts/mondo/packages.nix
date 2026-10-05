{
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (inputs.nixpkgs-unstable.lib.getName pkg) [
        "android-studio"
      ];
  };
  llm-agents-pkgs = inputs.llm-agents.packages.${system};

  copyq-fix = pkgs.writeShellApplication {
    name = "copyq-fix";
    runtimeInputs = with pkgs; [ bash ];
    text = builtins.readFile ./scripts/copyq_fix.sh;
  };

  gdk = pkgs-unstable.google-cloud-sdk.withExtraComponents (
    with pkgs-unstable.google-cloud-sdk.components;
    [
      # component list can be found:
      # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/by-name/go/google-cloud-sdk/components.json
      cloud-sql-proxy
    ]
  );
in
{
  environment.systemPackages = [
    copyq-fix
  ]
  ++ (with llm-agents-pkgs; [
    claude-code
  ])
  ++ (with pkgs-unstable; [
    bruno
    docker
    docker-compose
    gdk
    herdr
    nh
    nodejs_24
    python314
    python314Packages.uv
    unixtools.watch
    utm
  ]);
}
