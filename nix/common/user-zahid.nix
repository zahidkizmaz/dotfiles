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
      bat
      firefox
      flatpak
      fzf
      git
      kitty
      neofetch
      powertop
      ripgrep
      starship
      stow
      tmux
      tree
      universal-ctags
      unzip
      zoxide

      # themes
      arc-theme
      papirus-icon-theme
    ];
  };
  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
      nerdfonts
      noto-fonts-color-emoji
  ];
}
