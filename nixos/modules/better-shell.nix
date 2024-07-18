{ pkgs, user, ... }:

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
    atuin
    bat
    btop
    delta
    fd
    gitMinimal
    jq
    just
    magic-wormhole
    man
    neovim
    ripgrep
    tree
    zoxide
  ];

  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/atuin/.config/atuin /home/${user}/.config/atuin
        ln -sfn /home/${user}/dotfiles/bat/.config/bat /home/${user}/.config/bat
        ln -sfn /home/${user}/dotfiles/git/.config/git /home/${user}/.config/git
        ln -sfn /home/${user}/dotfiles/starship/.config/starship.toml /home/${user}/.config/starship.toml
        ln -sfn /home/${user}/dotfiles/tmux/.config/tmux /home/${user}/.config/tmux
        ln -sfn /home/${user}/dotfiles/zsh/.config/zsh /home/${user}/.config/zsh
      '';
  };
}
