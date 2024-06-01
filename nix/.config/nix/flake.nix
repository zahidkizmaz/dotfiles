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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { self
    , nixpkgs2311
    , nixos-hardware
    , nixpkgs-unstable
    , home-manager
    , disko
    , nix-ld
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
            disko.nixosModules.disko
            nix-ld.nixosModules.nix-ld
            home-manager.nixosModules.home-manager
            ./modules/bluetooth.nix
            ./modules/bootloader-systemd.nix
            ./modules/gc.nix
            ./modules/gui-applications.nix
            ./modules/hyprland.nix
            ./modules/login-manager-tuigreet.nix
            ./modules/nix-settings.nix
            ./modules/nvim.nix
            ./modules/podman.nix
            ./modules/sound-pipewire.nix
            ./modules/ssh.nix
            ./modules/user-zahid.nix
            ./modules/virt-manager.nix
            ./modules/waybar.nix
            ./modules/wayland-desktop-environment.nix
            ./modules/wlan.nix
          ];
          specialArgs = { inherit inputs; user = "zahid"; };
        };
        pi4b = nixpkgs-unstable.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            "${nixpkgs-unstable}/nixos/modules/profiles/minimal.nix"
            ./hosts/pi4b/hardware-configuration.nix
            ./hosts/pi4b/configuration.nix
            ./modules/gc.nix
            ./modules/home-assistant
            ./modules/nix-settings.nix
            ./modules/podman.nix
            ./modules/ssh.nix
            ./modules/tailscale.nix
          ];
          specialArgs = { inherit inputs; user = "pi"; };
        };
      };
    };
}
