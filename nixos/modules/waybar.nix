{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  system.userActivationScripts = {
    waybar-env.text =
      ''
        ln -sfn /home/${user}/dotfiles/waybar/.config/waybar /home/${user}/.config/waybar
      '';
  };
}
