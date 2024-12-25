{ inputs, system, user, ... }:
{
  environment.systemPackages = [
    inputs.anyrun.packages.${system}.anyrun-with-all-plugins
  ];

  system.activationScripts = {
    anyrun-dots.text /*bash*/ =
      ''
        ln -sfn /home/${user}/dotfiles/anyrun/.config/anyrun /home/${user}/.config/
      '';
  };
}
