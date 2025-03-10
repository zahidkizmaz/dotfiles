{ inputs, ... }:
let
  system = "aarch64-darwin";
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    inputs.mac-app-util.darwinModules.default
    ./configuration.nix
    ./gui-applications.nix
    ./homebrew.nix
    ./packages.nix
    ../../modules/ai.nix
    ../../modules/cli-tools.nix
    ../../modules/documentation.nix
    ../../modules/dotfiles.nix
    ../../modules/nix-settings.nix
    ../../modules/nvim.nix
    ../../modules/terminal.nix
  ];
  specialArgs = {
    inherit inputs system;
    user = "zahidkizmaz";
  };
}
