{ inputs, ... }:
let
  system = "aarch64-darwin";
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    ./configuration.nix
    ./homebrew.nix
    ../../modules/ai.nix
    ../../modules/documentation.nix
    ../../modules/dotfiles.nix
    ../../modules/kitty.nix
    ../../modules/nix-settings.nix
    ../../modules/nvim.nix
    ../../modules/zsh.nix
  ];
  specialArgs = { inherit inputs system; user = "zahidkizmaz"; is_darwin = true; };
}
