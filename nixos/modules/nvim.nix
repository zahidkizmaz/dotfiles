{ inputs, pkgs, user, ... }:
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

  system.userActivationScripts = {
    nvim-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/bat/.config/bat /home/${user}/.config/bat
        ln -sfn /home/${user}/dotfiles/ctags/.ctagsd /home/${user}/.ctagsd
        ln -sfn /home/${user}/dotfiles/fzf/.fzf.zsh /home/${user}/.fzf.zsh
        ln -sfn /home/${user}/dotfiles/nvim/.config/nvim /home/${user}/.config/nvim

        ${pkgs-unstable.bat}/bin/bat cache --build

        if [ ! -d "$HOME/.cache/tags" ]; then
          mkdir -p "$HOME/.cache/tags"
        fi
      '';
  };
}
