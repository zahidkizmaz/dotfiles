# Vane Container Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deploy Vane, a privacy-focused AI answering engine, as a container on the lenovo-y5070 host.

**Architecture:** Single NixOS container (`vane`) with an OCI podman container inside running `itzcrazykns1337/vane:slim-latest`, exposed via Tailscale. Uses existing Ollama (192.168.100.25) for LLM inference and existing SearxNG (192.168.100.13) for web search.

**Tech Stack:** NixOS containers (systemd-nspawn), Podman, OCI containers, Tailscale, Next.js (Vane)

---

### Files

| File | Action | Purpose |
|---|---|---|
| `nixos/containers/vane.nix` | Create | NixOS + OCI container definition for Vane |
| `nixos/containers/default.nix` | Modify | Register vane in containerMeta (ip: 192.168.100.27) |
| `nixos/hosts/lenovo-y5070/containers.nix` | Modify | Enable vane container on lenovo-y5070 |

---

### Task 1: Create container definition (`vane.nix`)

**Files:**
- Create: `nixos/containers/vane.nix`

- [ ] **Step 1: Write the full `vane.nix`**

Modeled after `nixos/containers/hermes-agent.nix`. Key differences:
- Container name: `vane`
- Image: `itzcrazykns1337/vane:slim-latest`
- Port: 3000
- Environment: `SEARXNG_API_URL=http://192.168.100.13:8080`
- Volume: `vane-data:/home/vane/data`
- `cmd` is omitted (Vane uses its default CMD from the image)
- Same `--network=host` pattern to reach Ollama and SearxNG

```nix
{
  stateVersion,
  localAddress,
  hostAddress,
  inputs,
  user,
  ...
}:
let
  port = 3000;
  containerName = "vane";
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
    extraFlags = [
      "--capability=CAP_NET_ADMIN"
      "--capability=CAP_SYS_ADMIN"
    ];
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

        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.oci-containers = {
          backend = "podman";
          containers.vane = {
            autoStart = true;
            image = "itzcrazykns1337/vane:slim-latest";
            environment = {
              SEARXNG_API_URL = "http://192.168.100.13:8080";
            };
            volumes = [
              "vane-data:/home/vane/data:rw"
            ];
            extraOptions = [
              "--restart=unless-stopped"
              # Share the NixOS container's network so Vane can reach
              # ollama at 192.168.100.25:11434 and searxng at
              # 192.168.100.13:8080.
              "--network=host"
            ];
            autoRemoveOnStop = false;
          };
        };

        environment.etc."containers/containers.conf".text = lib.mkForce ''
          [engine]

          [containers]
          keyring = false
        '';

        system.stateVersion = stateVersion;
      };
  };
}
```

- [ ] **Step 2: Verify syntax is valid**

Run: `nix-instantiate --parse nixos/containers/vane.nix 2>&1 || echo "Needs eval context, that's ok"`

---

### Task 2: Register vane in the central container registry

**Files:**
- Modify: `nixos/containers/default.nix` (add vane entry after hermes-agent)

- [ ] **Step 1: Add `vane` entry to `containerMeta`**

Insert right after the `hermes-agent` block (after line 103):

```nix
          vane = {
            path = ./vane.nix;
            cname = "vane";
            ip = "192.168.100.27";
          };
```

- [ ] **Step 2: Verify the file still parses**

Run: `nix-instantiate --parse nixos/containers/default.nix`

---

### Task 3: Enable vane on lenovo-y5070

**Files:**
- Modify: `nixos/hosts/lenovo-y5070/containers.nix`

- [ ] **Step 1: Add `vane` to the enabled containers list**

Add after the `hermes-agent` block (after line 24):

```nix
      vane = {
        enable = true;
      };
```

Expected final `containers` attrset:

```nix
    containers = {
      ollama = {
        enable = true;
        models = [ "gemma4:e4b" ];
      };
      hermes-agent = {
        enable = true;
      };
      vane = {
        enable = true;
      };
    };
```

- [ ] **Step 2: Final verification**

Run: `nix flake check .#lenovo-y5070` or a dry build to confirm everything evaluates.

---

### Task 4: Commit and deploy

- [ ] **Step 1: Commit the changes**

```bash
git add nixos/containers/vane.nix \
       nixos/containers/default.nix \
       nixos/hosts/lenovo-y5070/containers.nix \
       docs/superpowers/specs/2026-06-19-vane-container-design.md \
       docs/superpowers/plans/2026-06-19-vane-container.md
git commit -m "feat: add Vane container for lenovo-y5070"
```

- [ ] **Step 2: Deploy**

Run: `nixos-rebuild switch --flake .#lenovo-y5070 --target-host root@lenovo-y5070 --use-remote-sudo`
