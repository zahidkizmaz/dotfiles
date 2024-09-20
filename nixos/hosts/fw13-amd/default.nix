{ inputs, ... }:
let
  system = "x86_64-linux";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "${system}";
  modules = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.nix-ld.nixosModules.nix-ld
    inputs.home-manager.nixosModules.home-manager
    ./configuration.nix
    ../../modules/agenix.nix
    ../../modules/bluetooth.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/desktop-user.nix
    ../../modules/fingerprint.nix
    ../../modules/gc.nix
    ../../modules/gui-applications.nix
    ../../modules/hyprland.nix
    ../../modules/ld.nix
    ../../modules/login-manager-tuigreet.nix
    ../../modules/nix-settings.nix
    ../../modules/nvim.nix
    ../../modules/ollama.nix
    ../../modules/podman.nix
    ../../modules/sound-pipewire.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ../../modules/virt-manager.nix
    ../../modules/vm-variant.nix
    ../../modules/waybar.nix
    ../../modules/wayland-desktop-environment.nix
    ../../modules/wlan.nix
    ../../modules/xdg-mime.nix
  ];
  specialArgs = { inherit inputs system; user = "zahid"; };
}