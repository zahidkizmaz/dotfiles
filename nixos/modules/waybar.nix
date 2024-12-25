{ pkgs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  system.activationScripts = {
    waybar-env.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/waybar/.config/waybar /home/${user}/.config/waybar
      '';
  };
}
