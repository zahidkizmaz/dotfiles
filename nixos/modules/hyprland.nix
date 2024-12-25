{ pkgs, user, ... }:
{
  programs.hyprland = { enable = true; };

  environment.systemPackages = with pkgs;
    [
      hypridle
      hyprlock
      hyprsunset
    ];

  system.activationScripts = {
    hyprland-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/hypr/.config/hypr /home/${user}/.config/hypr
      '';
  };
}
