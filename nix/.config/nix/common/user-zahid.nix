{ inputs, pkgs, ... }:

{
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "zahid" = import ./home.nix; };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zahid = {
    isNormalUser = true;
    description = "zahid";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "storage" "cups" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      atuin
      bat
      copyq
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
    nerdfonts
    noto-fonts-color-emoji
  ];
}
