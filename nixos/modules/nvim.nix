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
    universal-ctags
    viu
    chafa # fzf-lua
    python312Packages.pynvim
    nodePackages_latest.nodejs

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
    prettierd
    rust-analyzer
    tailwindcss-language-server
    taplo
    typos-lsp
    vimPlugins.SchemaStore-nvim
    vscode-langservers-extracted
    yaml-language-server

    # Linters&Formatters
    biome
    gawk
    gitlint
    nixpkgs-fmt
    ruff
    rustfmt
    shellcheck
    shfmt
    sqlfluff
    stylua
    markdownlint-cli
    yamllint
  ];
}
