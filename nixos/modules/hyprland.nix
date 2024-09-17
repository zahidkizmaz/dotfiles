{ inputs, user, system, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
in
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  environment.systemPackages = with pkgs-unstable;
    [
      hypridle
      hyprlock
    ];

  system.userActivationScripts = {
    desktop-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/hypr/.config/hypr /home/${user}/.config/hypr
      '';
  };
}
