{ inputs, pkgs, user, ... }:

{
  home-manager = {
    extraSpecialArgs = { inherit inputs user; };
    users = { "zahid" = import ./home.nix; };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zahid = {
    isNormalUser = true;
    initialPassword = "${user}";
    description = "${user}";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "storage" "cups" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      feh
      kitty
      unzip
      zip
    ];
  };
  programs.zsh.enable = true;
  programs.direnv.enable = true;

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts-color-emoji
  ];

  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/kitty/.config/kitty /home/${user}/.config/kitty
      '';
  };
}
