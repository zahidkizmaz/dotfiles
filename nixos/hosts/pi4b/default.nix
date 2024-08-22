{ inputs, ... }:
inputs.nixpkgs-unstable.lib.nixosSystem {
  system = "aarch64-linux";
  modules = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs-unstable}/nixos/modules/profiles/minimal.nix"
    inputs.agenix.nixosModules.default
    ./hardware-configuration.nix
    ./configuration.nix
    ./caddy.nix
    ../../containers/adguardhome.nix
    ../../modules/better-shell.nix
    ../../modules/default-user.nix
    ../../modules/gc.nix
    ../../modules/home-assistant
    ../../modules/nix-settings.nix
    ../../modules/podman.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
  ];
  specialArgs = { inherit inputs; user = "pi"; };
}
