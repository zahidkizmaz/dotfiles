{ inputs, pkgs, user, ... }:

{
  home-manager = {
    extraSpecialArgs = { inherit inputs user; };
    users = { "${user}" = import ./home.nix; };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zahid = {
    isNormalUser = true;
    initialPassword = "${user}";
    description = "${user}";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "storage" "cups" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      atuin
      bat
      copyq
      delta
      easyeffects
      fd
      feh
      fzf
      gitMinimal
      just
      jq
      kitty
      man
      neovim
      ripgrep
      starship
      stow
      tmux
      tree
      unzip
      zip
      zoxide
    ];
  };
  programs.zsh.enable = true;
  programs.direnv.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "IosevkaTerm" "Noto" "JetBrainsMono" ]; })
    noto-fonts-color-emoji
  ];

  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/atuin/.config/atuin /home/${user}/.config/atuin
        ln -sfn /home/${user}/dotfiles/bat/.config/bat /home/${user}/.config/bat
        ln -sfn /home/${user}/dotfiles/git/.config/git /home/${user}/.config/git
        ln -sfn /home/${user}/dotfiles/kitty/.config/kitty /home/${user}/.config/kitty
        ln -sfn /home/${user}/dotfiles/starship/.config/starship.toml /home/${user}/.config/starship.toml
        ln -sfn /home/${user}/dotfiles/tmux/.config/tmux /home/${user}/.config/tmux
        ln -sfn /home/${user}/dotfiles/zsh/.config/zsh /home/${user}/.config/zsh
        ln -sfn /home/${user}/dotfiles/zsh/.zshenv /home/${user}/.zshenv
      '';
  };
}
