{ inputs, stateVersion, ... }:
inputs.nixos-raspberrypi.lib.nixosSystem {
  modules = [
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
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
    inherit inputs stateVersion;
    user = "pi";
  };
}
