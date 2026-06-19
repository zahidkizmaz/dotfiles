# Vane Container for lenovo-y5070

## Overview

Set up [Vane](https://github.com/ItzCrazyKns/Vane) — a privacy-focused AI
answering engine — as a NixOS container on the `lenovo-y5070` host, following
the same pattern as `hermes-agent.nix` and `watch.nix`. Vane will use existing
infrastructure: Ollama (for LLM inference) and SearxNG (for web search).

## Architecture

```
NixOS Host (lenovo-y5070)
  └── NixOS Container "vane" (192.168.100.27)
        ├── Tailscale → vane.quoll-ratio.ts.net:443
        ├── tailscale-serve: 443 → localhost:3000
        │
        └── OCI Container "vane"
              (itzcrazykns1337/vane:slim-latest)
              ├── port 3000 (web UI + API)
              ├── --network=host
              │   → Ollama  at 192.168.100.25:11434
              │   → SearxNG at 192.168.100.13:8080
              ├── volume: vane-data → /home/vane/data
              └── env: SEARXNG_API_URL=http://192.168.100.13:8080
```

## Key Decisions

| Decision | Rationale |
|---|---|
| **slim image** | Avoids bundling a duplicate SearxNG — reuse existing instance |
| **--network=host** | OCI container shares NixOS container's network, so it can reach Ollama and SearxNG on their 192.168.100.x addresses |
| **Single NixOS container** | Matches `hermes-agent.nix` pattern — one service per container |
| **No backup config yet** | Vane data (SQLite DB, settings, uploads) is at `/home/vane/data` on the vane-data volume. Backup can be added later as needed |

## Files to Create/Modify

### 1. New: `nixos/containers/vane.nix`

NixOS container definition modeled after `hermes-agent.nix`:

- NixOS container named `vane`
- Private network at `192.168.100.27`
- Tailscale with `tailscale-serve` proxying `443 → 3000`
- OCI container `itzcrazykns1337/vane:slim-latest`
- `--network=host` for Ollama/SearxNG access
- Volume mount `vane-data:/home/vane/data`
- Environment: `SEARXNG_API_URL=http://192.168.100.13:8080`
- Port 3000 exposed

### 2. Modify: `nixos/containers/default.nix`

Add to `containerMeta`:

```nix
vane = {
  path = ./vane.nix;
  cname = "vane";
  ip = "192.168.100.27";
};
```

### 3. Modify: `nixos/hosts/lenovo-y5070/containers.nix`

Enable `vane` under `appContainers.containers`:

```nix
vane = {
  enable = true;
};
```

## Initial Setup (After Deployment)

Since Vane's configuration (AI provider, models, API keys) is done through its
web UI setup wizard, no static config is needed at build time. After the
container is built and deployed:

1. Visit `https://vane.quoll-ratio.ts.net`
2. Complete the setup wizard:
   - **AI Provider**: Ollama (URL: `http://192.168.100.25:11434`)
   - **Chat Model**: Pick from the models available on this host
   - **SearxNG URL**: `http://192.168.100.13:8080` (pre-set via env var)
   - **Embedding Model**: Optional, for file upload functionality
3. Start using Vane
