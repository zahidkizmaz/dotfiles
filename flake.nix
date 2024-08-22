{
  description = "NixOS configurations";
  inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
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
    { self, nixpkgs-unstable, ... } @ inputs:
    let
      forDefaultSystems = nixpkgs-unstable.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    rec {
      nixosConfigurations = {
        fw13-amd = import ./nixos/hosts/fw13-amd { inherit inputs; };
        lenovo-y5070 = import ./nixos/hosts/lenovo-y5070 { inherit inputs; };
        nuc-g5 = import ./nixos/hosts/nuc-g5 { inherit inputs; };
        pi4b = import ./nixos/hosts/pi4b { inherit inputs; };
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

      devShells = forDefaultSystems
        (system:
          let
            pkgs = nixpkgs-unstable.legacyPackages.${system};
          in
          import ./dev-shell.nix { inherit pkgs; }
        );
    };
}
