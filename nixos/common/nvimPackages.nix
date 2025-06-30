{ pkgs }:
let
  nvimPackages = with pkgs; [
    neovim

    # Dependencies
    bat
    fzf
    gcc14
    nodePackages_latest.nodejs
    python313Packages.pynvim
    tree-sitter
    universal-ctags
    viu # fzf-lua

    # LSPs
    ansible-language-server
    basedpyright
    docker-compose-language-service
    dockerfile-language-server-nodejs
    htmx-lsp
    hyprls
    lemminx
    lua-language-server
    nixd
    nodePackages_latest.bash-language-server
    nodePackages_latest.typescript-language-server
    rust-analyzer
    tailwindcss-language-server
    taplo
    typos-lsp
    terraform-ls
    vimPlugins.SchemaStore-nvim
    vscode-langservers-extracted
    yaml-language-server

    # Linters&Formatters
    biome
    gitlint
    jq
    markdownlint-cli
    nixfmt-rfc-style
    prettierd
    shellcheck
    shfmt
    yamllint
  ];
in
nvimPackages
