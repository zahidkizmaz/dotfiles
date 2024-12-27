{ inputs, pkgs, user, system, stateVersion, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  imports = [ ./anyrun.nix ./zsh.nix ];
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
      zip
    ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Arimo" "IosevkaTerm" "Noto" "JetBrainsMono" ]; })
    noto-fonts-color-emoji
  ];
}
