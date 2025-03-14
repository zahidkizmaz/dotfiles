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
    ../../modules/agenix.nix
    ../../modules/ai.nix
    ../../modules/bluetooth.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/cli-tools.nix
    ../../modules/desktop-user.nix
    ../../modules/gc.nix
    ../../modules/gui-applications.nix
    ../../modules/hyprland.nix
    ../../modules/ld.nix
    ../../modules/login-manager-tuigreet.nix
    ../../modules/nix-settings.nix
    ../../modules/nvim.nix
    ../../modules/podman.nix
    ../../modules/sound-pipewire.nix
    ../../modules/ssh.nix
    ../../modules/tailscale.nix
    ../../modules/terminal.nix
    ../../modules/virt-manager.nix
    ../../modules/vm-variant.nix
    ../../modules/waybar.nix
    ../../modules/wayland-desktop-environment.nix
    ../../modules/wlan.nix
    ../../modules/xdg-mime.nix
  ];
  specialArgs = {
    inherit inputs system stateVersion;
    user = "zahid";
  };
}
