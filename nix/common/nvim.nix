{pkgs, ...}:

{

  nixpkgs.config.allowUnfree = true; # because of tabnine
  environment.systemPackages = [
    pkgs.neovim

    # LSPs
    pkgs.ansible-language-server
    pkgs.docker-compose-language-service
    pkgs.dockerfile-language-server-nodejs
    pkgs.efm-langserver
    pkgs.htmx-lsp
    pkgs.lemminx
    pkgs.lua-language-server
    pkgs.nil
    pkgs.nodePackages_latest.bash-language-server
    pkgs.nodePackages_latest.typescript-language-server
    pkgs.nodePackages_latest.vscode-css-languageserver-bin
    pkgs.nodePackages_latest.vscode-json-languageserver-bin
    pkgs.python311Packages.pylsp-mypy
    pkgs.python311Packages.python-lsp-server
    pkgs.rust-analyzer
    pkgs.tabnine
    pkgs.tailwindcss-language-server
    pkgs.taplo
    pkgs.typos-lsp
    pkgs.yaml-language-server

    # Linters&Formatters
    pkgs.ansible-lint
    pkgs.djhtml
    pkgs.gawk
    pkgs.gitlint
    pkgs.nodePackages_latest.eslint
    pkgs.nodePackages_latest.prettier
    pkgs.prettierd
    pkgs.ruff
    pkgs.rustfmt
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.sqlfluff
    pkgs.stylua
    pkgs.yamllint
  ];
}
