{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man
    tealdeer
  ];

  system.userActivationScripts = {
    update-docs.text =
      ''
        ${pkgs.tealdeer}/bin/tldr --update
      '';
  };
}
