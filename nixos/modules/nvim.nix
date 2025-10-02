{ inputs, pkgs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
  };
in
{
  environment.systemPackages = with pkgs-unstable; [
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
    basedpyright
    docker-compose-language-service
    dockerfile-language-server
    emmylua-ls
    htmx-lsp
    hyprls
    lemminx
    nixd
    nodePackages_latest.bash-language-server
    nodePackages_latest.typescript-language-server
    rust-analyzer
    tailwindcss-language-server
    taplo
    terraform-ls
    ty
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
    nixfmt-rfc-style
    prettierd
    shellcheck
    shfmt
    yamlfmt
    yamllint
  ];
}
