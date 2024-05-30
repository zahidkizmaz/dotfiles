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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
    } @ inputs: rec {
      images = {
        pi4b = (self.nixosConfigurations.pi4b.extendModules {
          modules = [
            "${nixpkgs-unstable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            {
              disabledModules = [ "hosts/pi4b/hardware-configuration.nix" ];
            }
          ];
        }).config.system.build.sdImage;
      };
      packages.x86_64-linux.pi-image = images.pi4b;
      packages.aarch64-linux.pi-image = images.pi4b;
      nixosConfigurations = {
        lenovo-y5070 = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/lenovo-y5070/configuration.nix
            home-manager.nixosModules.home-manager
            ./common/bluetooth.nix
            ./common/bootloader-systemd.nix
            ./common/gc.nix
            ./common/gui-applications.nix
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
            ./common/wlan.nix
          ];
          specialArgs = { inherit inputs; };
        };
        pi4b = nixpkgs-unstable.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            "${nixpkgs-unstable}/nixos/modules/profiles/minimal.nix"
            ./hosts/pi4b/hardware-configuration.nix
            ./hosts/pi4b/configuration.nix
            ./common/gc.nix
            ./common/nix-settings.nix
            ./common/podman.nix
            ./common/ssh.nix
          ];
          specialArgs = { inherit inputs; user = "pi"; };
        };
      };
    };
}
