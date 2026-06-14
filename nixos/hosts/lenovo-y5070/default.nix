{ inputs, stateVersion, ... }:
let
  system = "x86_64-linux";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "${system}";
  modules = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ./configuration.nix
    ./containers.nix
    ./disko.nix
    ./hardware-configuration.nix
    ../../modules/agenix.nix
    ../../modules/ai.nix
    ../../modules/better-shell.nix
    ../../modules/bluetooth.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/default-user.nix
    ../../modules/gc.nix
    ../../modules/nh.nix
    ../../modules/nix-settings.nix
    ../../modules/podman.nix
    ../../modules/sound-pipewire.nix
    ../../modules/ssd.nix
    ../../modules/ssh.nix
    ../../modules/tailscale-lab.nix
    ../../modules/vm-variant.nix
    ../../modules/wlan.nix
  ];
  specialArgs = {
    inherit
      inputs
      system
      stateVersion
      ;
    user = "y5070";
  };
}
