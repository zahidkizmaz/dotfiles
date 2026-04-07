{ inputs, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  environment.systemPackages = with pkgs-unstable; [
    neovim

    # Dependencies
    bat
    fzf
    gcc14
    nodejs-slim_25
    python313Packages.pynvim
    tree-sitter
    universal-ctags
    viu # fzf-lua

    # LSPs
    bash-language-server
    docker-compose-language-service
    dockerfile-language-server
    emmylua-ls
    htmx-lsp
    hyprls
    lemminx
    nixd
    rust-analyzer
    tailwindcss-language-server
    taplo
    terraform-ls
    ty
    typescript-language-server
    typos-lsp
    vacuum-go
    vimPlugins.SchemaStore-nvim
    vscode-langservers-extracted
    yaml-language-server

    # Linters&Formatters
    biome
    gitlint
    jq
    markdownlint-cli
    nixfmt
    prettierd
    shellcheck
    shfmt
    yamlfmt
    yamllint
  ];
}
