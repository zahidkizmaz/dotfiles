{ inputs, stateVersion, ... }:
let
  system = "aarch64-linux";
in
inputs.nixpkgs-unstable.lib.nixosSystem {
  system = "${system}";
  modules = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    "${inputs.nixpkgs-unstable}/nixos/modules/profiles/minimal.nix"
    inputs.agenix.nixosModules.default
    inputs.nixos-generators.nixosModules.all-formats
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
  specialArgs = { inherit inputs system stateVersion; user = "pi"; };
}
