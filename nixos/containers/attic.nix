{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
# ── Attic Nix Binary Cache ───────────────────────────────────────────────
# URL: https://attic.quoll-ratio.ts.net/  |  http://attic.quoll-ratio.ts.net:8989/
#
# Generate admin token (inside container):
#   atticd-atticadm make-token --sub admin --validity "10 years" --push '*' --pull '*' --create-cache '*' --configure-cache '*' --destroy-cache '*'
#
# Generate builder token (push/pull default cache only):
#   atticd-atticadm make-token --sub builder --validity "10 years" --push default --pull default
#
# Client commands:
#   attic login <name> http://attic.quoll-ratio.ts.net:8989/ <token>
#   attic cache create default
#   attic cache info default
#   attic cache configure default --public
#   attic cache configure default --retention-period "30 days"
#   attic push default <path>
#
# Secrets:
#   attic-jwt-secret.age  → ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64="..."
#   attic-token.age       → raw JWT (no KEY= prefix)
#
# Consumer:  substituter = http://attic.quoll-ratio.ts.net:8989/default
#            public key  = default:YqYsdlMl7pprxhKIYfdlqD/8DGjzrJjKb6aBi3G0zjU=
# ────────────────────────────────────────────────────────────────────────────

let
  containerName = "attic";
  port = 8989;
in
{
  containers.${containerName} = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "identity";
    enableTun = true;
    ephemeral = false;
    hostAddress = hostAddress;
    localAddress = localAddress;
    bindMounts = {
      "/etc/ssh/lab" = {
        hostPath = "/home/${user}/.ssh/lab";
        isReadOnly = true;
      };
    };
    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = [
          ./container-common.nix
          (import ./container-tailscale.nix {
            inherit
              config
              inputs
              lib
              pkgs
              port
              ;
          })
        ];

        age.secrets.attic-jwt-secret = {
          file = ../secrets/attic-jwt-secret.age;
        };

        environment.systemPackages = with pkgs; [ attic-client ];

        services.atticd = {
          enable = true;
          mode = "monolithic";
          environmentFile = config.age.secrets.attic-jwt-secret.path;
          settings = {
            listen = "[::]:${toString port}";
          };
        };
        system.stateVersion = stateVersion;
      };
  };
}
