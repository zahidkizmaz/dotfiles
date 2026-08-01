# Raspberry Pi 5 — NixOS

Configuration: [dotfiles](https://github.com/zahid/typescript-nuxt-form-builder/tree/main/nixos/hosts/pi5)

## Install (SD card)

Build an SD card image:

```shell
just gen-pi5-sd-image
```

The image is ready at `./pi5.sd/sd-image/nixos-image-sd-card-{version}-aarch64-linux.img.zst`.
Decompress and flash:

```shell
nix shell nixpkgs#zstd
zstdcat ./pi5.sd/sd-image/nixos-image-sd-card-{version}-aarch64-linux.img.zst \
  | sudo dd of=/dev/sda status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k
```
