# Ollama Container for lenovo-y5070

**Date:** 2026-06-14
**Status:** Design

## Container

- **File:** `nixos/containers/ollama.nix`
- **Internal name:** `ollama`
- **Pattern:** Same as `immich.nix` — `privateNetwork`, `autoStart`, tailscale, `container-common`
- **IP in containerMeta:** `192.168.100.25`
- **CPU-only:** `package = pkgs.ollama-cpu`

## Services

Uses the NixOS `services.ollama` module with:

| Option | Value | Reason |
|--------|-------|--------|
| `enable` | `true` | |
| `host` | `"0.0.0.0"` | Listen on all interfaces (tailscale + host access) |
| `port` | `11434` | Default ollama port |
| `package` | `pkgs.ollama-cpu` | No GPU, CPU-only |
| `loadModels` | From host config | Models to preload |
| `openFirewall` | `true` | Allow connections |

## Models Configuration

A `models` option is added to the per-container submodule in `options.nix`:

```nix
models = mkOption {
  type = types.listOf types.str;
  default = [ ];
};
```

Hosts specify models declaratively:

```nix
appContainers.containers.ollama = {
  enable = true;
  models = [ "qwen3:27b" ];
};
```

## Files Changed

| File | Action |
|------|--------|
| `containers/ollama.nix` | New |
| `containers/options.nix` | Add `models` to container submodule |
| `containers/default.nix` | Add `ollama` to `containerMeta`; pass `models` on import |
| `hosts/lenovo-y5070/containers.nix` | Enable `appContainers`, add ollama |
