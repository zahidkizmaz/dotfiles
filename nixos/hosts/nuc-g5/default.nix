{ inputs, ... }:
inputs.nixpkgs-unstable.lib.nixosSystem {
  system = "x86_64_linux";
  modules = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    ./configuration.nix
    ../../containers/adguardhome.nix
    ../../modules/better-shell.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/gc.nix
    ../../modules/nix-settings.nix
    ../../modules/podman.nix
    ../../modules/ssh.nix
  ];
  specialArgs = { inherit inputs; user = "g5"; };
}
