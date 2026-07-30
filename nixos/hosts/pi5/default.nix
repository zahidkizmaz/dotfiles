{ inputs, stateVersion, ... }:
let
  system = "aarch64-linux";
in
inputs.nixpkgs-unstable.lib.nixosSystem {
  system = "${system}";
  modules = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-5
    "${inputs.nixpkgs-unstable}/nixos/modules/profiles/minimal.nix"
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
    "${inputs.nixpkgs-unstable}/nixos/modules/image/images.nix"
    ./agenix.nix
    ./configuration.nix
    ./selfhost.nix
    ./disko.nix
    ./hardware-configuration.nix
    ../../modules/attic-auto-builder.nix
    ../../modules/attic-client.nix
    ../../modules/better-shell.nix
    ../../modules/default-user.nix
    ../../modules/gc.nix
    ../../modules/nh.nix
    ../../modules/nix-settings.nix
    ../../modules/ssh.nix
    ../../modules/tailscale-lab.nix
    ../../modules/vm-variant.nix
    (import ../../containers/monitoring/alloy-log-report.nix { })
  ];
  specialArgs = {
    inherit inputs system stateVersion;
    user = "pi";
  };
}
