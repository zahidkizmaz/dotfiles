{ inputs, pkgs, user, system, stateVersion, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  imports = [ ./anyrun.nix ];
  home-manager = {
    users = { "${user}" = import ./home.nix; };
    extraSpecialArgs = { inherit inputs user system stateVersion; };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${user}" = {
    isNormalUser = true;
    initialPassword = "${user}";
    description = "${user}";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "storage" "cups" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs-unstable; [
      gitMinimal
      just
      stow
      tree
      unzip
      yazi
      zip
    ];
  };

  programs = {
    zsh.enable = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Arimo" "IosevkaTerm" "Noto" "JetBrainsMono" ]; })
    noto-fonts-color-emoji
  ];

  system.userActivationScripts = {
    user-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/git/.config/git /home/${user}/.config/git
      '';
  };
}
