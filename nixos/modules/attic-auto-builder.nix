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
  # Each target is built in its own `nix build` call and every successful
  # output is pushed. A single combined `nix build` for all hosts fails
  # atomically: one broken host (e.g. an insecure package) aborts the whole
  # invocation and caches nothing. Errors stay visible in the journal; we no
  # longer pipe through `grep '^/nix/store' ... || true`, which silently hid
  # failures and always reported success.
  buildAndPushToAttic = ''
    set -euo pipefail

    # Build nixos configurations with current flake.lock
    # `nixpkgs.system` throws when read if hostPlatform is set (nixpkgs >= 24.05),
    # which nixos-raspberrypi sets; `pkgs.stdenv.hostPlatform.system` always works.
    systems=$(nix eval --json '.#nixosConfigurations' --apply 'builtins.mapAttrs (n: v: v.pkgs.stdenv.hostPlatform.system)')
    hosts=$(echo "$systems" | jq -r --arg cur "${pkgs.stdenv.hostPlatform.system}" 'to_entries[] | select(.value == $cur) | .key')

    outPaths=$(mktemp)
    trap 'rm -f "$outPaths"' EXIT

    build_one() {
      local desc="$1"
      shift
      echo "  -> $desc"
      if "$@" >> "$outPaths"; then
        return 0
      fi
      echo "  !! FAILED to build $desc" >&2
      atticFailed=1
      return 0
    }

    echo "Building ${pkgs.stdenv.hostPlatform.system} hosts..."
    for host in $hosts; do
      build_one ".#nixosConfigurations.$host.config.system.build.toplevel" \
        nix build ".#nixosConfigurations.$host.config.system.build.toplevel" --no-link --print-out-paths
    done

    # Build dev shells if enabled
    ${optionalString cfg.buildDevShells ''
      echo "Building dev shells..."
      for system in ${toString allDevShellSystems}; do
        build_one ".#devShells.$system.default" \
          nix build ".#devShells.$system.default" --no-link --print-out-paths
      done
    ''}

    if [ -s "$outPaths" ]; then
      echo "Pushing $(wc -l < "$outPaths") path(s) to attic..."
      attic push default --stdin < "$outPaths"
    else
      echo "!! nothing was built, nothing to push" >&2
      atticFailed=1
    fi
    rm -f "$outPaths"

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

          atticFailed=0

          if [ -d "$HOME/dotfiles/.git" ]; then
            echo "Pulling latest dotfiles..."
            cd "$HOME/dotfiles"
            # A previous run's `nix flake update` leaves flake.lock dirty, which
            # makes `git pull --ff-only` refuse to fast-forward forever. Drop it
            # so the pull can proceed; the update pass below regenerates it.
            git checkout -- flake.lock 2>/dev/null || true
            if ! git pull --ff-only; then
              echo "!! git pull failed; continuing with the current (possibly stale) checkout" >&2
              atticFailed=1
            fi
          else
            echo "Cloning dotfiles..."
            git clone https://forgejo.quoll-ratio.ts.net/zahid/dotfiles "$HOME/dotfiles"
            cd "$HOME/dotfiles"
          fi

          # ── First build: with the committed flake.lock ────────
          ${buildAndPushToAttic}

          # ── If runFlakeUpdate: second build after update ──────
          ${optionalString cfg.runFlakeUpdate ''
            echo ""
            echo "=== Running nix flake update ==="
            nix flake update 2>&1 || { echo "!! nix flake update failed" >&2; atticFailed=1; }

            echo ""
            echo "=== Second build with updated inputs ==="
            ${buildAndPushToAttic}

            echo ""
            echo "=== Attic cache now has both states ==="
          ''}

          # Leave the checkout clean so the next run can fast-forward.
          git checkout -- flake.lock 2>/dev/null || true

          if [ "$atticFailed" -ne 0 ]; then
            echo "=== attic-auto-builder finished WITH FAILURES: $(date) ===" >&2
            exit 1
          fi
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
