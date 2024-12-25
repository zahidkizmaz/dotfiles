{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man
    tealdeer
  ];

  system.activationScripts = {
    update-docs.text /*bash*/ =
      ''
        ${pkgs.tealdeer}/bin/tldr --update
      '';
  };
}
