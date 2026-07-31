# Raspberry Pi 5 — NixOS

Configuration: [dotfiles](https://github.com/zahid/typescript-nuxt-form-builder/tree/main/nixos/hosts/pi5)

## Install

Boot a temporary NixOS on the Pi5 (via SD card or netboot), then:

```shell
sudo nix run github:nix-community/nixos-anywhere -- \
  --flake github:zahid/typescript-nuxt-form-builder#pi5 \
  --disk-main /dev/nvme0n1
```

Adjust `--disk-main` to match your drive (e.g. `/dev/sda` for USB).

> Uses [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) + [disko](https://github.com/nix-community/disko).
> The disko layout creates FIRMWARE + ESP + btrfs root with subvolumes.

## Build an SD card image (alternative)

```shell
nix build github:zahid/typescript-nuxt-form-builder#nixosConfigurations.pi5.config.system.build.sdImage
```
