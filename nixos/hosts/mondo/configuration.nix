{ lib, system, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault system;
  system.stateVersion = 5;
}
