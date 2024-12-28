# Personal Dotfiles

My opinionated dotfiles that I use in MacOS and NixOS.

## How to install

Clone this repo:

```sh
git clone https://github.com/zahidkizmaz/dotfiles.git "$HOME/dotfiles"
```

### MacOS

Installation guide: [here](./nixos/hosts/mondo/README.md)

Managed by [nix-darwin](https://github.com/LnL7/nix-darwin) and flakes.
Install nix-darwin and run:

```sh
darwin-rebuild switch --flake .name-of-config
```

### NixOS

Installation guide: [here](./nixos/README.md)

Managed by flakes.

```sh
sudo nixos-rebuild switch --flake .name-of-config
```

OR

Using [nh](https://github.com/viperML/nh)

```sh
nh os switch
```

#### Creating symlinks

I use symlinks to manage dotfiles. [Stow](https://www.gnu.org/software/stow/) is my go to tool for managing the symlinks.

This helper script is automatically put in PATH by nix.
It creates symlinks automatically if the certain app is installed.

```sh
link-dotfiles
```

In case there is no nix:

```sh
bash nixos/bin/link-dotfiles.sh
```

### Only certain app dotfiles

Example for tmux:

```sh
stow -vSt ~ tmux
```

This creates symlinks to tmux config files in `~/.config/` folder.

### Current Setup

This setup includes:

-   Shell: zsh
-   Shell prompt: starship
-   Shell history: atuim
-   Shell tools: bat, direnv, fzf
-   Terminal emulator: kitty
-   Terminal multiplexer: tmux
-   Text editor / IDE: Neovim

#### NixOS specific

-   Window manager: Hyprland
-   Status bar: waybar
-   Notifications manager: dunst
-   Application launcher: anyrun, tofi

and more...
