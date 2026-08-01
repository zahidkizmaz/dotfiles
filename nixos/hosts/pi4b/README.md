# Raspberry Pi 4B — NixOS

Configuration: [dotfiles](https://github.com/zahid/typescript-nuxt-form-builder/tree/main/nixos/hosts/pi4b)

## Install (SD card)

Build an SD card image:

```shell
just gen-pi4b-sd-image
```

The image is ready at `./pi4b.sd/sd-image/nixos-image-rpi4-kernel.img.zst`.
Decompress and flash:

```shell
nix shell nixpkgs#zstd
zstdcat ./pi4b.sd/sd-image/nixos-image-rpi4-kernel.img.zst \
  | sudo dd of=/dev/sda status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k
```
