{
  description = "NixOS configuration";
  inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs2405.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    firefox-addons.url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
  };

  outputs =
    { self
    , nixos-hardware
    , nixpkgs-unstable
    , agenix
    , home-manager
    , disko
    , nix-ld
    , ...
    } @ inputs: rec {
      nixosConfigurations = {
        fw13-amd = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            # TODO: write fw13-amd specific config: such as disko
            ./nixos/hosts/fw13-amd/configuration.nix
            agenix.nixosModules.default
            disko.nixosModules.disko
            nix-ld.nixosModules.nix-ld
            home-manager.nixosModules.home-manager
            ./nixos/modules/agenix.nix
            ./nixos/modules/bluetooth.nix
            ./nixos/modules/bootloader-systemd.nix
            ./nixos/modules/gc.nix
            ./nixos/modules/gui-applications.nix
            ./nixos/modules/hyprland.nix
            ./nixos/modules/ld.nix
            ./nixos/modules/login-manager-tuigreet.nix
            ./nixos/modules/nix-settings.nix
            ./nixos/modules/nvim.nix
            ./nixos/modules/podman.nix
            ./nixos/modules/sound-pipewire.nix
            ./nixos/modules/ssh.nix
            ./nixos/modules/tailscale.nix
            ./nixos/modules/user-zahid.nix
            ./nixos/modules/virt-manager.nix
            ./nixos/modules/waybar.nix
            ./nixos/modules/wayland-desktop-environment.nix
            ./nixos/modules/wlan.nix
          ];
          specialArgs = { inherit inputs; user = "zahid"; };
        };
        lenovo-y5070 = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/hosts/lenovo-y5070/configuration.nix
            agenix.nixosModules.default
            disko.nixosModules.disko
            nix-ld.nixosModules.nix-ld
            home-manager.nixosModules.home-manager
            ./nixos/modules/agenix.nix
            ./nixos/modules/bluetooth.nix
            ./nixos/modules/bootloader-systemd.nix
            ./nixos/modules/gc.nix
            ./nixos/modules/gui-applications.nix
            ./nixos/modules/hyprland.nix
            ./nixos/modules/ld.nix
            ./nixos/modules/login-manager-tuigreet.nix
            ./nixos/modules/nix-settings.nix
            ./nixos/modules/nvim.nix
            ./nixos/modules/podman.nix
            ./nixos/modules/sound-pipewire.nix
            ./nixos/modules/ssh.nix
            ./nixos/modules/tailscale.nix
            ./nixos/modules/user-zahid.nix
            ./nixos/modules/virt-manager.nix
            ./nixos/modules/waybar.nix
            ./nixos/modules/wayland-desktop-environment.nix
            ./nixos/modules/wlan.nix
          ];
          specialArgs = { inherit inputs; user = "zahid"; };
        };
        pi4b = nixpkgs-unstable.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            "${nixpkgs-unstable}/nixos/modules/profiles/minimal.nix"
            agenix.nixosModules.default
            ./nixos/hosts/pi4b/hardware-configuration.nix
            ./nixos/hosts/pi4b/configuration.nix
            ./nixos/hosts/pi4b/caddy.nix
            ./nixos/containers/adguardhome.nix
            ./nixos/containers/unbound.nix
            ./nixos/modules/better-shell.nix
            ./nixos/modules/gc.nix
            ./nixos/modules/home-assistant
            ./nixos/modules/nix-settings.nix
            ./nixos/modules/podman.nix
            ./nixos/modules/ssh.nix
            ./nixos/modules/tailscale.nix
          ];
          specialArgs = { inherit inputs; user = "pi"; };
        };
      };
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
    };
}
