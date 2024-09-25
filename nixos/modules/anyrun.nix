{ inputs, system, user, ... }:
{
  environment.systemPackages = [
    inputs.anyrun.packages.${system}.anyrun-with-all-plugins
  ];

  system.userActivationScripts = {
    anyrun-dots.text =
      ''
        ln -sfn /home/${user}/dotfiles/anyrun/.config/anyrun /home/${user}/.config/
      '';
  };
}
