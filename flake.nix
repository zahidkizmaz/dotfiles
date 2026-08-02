{
  description = "NixOS configurations";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
      "https://catppuccin.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    agenix.url = "github:ryantm/agenix";

    firefox-addons.url = "sourcehut:~rycee/nur-expressions?dir=pkgs/firefox-addons";

    catppuccin.url = "github:catppuccin/nix/release-26.05";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
    };
  };
  outputs =
    { nixpkgs-unstable, ... }@inputs:
    let
      stateVersion = "26.05";
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
        pi5 = import ./nixos/hosts/pi5 {
          stateVersion = stateVersion;
          inherit inputs;
        };
        sgo2 = import ./nixos/hosts/sgo2 {
          stateVersion = stateVersion;
          inherit inputs;
        };
      };
      darwinConfigurations = {
        MONDO-1192 = import ./nixos/hosts/mondo { inherit inputs stateVersion; };
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
