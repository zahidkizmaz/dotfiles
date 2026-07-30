{ inputs, stateVersion, ... }:
let
  system = "aarch64-linux";
in
inputs.nixpkgs-unstable.lib.nixosSystem {
  system = "${system}";
  modules = [
    "${inputs.nixpkgs-unstable}/nixos/modules/image/images.nix"
    "${inputs.nixpkgs-unstable}/nixos/modules/profiles/minimal.nix"
    inputs.agenix.nixosModules.default
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ./agenix.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/attic-client.nix
    ../../modules/better-shell.nix
    ../../modules/default-user.nix
    ../../modules/gc.nix
    ../../modules/nh.nix
    ../../modules/nix-settings.nix
    ../../modules/ssh.nix
    ../../modules/tailscale-exit-node.nix
    ../../modules/vm-variant.nix
    (import ../../containers/monitoring/alloy-log-report.nix { })
  ];
  specialArgs = {
    inherit inputs system stateVersion;
    user = "pi";
  };
}
