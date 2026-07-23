{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.atticClient;
  atticWatchScript = pkgs.writeShellScript "attic-watch" ''
        set -euo pipefail
        mkdir -p "$HOME/.config/attic"
        cat > "$HOME/.config/attic/config.toml" <<EOF
    default-server = "attic"

    [servers.attic]
    endpoint = "http://attic.quoll-ratio.ts.net:8989/"
    token = "$(cat ${config.age.secrets.attic-token.path})"
    EOF
        exec ${pkgs.attic-client}/bin/attic watch-store default
  '';
in
{
  options.atticClient = {
    enable = mkEnableOption "Attic client";

    watch = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the attic watch daemon to auto-push Nix store paths";
      };
    };
  };

  config = mkIf cfg.enable {
    nix.settings = {
      extra-substituters = [
        "http://attic.quoll-ratio.ts.net:8989/default"
      ];
      trusted-public-keys = [
        "default:YqYsdlMl7pprxhKIYfdlqD/8DGjzrJjKb6aBi3G0zjU="
      ];
    };

    environment.systemPackages = with pkgs; [
      attic-client
    ];

    age.secrets.attic-token = {
      file = ../secrets/attic-token.age;
      mode = "440";
      group = "users";
    };

    systemd.services.attic-watch = mkIf cfg.watch.enable {
      description = "Attic watch daemon - auto-push Nix store paths";
      after = [
        "network-online.target"
        "nix-daemon.service"
      ];
      wants = [
        "network-online.target"
        "nix-daemon.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${atticWatchScript}";
        Restart = "on-failure";
        RestartSec = 10;
      };
    };
  };
}
