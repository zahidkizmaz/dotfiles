{ pkgs, inputs, user, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  system.activationScripts = {
    link-waybar.text =
      ''
        ln -sfn ../../waybar/.config/waybar /home/${user}/.config/waybar
      '';
  };

}
