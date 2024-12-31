{ pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    starship.enable = true;
    tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      terminal = "tmux-256color";
      baseIndex = 1;
      aggressiveResize = true;
      escapeTime = 10;
      plugins = with pkgs; [ tmuxPlugins.catppuccin ];
      extraConfig = ''
        # Pane Navigation
        bind -r C-h select-pane -L  # move left
        bind -r C-j select-pane -D  # move down
        bind -r C-k select-pane -U  # move up
        bind -r C-l select-pane -R  # move right
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    bat
    fd
    gitMinimal
    magic-wormhole
    neovim
    ripgrep
    unzip
    yazi
    zip
    zoxide
  ];
}
