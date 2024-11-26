{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man
    tealdeer
  ];

  system.userActivationScripts = {
    update-docs.text /*bash*/ =
      ''
        ${pkgs.tealdeer}/bin/tldr --update
      '';
  };
}
