{ inputs, ... }:
let
  system = "aarch64-darwin";
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    ./configuration.nix
    ../../modules/documentation.nix
    ../../modules/dotfiles.nix
    ../../modules/kitty.nix
    ../../modules/nix-settings.nix
    ../../modules/nvim.nix
    ../../modules/ollama.nix
    ../../modules/zsh.nix
  ];
  specialArgs = { inherit inputs system; user = "zahidkizmaz"; };
}
