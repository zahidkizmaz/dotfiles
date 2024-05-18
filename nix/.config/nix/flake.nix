{
  description = "NixOS configuration";
  inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { self
    , nixpkgs2311
    , nixos-hardware
    , nixpkgs-unstable
    , home-manager
    , ...
    } @ inputs: {
      nixosConfigurations = {
        lenovo-y5070 = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/lenovo-y5070/configuration.nix
            home-manager.nixosModules.home-manager
            ./common/bluetooth.nix
            ./common/bootloader-systemd.nix
            ./common/gc.nix
            ./common/hyprland.nix
            ./common/login-manager-tuigreet.nix
            ./common/nix-settings.nix
            ./common/nvim.nix
            ./common/podman.nix
            ./common/sound-pipewire.nix
            ./common/user-zahid.nix
            ./common/virt-manager.nix
            ./common/waybar.nix
            ./common/wayland-desktop-environment.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
