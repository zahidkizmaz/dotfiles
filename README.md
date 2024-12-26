# Personal Dotfiles

My dotfiles that used in MacOS and NixOS.

## How to install

Clone this repo:

```sh
git clone git@github.com:zahidkizmaz/dotfiles.git "$HOME/dotfiles"
```

### MacOS

Managed by [nix-darwin](https://github.com/LnL7/nix-darwin) and flakes.
Install nix-darwin and run:

```sh
darwin-rebuild switch --flake .name-of-config
```

### NixOs

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

This helper script is automatically setup by nix.
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

This creates symlinks to tmux config files in `~/.config/` folder:

### Current Setup

- Shell: zsh
- Shell prompt: starship
- Terminal emulator: kitty
- Terminal multiplexer: tmux
- Text editor / IDE: Neovim

#### Nix specific

- Window manager: Hyprland
- Status bar: waybar
- Notifications manager: dunst
- Application launcher: anyrun
