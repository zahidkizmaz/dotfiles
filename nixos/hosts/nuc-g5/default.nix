{ inputs, stateVersion, ... }:
let
  system = "x86_64_linux";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "${system}";
  modules = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    ./configuration.nix
    ./disko.nix
    ../../modules/agenix.nix
    ../../modules/better-shell.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/default-user.nix
    ../../modules/docker.nix
    ../../modules/gc.nix
    ../../modules/nh.nix
    ../../modules/nix-settings.nix
    ../../modules/sound-pipewire.nix
    ../../modules/ssd.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ../../modules/vm-variant.nix
    ../../microvms
  ];
  specialArgs = {
    inherit inputs system stateVersion;
    user = "g5";
  };
}
