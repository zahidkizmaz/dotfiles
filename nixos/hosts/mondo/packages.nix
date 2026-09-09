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
  ++ (with pkgs-unstable; [
    bruno
    claude-code
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
