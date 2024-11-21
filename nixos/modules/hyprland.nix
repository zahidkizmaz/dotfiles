{ pkgs, user, ... }:
{
  programs.hyprland = { enable = true; };

  environment.systemPackages = with pkgs;
    [
      hypridle
      hyprlock
      hyprsunset
    ];

  system.userActivationScripts = {
    hyprland-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/hypr/.config/hypr /home/${user}/.config/hypr
      '';
  };
}
