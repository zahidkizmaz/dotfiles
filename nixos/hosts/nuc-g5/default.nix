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
    ../../modules/better-shell.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/default-user.nix
    ../../modules/gc.nix
    ../../modules/kde-plasma.nix
    ../../modules/nh.nix
    ../../modules/nix-settings.nix
    ../../modules/podman.nix
    ../../modules/sound-pipewire.nix
    ../../modules/ssd.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ../../modules/vm-variant.nix
  ];
  specialArgs = {
    inherit inputs system stateVersion;
    user = "g5";
  };
}
