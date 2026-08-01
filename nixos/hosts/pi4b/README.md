# Raspberry Pi 4B — NixOS

Configuration: [dotfiles](https://github.com/zahid/typescript-nuxt-form-builder/tree/main/nixos/hosts/pi4b)

## Install (SD card)

Build an SD card image:

```shell
just gen-pi4b-sd-image
```

The image is ready at `./result/sd-image/nixos-sd-image-{version}-aarch64-linux.img.zst`.
Decompress and flash:

```shell
nix shell nixpkgs#zstd
zstdcat ./pi4b.sd/nixos-image-sd-card-{version}-aarch64-linux.img.zst \
  | sudo dd of=/dev/sda status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k
```
