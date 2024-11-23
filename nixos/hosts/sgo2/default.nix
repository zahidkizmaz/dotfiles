{ inputs, stateVersion, ... }:
let
  system = "x86_64_linux";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "${system}";
  modules = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-go
    inputs.disko.nixosModules.disko
    inputs.nix-ld.nixosModules.nix-ld
    inputs.home-manager.nixosModules.home-manager
    ./configuration.nix
    ../../modules/better-shell.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/bluetooth.nix
    ../../modules/default-user.nix
    ../../modules/documentation.nix
    ../../modules/dotfiles.nix
    ../../modules/gc.nix
    ../../modules/kitty.nix
    ../../modules/gui-applications.nix
    ../../modules/gnome.nix
    ../../modules/nix-settings.nix
    ../../modules/sound-pipewire.nix
    ../../modules/ssd.nix
    ../../modules/ssh.nix
    ../../modules/vm-variant.nix
    ../../modules/wlan.nix
    ../../modules/zsh.nix
  ];
  specialArgs = { inherit inputs system stateVersion; user = "go2"; };
}
