{ inputs, ... }:
inputs.nixpkgs-unstable.lib.nixosSystem {
  system = "x86_64_linux";
  modules = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    ./configuration.nix
    ./disko.nix
    ../../containers/adguardhome.nix
    ../../modules/better-shell.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/default-user.nix
    ../../modules/gc.nix
    ../../modules/kde-plasma.nix
    ../../modules/nix-settings.nix
    ../../modules/podman.nix
    ../../modules/ssd.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
  ];
  specialArgs = { inherit inputs; user = "g5"; };
}
