{ inputs, stateVersion, ... }:
let
  system = "x86_64_linux";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "${system}";
  modules = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-go
    inputs.home-manager.nixosModules.home-manager
    ./configuration.nix
    ../../modules/better-shell.nix
    ../../modules/bluetooth.nix
    ../../modules/bootloader-systemd.nix
    ../../modules/default-user.nix
    ../../modules/documentation.nix
    ../../modules/dotfiles.nix
    ../../modules/gc.nix
    ../../modules/gnome.nix
    ../../modules/gui-applications.nix
    ../../modules/nh.nix
    ../../modules/nix-settings.nix
    ../../modules/nvim.nix
    ../../modules/sound-pipewire.nix
    ../../modules/ssd.nix
    ../../modules/ssh.nix
    ../../modules/suspend-then-hibernate.nix
    ../../modules/terminal.nix
    ../../modules/vm-variant.nix
    ../../modules/waydroid.nix
    ../../modules/wlan.nix
    ../../modules/zsh.nix
  ];
  specialArgs = {
    inherit inputs system stateVersion;
    user = "go2";
  };
}
