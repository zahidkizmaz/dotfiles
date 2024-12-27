# Raspberry PI 4B Configuration



## Useful commands:

### Build image:

```shell
nix build .#images.pi4b -L
```

The image should be ready in `./result/sd-image/nixos-sd-image-{version}-aarch64-linux.img.zst`
We can decompress and put it in our SD card or drive.

```shell
# We would need zstd for decompressing
nix shell nixpkgs#zstd
zstdcat ./result/sd-image/nixos-sd-image-{version}-aarch64-linux.img.zst | \
    sudo dd of=/dev/sda status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k
```
