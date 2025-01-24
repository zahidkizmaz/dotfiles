{ lib, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = lib.mkDefault 3;
  boot.initrd.enable = true;
  boot.initrd.systemd.enable = true;
}
