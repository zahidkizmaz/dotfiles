{ inputs, stateVersion, ... }:
inputs.nixos-raspberrypi.lib.nixosSystem {
  modules = [
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.base
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.bluetooth
    inputs.nixos-raspberrypi.nixosModules.sd-image
    inputs.agenix.nixosModules.default
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
    inherit inputs stateVersion;
    user = "pi";
  };
}
