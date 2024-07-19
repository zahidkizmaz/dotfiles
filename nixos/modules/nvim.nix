{ pkgs, user, ... }:

{

  nixpkgs.config.allowUnfree = true; # because of tabnine
  environment.systemPackages = with pkgs; [
    neovim

    # Dependencies
    bat
    fzf
    viu
    universal-ctags

    # LSPs
    ansible-language-server
    basedpyright
    docker-compose-language-service
    dockerfile-language-server-nodejs
    efm-langserver
    htmx-lsp
    lemminx
    lua-language-server
    nixd
    nodePackages_latest.bash-language-server
    nodePackages_latest.typescript-language-server
    vscode-langservers-extracted
    rust-analyzer
    tabnine
    tailwindcss-language-server
    taplo
    typos-lsp
    vimPlugins.SchemaStore-nvim
    yaml-language-server

    # Linters&Formatters
    ansible-lint
    djhtml
    gawk
    gitlint
    nixpkgs-fmt
    nodePackages_latest.eslint
    nodePackages_latest.prettier
    prettierd
    ruff
    rustfmt
    rustup
    shellcheck
    shfmt
    sqlfluff
    stylua
    yamllint
  ];

  system.userActivationScripts = {
    desktop-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/bat/.config/bat /home/${user}/.config/bat
        ln -sfn /home/${user}/dotfiles/ctags/.ctagsd /home/${user}/.ctagsd
        ln -sfn /home/${user}/dotfiles/fzf/.fzf.zsh /home/${user}/.fzf.zsh
        ln -sfn /home/${user}/dotfiles/nvim/.config/nvim /home/${user}/.config/nvim
        ln -sfn /home/${user}/dotfiles/efm-langserver/.config/efm-langserver /home/${user}/.config/efm-langserver
      '';
  };
}
