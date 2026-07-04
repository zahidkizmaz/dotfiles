{
  config,
  lib,
  pkgs,
  user,
  ...
}:

with lib;

{
  config = {
    systemd.services.attic-auto-builder = {
      description = "Build all NixOS hosts and push to attic";
      after = [
        "network-online.target"
        "nix-daemon.service"
      ];
      wants = [
        "network-online.target"
        "nix-daemon.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = user;
      };
      path = with pkgs; [
        attic-client
        git
      ];
      script = ''
                set -euo pipefail

                echo "=== attic-auto-builder started: $(date) ==="

                mkdir -p "$HOME/.config/attic"
                cat > "$HOME/.config/attic/config.toml" <<EOF
        default-server = "attic"

        [servers.attic]
        endpoint = "https://attic.quoll-ratio.ts.net/"
        token = "$(cat ${config.age.secrets.attic-token.path})"
        EOF

                if [ -d "$HOME/dotfiles/.git" ]; then
                  echo "Pulling latest dotfiles from forgejo..."
                  cd "$HOME/dotfiles" && git pull --ff-only || true
                else
                  echo "Cloning dotfiles from forgejo..."
                  git clone https://forgejo.quoll-ratio.ts.net/zahid/dotfiles "$HOME/dotfiles"
                  cd "$HOME/dotfiles"
                fi

                echo "Building all NixOS hosts..."
                HOSTS=$(nix eval --json '.#nixosConfigurations' --apply 'x: builtins.attrNames x' 2>/dev/null | tr '[]",' ' ')
                for host in $HOSTS; do
                  echo "  Building $host..."
                  nix build ".#nixosConfigurations.$host.config.system.build.toplevel" 2>&1 | grep -v "^@" || true
                done

                echo "Pushing to attic..."
                attic push default --all || echo "  attic push failed (continuing)"

                echo "=== attic-auto-builder finished: $(date) ==="
      '';
    };

    systemd.timers.attic-auto-builder = {
      partOf = [ "attic-auto-builder.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };
    };
  };
}
