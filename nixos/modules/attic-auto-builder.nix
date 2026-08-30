{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;

let
  cfg = config.atticAutoBuilder;
  allDevShellSystems = unique ([ pkgs.stdenv.hostPlatform.system ] ++ cfg.additionalDevShellSystems);
  atticConfig = pkgs.writeShellScript "attic-config" ''
        mkdir -p "$HOME/.config/attic"
        cat > "$HOME/.config/attic/config.toml" <<EOF
    default-server = "attic"

    [servers.attic]
    endpoint = "http://attic.quoll-ratio.ts.net:8989/"
    token = "$(cat ${config.age.secrets.attic-token.path})"
    EOF
  '';

  # ── Build and push to attic (caller runs nix flake update) ────
  # This function builds Nix closures and pushes them to the attic cache.
  # The caller (main script) decides whether to run nix flake update before calling it.
  # Usage: just embed ${buildAndPushToAttic} in the bash script.
  buildAndPushToAttic = ''
    set -euo pipefail

    # Build nixos configurations with current flake.lock
    # `nixpkgs.system` throws when read if hostPlatform is set (nixpkgs >= 24.05),
    # which nixos-raspberrypi sets; `pkgs.stdenv.hostPlatform.system` always works.
    systems=$(nix eval --json '.#nixosConfigurations' --apply 'builtins.mapAttrs (n: v: v.pkgs.stdenv.hostPlatform.system)')
    hosts=$(echo "$systems" | jq -r --arg cur "${pkgs.stdenv.hostPlatform.system}" 'to_entries[] | select(.value == $cur) | .key')

    echo "Building ${pkgs.stdenv.hostPlatform.system} hosts..."
    targets=""
    for host in $hosts; do
      targets="$targets .#nixosConfigurations.$host.config.system.build.toplevel"
    done
    nix build $targets --no-link --print-out-paths 2>&1 | grep '^/nix/store' | attic push default --stdin || true

    # Build dev shells if enabled
    ${optionalString cfg.buildDevShells ''
      echo "Building dev shells..."
      for system in ${toString allDevShellSystems}; do
        echo "  building devShells.$system.default..."
        nix build ".#devShells.$system.default" --no-link --print-out-paths 2>&1 \
          | grep '^/nix/store' | attic push default --stdin || true
      done
    ''}

    echo "=== attic segment finished: $(date) ==="
  '';

in
{
  options.atticAutoBuilder = {
    buildDevShells = mkEnableOption "dev shell builds in auto-builder" // {
      description = "When enabled, the auto-builder also builds dev shells and pushes them to the attic cache.";
    };
    additionalDevShellSystems = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra system platforms to build dev shells for (e.g. aarch64-linux on an x86_64 host with binfmt emulation).";
    };
    runFlakeUpdate = mkEnableOption "run nix flake update and build both states" // {
      description = "When enabled, builds twice: first without update (current flake.lock), then runs nix flake update and builds with updated inputs. Both results pushed to attic cache.";
    };
  };

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
        jq
        nix
      ];
      script = # bash
        ''
          set -euo pipefail

          echo "=== attic-auto-builder started: $(date) ==="

          ${atticConfig}

          if [ -d "$HOME/dotfiles/.git" ]; then
            echo "Pulling latest dotfiles from forgejo..."
            cd "$HOME/dotfiles" && git pull --ff-only || true
          else
            echo "Cloning dotfiles from forgejo..."
            git clone https://forgejo.quoll-ratio.ts.net/zahid/dotfiles "$HOME/dotfiles"
            cd "$HOME/dotfiles"
          fi

          # ── First build: with current flake.lock ──────────────
          ${buildAndPushToAttic}

          # ── If runFlakeUpdate: second build after update ──────
          ${optionalString cfg.runFlakeUpdate ''
            echo ""
            echo "=== Running nix flake update ==="
            nix flake update 2>&1

            echo ""
            echo "=== Second build with updated inputs ==="
            ${buildAndPushToAttic}

            echo ""
            echo "=== Attic cache now has both states ==="
          ''}

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
