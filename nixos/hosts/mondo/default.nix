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
    ../../modules/ai.nix
    ../../modules/documentation.nix
    ../../modules/dotfiles.nix
    ../../modules/nix-settings.nix
    ../../modules/nvim.nix
    ../../modules/terminal.nix
    ../../modules/zsh.nix
  ];
  specialArgs = {
    inherit inputs system;
    user = "zahidkizmaz";
  };
}
