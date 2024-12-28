# NixOS Darwin

## Installation

1. Install nix [package manager](https://nixos.org/download/#nix-install-macos)
2. Clone this repo:

    ```sh
        nix-shell -p gitMinimal --run 'git clone https://github.com/zahidkizmaz/dotfiles.git "$HOME/dotfiles"'
    ```

3. Build and switch to flake config

    ```sh
        nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/dotfiles#MONDO-1192
    ```
