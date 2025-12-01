{
  description = "NixOS configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    agenix.url = "github:ryantm/agenix";

    firefox-addons.url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";

    mac-app-util.url = "github:hraban/mac-app-util";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs-unstable, ... }@inputs:
    let
      stateVersion = "25.11";
      forDefaultSystems = nixpkgs-unstable.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      nixosConfigurations = {
        fw13-amd = import ./nixos/hosts/fw13-amd {
          stateVersion = stateVersion;
          inherit inputs;
        };
        lenovo-y5070 = import ./nixos/hosts/lenovo-y5070 {
          stateVersion = stateVersion;
          inherit inputs;
        };
        nuc-g5 = import ./nixos/hosts/nuc-g5 {
          stateVersion = stateVersion;
          inherit inputs;
        };
        pi4b = import ./nixos/hosts/pi4b {
          stateVersion = stateVersion;
          inherit inputs;
        };
        sgo2 = import ./nixos/hosts/sgo2 {
          stateVersion = stateVersion;
          inherit inputs;
        };
      };
      darwinConfigurations = {
        MONDO-1192 = import ./nixos/hosts/mondo { inherit inputs; };
      };

      templates = {
        dev = {
          path = ./nixos/templates/dev;
          description = "Simple, all-rounder template devShell";
        };
        rust = {
          path = ./nixos/templates/rust;
          description = "Rust project starter";
        };
      };

      devShells = forDefaultSystems (
        system:
        let
          pkgs = import nixpkgs-unstable { inherit system; };
        in
        import ./dev-shell.nix { inherit pkgs; }
      );
    };
}
