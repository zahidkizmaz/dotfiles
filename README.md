# Personal Dotfiles
My dotfiles that used in MacOS and Arch Linux.

#### How to install

I use symlinks to manage dotfiles. [Stow](https://www.gnu.org/software/stow/) is my go to tool for managing the symlinks.

Example command:
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

#### Arch specific

- Window manager: BSPWM
- Status bar: polybar
- Login manager: ly
- Hotkey daemon: sxhkd
- Notifications manager: dunst
- Application launcher: rofi
