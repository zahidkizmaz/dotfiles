{ pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true; # because of tabnine
  environment.systemPackages = with pkgs; [
    neovim

    # Dependencies
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
}