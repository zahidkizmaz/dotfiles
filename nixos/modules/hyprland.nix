{ pkgs, user, ... }: {
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
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
