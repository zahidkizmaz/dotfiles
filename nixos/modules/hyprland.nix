{ inputs, user, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;
  };

  environment.systemPackages = with pkgs-unstable;
    [
      hypridle
      hyprlock
      xdg-desktop-portal-hyprland
    ];

  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/hypr/.config/hypr /home/${user}/.config/hypr
      '';
  };
}
