{
  description = "Rust project using crane and fenix";
  inputs = {
    crane.url = "github:ipetkov/crane";
    fenix.url = "github:nix-community/fenix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      fenix,
      crane,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          pkgs,
          system,
          ...
        }:
        let
          rustToolchain = fenix.packages.${system}.stable.toolchain;
          craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;

          # Common arguments that are shared between buildPackage and clippy/test targets
          commonArgs = {
            src = craneLib.cleanCargoSource ./.;
            # Runtime dependencies
            nativeBuildInputs = with pkgs; [
              pkg-config
            ];
            buildInputs =
              [
                # Add additional build inputs here
              ]
              ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
                # Additional darwin specific inputs can be set here
                pkgs.libiconv
              ];
          };

          # Build *just* the cargo dependencies, so we can reuse
          # all of that work between builds and test runs
          cargoArtifacts = craneLib.buildDepsOnly commonArgs;

          # Build the actual crate
          crate = craneLib.buildPackage (
            commonArgs
            // {
              inherit cargoArtifacts;
              # Create a release build by default
              release = true;
              strictDeps = true;
            }
          );
        in
        {
          packages.default = crate;
          # Checks for CI/development
          checks = {
            fmt = craneLib.cargoFmt commonArgs;
            clippy = craneLib.cargoClippy (
              commonArgs
              // {
                inherit cargoArtifacts;
                cargoClippyExtraArgs = "-- --deny warnings";
              }
            );
            nextest = craneLib.cargoNextest (
              commonArgs
              // {
                inherit cargoArtifacts;
                partitions = 1;
                partitionType = "count";
              }
            );
          };
          devShells.default = pkgs.mkShell {
            inputsFrom = builtins.attrValues self'.checks;
            # Additional dev tools
            packages = with pkgs; [
              rustToolchain
              cargo-watch
              cargo-audit
              cargo-udeps
              rust-analyzer
            ];
          };
        };
    };
}
