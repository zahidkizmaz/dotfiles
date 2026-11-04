# AGENTS.md

This repo manages personal dotfiles and homelab servers. Everything is declarative
where possible: Nix flakes for hosts, Home Manager for user config, and GNU Stow for
symlinking app configs.

## Layout

- Top-level app dirs (`kitty/`, `nvim/`, `zsh/`, `tmux/`, ...) are **stow packages**.
  Each contains config under `.config/` (or `.local/`, etc.) and is symlinked into `$HOME`.
- `nixos/hosts/<host>/` — per-host NixOS / nix-darwin configs. See `flake.nix` for the
  full list (`fw13-amd`, `lenovo-y5070`, `nuc-g5`, `pi4b`, `pi5`, `sgo2`, `MONDO-1192`).
- `nixos/modules/` — reusable NixOS modules (desktop, containers, users, services).
- `nixos/containers/` — self-hosted services (immich, forgejo, grafana, paperless,
  mealie, navidrome, etc.) and their shared options.
- `nixos/secrets/` — agenix-encrypted secrets. **Never commit plaintext secrets.**
- `nixos/templates/` — flake templates for dev shells.
- `nixos/bin/` — helper scripts (`link-dotfiles`, `download-dotfiles`, `daily-update`).

## Common commands

```sh
# Validate the flake for all systems (what CI runs)
nix flake check --all-systems

# Build a host without switching
nix build .#nixosConfigurations.<host>.config.system.build.toplevel

# Stow all packages for this platform
just stow-linux    # Linux set
just stow-mac      # macOS set
stow -vSt ~ <app>  # single app

# Generate Raspberry Pi SD image
just gen-pi4b-sd-image
just gen-pi5-sd-image
```

## Conventions

- Format Nix with `nixfmt`, Lua with `stylua`, shell with `shfmt`, YAML with
  `yamllint --strict` + `yamlfmt`, TOML with `taplo`, JSON5 with `fixjson`.
- Pre-commit runs the same hooks as CI. Run `pre-commit run --all-files` (or `prek`)
  before pushing.
- Prefer shared modules in `nixos/modules/` over host-specific duplication.
- Host-specific hardware/disko/quirks belong in the host directory, not in shared modules.
- New services go in `nixos/containers/` and get wired up from the relevant host.
- New secrets use agenix; add the `.age` file and reference it via `age.secrets`.
- Avoid `--impure` and imperative edits unless there is no declarative option.
- Don't leave one-off workarounds or commented-out settings behind.
- Don't add docstrings or comments unless it is really needed. Code should speak for itself.

## Validation

Always validate Nix changes before applying:

```sh
nix flake check --all-systems
nix build .#nixosConfigurations. <host >.config.system.build.toplevel
```

For container changes, build the host that runs the container. CI builds every host
in `.github/workflows/ci.yml`; keep that matrix in mind when adding a host.

## Boundaries

- Never commit secrets, tokens, or private keys. `nixos/secrets/` is agenix-encrypted;
  plaintext must stay out of git.
- Ask before adding dependencies or new flake inputs.
- Ask before destructive or irreversible actions (force-push, `rm -rf`, history
  rewrites, dropping data, reformatting disks).
- **Never switch systems.** Do not run `nixos-rebuild switch`, `nh os switch`,
  `darwin-rebuild switch`, or `just deploy` unless explicitly asked. Build/validate only.

## Context hygiene

- Aggregate output with `rg`/`jq`/`awk`/`sort`/`uniq`/`wc`/`head` instead of dumping
  whole files.
- For cross-file questions, compute the answer in a short script and print only the summary.
- Don't re-read files already in context; search them or refer back.
