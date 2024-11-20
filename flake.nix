{
  description = "NixOS configurations";
  inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons.url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";
  };
  outputs =
    { self, nixpkgs-unstable, ... } @ inputs:
    let
      stateVersion = "24.11";
      forDefaultSystems = nixpkgs-unstable.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    rec {
      nixosConfigurations = {
        fw13-amd = import ./nixos/hosts/fw13-amd { stateVersion = stateVersion; inherit inputs; };
        lenovo-y5070 = import ./nixos/hosts/lenovo-y5070 { stateVersion = stateVersion; inherit inputs; };
        nuc-g5 = import ./nixos/hosts/nuc-g5 { stateVersion = stateVersion; inherit inputs; };
        pi4b = import ./nixos/hosts/pi4b { stateVersion = stateVersion; inherit inputs; };
        sgo2 = import ./nixos/hosts/sgo2 { stateVersion = stateVersion; inherit inputs; };
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
            pkgs = import nixpkgs-unstable { inherit system; };
          in
          import ./dev-shell.nix { inherit pkgs; }
        );
    };
}
